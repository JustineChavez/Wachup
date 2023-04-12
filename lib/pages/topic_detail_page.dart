import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_wachup/pages/group_info.dart';
import 'package:flutter_wachup/pages/upload/upload_file.dart';
import 'package:flutter_wachup/pages/upload/upload_image.dart';
import 'package:flutter_wachup/service/database_service.dart';
import 'package:flutter_wachup/widgets/message_tile.dart';
import 'package:flutter_wachup/widgets/sample_square.dart';
import 'package:flutter_wachup/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../global/language.dart';
import '../shared/constants.dart';
import '../shared/constants_v2.dart';
import '../widgets/file_tile.dart';
import '../widgets/image_tile.dart';
import '../widgets/video_tile.dart';

class TopicDetailPage extends StatefulWidget {
  final String creator;
  final String topicId;
  final String topicName;
  final String topicSubject;
  const TopicDetailPage(
      {Key? key,
      required this.creator,
      required this.topicId,
      required this.topicName,
      required this.topicSubject})
      : super(key: key);

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  Stream<QuerySnapshot>? files;
  Stream<QuerySnapshot>? videos;
  Stream<QuerySnapshot>? images;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  String about = "";
  String pathFile = "Upload a file...";

  @override
  void initState() {
    getFileContents();
    getVideoContents();
    getImageContents();
    getTopicAbout();
    super.initState();
  }

  getFileContents() {
    DatabaseService().getFileContent(widget.topicId).then((val) {
      setState(() {
        files = val;
      });
    });
  }

  getVideoContents() {
    DatabaseService().getVideoContent(widget.topicId).then((val) {
      setState(() {
        videos = val;
      });
    });
  }

  getImageContents() {
    DatabaseService().getImageContent(widget.topicId).then((val) {
      setState(() {
        images = val;
      });
    });
  }

  getTopicAbout() {
    DatabaseService().getTopicAbout(widget.topicId).then((val) {
      setState(() {
        about = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Constants().customColor1,
          appBar: AppBar(
            backgroundColor: Constants().customColor1,
            elevation: 0,
          ),
          body:
              //buildContainer(context),
              //buildStackContent(context),
              //customLiquid()
              Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.topicSubject,
                      style: TextStyle(
                        color: Constants().customBackColor,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.topicName,
                      style: TextStyle(
                          color: Constants().customBackColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      about,
                      style: TextStyle(
                          color: Constants().customBackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                color: Constants().customBackColor,
                child: TabBar(tabs: [
                  Tab(
                      icon: Icon(
                    Icons.file_copy_rounded,
                    color: Constants().customColor1,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.photo,
                    color: Constants().customColor1,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.video_camera_back_rounded,
                    color: Constants().customColor1,
                  ))
                ]),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                        color: Constants().customBackColor,
                        child: fileContents()),
                    Container(
                        color: Constants().customBackColor,
                        child: imageContents()),
                    Container(
                        color: Constants().customBackColor,
                        child: videoContents()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  //color: Constants().customBackColor,
                  child: Row(children: [
                    Expanded(child: Text(pathFile)
                        //     TextField(
                        //   controller: messageController,
                        //   style: TextStyle(color: Constants().customBackColor),
                        //   decoration: InputDecoration(
                        //     hintText: Locales.string(context, "message_send_hint"),
                        //     hintStyle: TextStyle(
                        //         color: Constants().customBackColor, fontSize: 16),
                        //     border: InputBorder.none,
                        //   ),
                        // )
                        ),
                    const SizedBox(
                      width: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        addFile();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                            child: Icon(
                          Icons.add_box_rounded,
                          color: Constants().customBackColor,
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        addImage();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                            child: Icon(
                          Icons.add_a_photo_rounded,
                          color: Constants().customBackColor,
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        addVideo();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                            child: Icon(
                          Icons.add_reaction_rounded,
                          color: Constants().customBackColor,
                        )),
                      ),
                    )
                  ]),
                ),
              ),
              // const SizedBox(
              //   height: 5,
              // )
            ],
          )),
    );
  }

  Stack buildStackContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        // chat messages here
        fileContents(),
        videoContents(),
        imageContents(),
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            width: MediaQuery.of(context).size.width,
            color: Constants().customForeColor,
            child: Row(children: [
              Expanded(
                  child: TextFormField(
                controller: messageController,
                style: TextStyle(color: Constants().customBackColor),
                decoration: InputDecoration(
                  hintText: Locales.string(context, "message_send_hint"),
                  hintStyle: TextStyle(
                      color: Constants().customBackColor, fontSize: 16),
                  border: InputBorder.none,
                ),
              )),
              const SizedBox(
                width: 12,
              ),
              GestureDetector(
                onTap: () {
                  addFile();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.add_box_rounded,
                    color: Constants().customBackColor,
                  )),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  addImage();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.add_a_photo_rounded,
                    color: Constants().customBackColor,
                  )),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  addVideo();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.add_reaction_rounded,
                    color: Constants().customBackColor,
                  )),
                ),
              )
            ]),
          ),
        )
      ],
    );
  }

  fileContents() {
    return StreamBuilder(
      stream: files,
      builder: (context, AsyncSnapshot snapshot) {
        //snapshot.hasData ? print(1) : print(2);
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return FileTile(
                      content: snapshot.data.docs[index]['content']);
                },
              )
            : Container();
      },
    );
  }

  videoContents() {
    return StreamBuilder(
      stream: videos,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return VideoTile(
                      content: snapshot.data.docs[index]['content']);
                },
              )
            : Container();
      },
    );
  }

  imageContents() {
    return StreamBuilder(
      stream: images,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ImageTile(
                      content: snapshot.data.docs[index]['content']);
                },
              )
            : Container();
      },
    );
  }

  addFile() {
    // if (messageController.text.isNotEmpty) {
    //   Map<String, dynamic> fileContentMap = {
    //     "content": messageController.text,
    //     "time": DateTime.now().millisecondsSinceEpoch,
    //   };

    //   DatabaseService().addFileContent(widget.topicId, fileContentMap);
    //   setState(() {
    //     messageController.clear();
    //   });
    // }
    nextScreen(context, UploadFilePage(topicId: widget.topicId));
  }

  addVideo() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> videoContentMap = {
        "content": messageController.text,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().addVideoContent(widget.topicId, videoContentMap);
      setState(() {
        messageController.clear();
      });
    }
  }

  addImage() {
    // if (messageController.text.isNotEmpty) {
    //   Map<String, dynamic> imageContentMap = {
    //     "content": messageController.text,
    //     "time": DateTime.now().millisecondsSinceEpoch,
    //   };

    //   DatabaseService().addImageContent(widget.topicId, imageContentMap);
    //   setState(() {
    //     messageController.clear();
    //   });
    // }
    nextScreen(context, UploadImagePage(topicId: widget.topicId));
  }
}
