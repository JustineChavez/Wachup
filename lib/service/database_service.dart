import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
  final CollectionReference topicCollection =
      FirebaseFirestore.instance.collection("topics");
  final CollectionReference gameCollection =
      FirebaseFirestore.instance.collection("games");

  // saving the userdata
  Future savingUserData(String fullName, String email, String accountType,
      String userLanguage) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "accountType": accountType,
      "userLanguage": userLanguage,
      "groups": [],
      "topics": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // creating a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // search
  searchByName(String groupName) async {
    QuerySnapshot snapshot =
        await groupCollection.where("groupName", isEqualTo: groupName).get();
    return snapshot;
  }

  // function -> bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  // get topics
  Future getAllTopics() async {
    return userCollection.doc(uid).snapshots();
  }

  // creating a topic
  Future createTopic(String id, String creatorName, String topicName,
      String topicSubject, String topicAbout) async {
    DocumentReference topicDocumentReference = await topicCollection.add({
      "topicId": "",
      "creator": "${id}_$creatorName",
      "topicName": topicName,
      "topicSubject": topicSubject,
      "topicAbout": topicAbout,
      "topicIcon": ""
      // "topicImageContent": [],
      // "topicVideoContent": [],
      // "topicPDFContent": [],
      // "topicFileContent": []
    });
    // update the members
    await topicDocumentReference.update({
      "topicId": topicDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "topics": FieldValue.arrayUnion(
          ["${topicDocumentReference.id}_${topicName}_$topicSubject"])
    });
  }

  // getting topic details
  Future gettingTopicData(topicId) async {
    QuerySnapshot snapshot =
        await topicCollection.where("topicName", isEqualTo: topicId).get();
    return snapshot;
  }

  // add content
  addFileContent(String topicId, Map<String, dynamic> fileData) async {
    topicCollection.doc(topicId).collection("topicFileContent").add(fileData);
  }

  // add video
  addVideoContent(String topicId, Map<String, dynamic> videoData) async {
    topicCollection.doc(topicId).collection("topicVideoContent").add(videoData);
  }

  // add images
  addImageContent(String topicId, Map<String, dynamic> imageData) async {
    topicCollection.doc(topicId).collection("topicImageContent").add(imageData);
  }

  // getting the files
  getFileContent(String topicId) async {
    return topicCollection
        .doc(topicId)
        .collection("topicFileContent")
        .snapshots();
  }

  // getting the videos
  getVideoContent(String topicId) async {
    return topicCollection
        .doc(topicId)
        .collection("topicVideoContent")
        .snapshots();
  }

  // getting the images
  getImageContent(String topicId) async {
    return topicCollection
        .doc(topicId)
        .collection("topicImageContent")
        .snapshots();
  }

  Future getTopicCreator(String topicId) async {
    DocumentReference d = topicCollection.doc(topicId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['creator'];
  }

  getTopicAbout(String topicId) async {
    DocumentReference d = topicCollection.doc(topicId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['topicAbout'];
  }

  // search
  searchTopicByName(String topicName) async {
    QuerySnapshot snapshot =
        await topicCollection.where("topicName", isEqualTo: topicName).get();
    return snapshot;
  }

  // function -> bool
  Future<bool> isTopicAdded(String topicName, String topicId, String fullName,
      String topicSubject) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> topics = await documentSnapshot['topics'];
    if (topics.contains("${topicId}_${topicName}_$topicSubject")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleTopicAdd(String topicId, String userName, String topicName,
      String topicSubject) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> topics = await documentSnapshot['topics'];

    // if user has our groups -> then remove then or also in other part re join
    if (topics.contains("${topicId}_$topicName")) {
      await userDocumentReference.update({
        "topics":
            FieldValue.arrayRemove(["${topicId}_${topicName}_$topicSubject"])
      });
    } else {
      await userDocumentReference.update({
        "topics":
            FieldValue.arrayUnion(["${topicId}_${topicName}_$topicSubject"])
      });
    }
  }
}
