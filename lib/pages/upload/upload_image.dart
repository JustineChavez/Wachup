import 'dart:io';

import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_wachup/pages/auth/login_page.dart';
import 'package:flutter_wachup/pages/home_page.dart';
import 'package:flutter_wachup/service/auth_service.dart';
import 'package:flutter_wachup/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../service/database_service.dart';
import '../../shared/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImagePage extends StatefulWidget {
  String topicId;
  UploadImagePage({Key? key, required this.topicId}) : super(key: key);

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  AuthService authService = AuthService();
  PlatformFile? pickedFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().customColor2,
      appBar: buildAppBar(context),
      body: buildContainer(context),
    );
  }

  SingleChildScrollView buildContainer(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.3),
                  //height: size.height * 0.5,
                  decoration: BoxDecoration(
                      color: Constants().customBackColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Upload an Image",
                        style: TextStyle(
                            color: Constants().customBackColor,
                            fontSize: 23,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      if (pickedFile != null)
                        Expanded(
                            child: Image.file(
                          File(pickedFile!.path!),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )),
                      const SizedBox(
                        height: 150,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Constants().customColor2,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: Text(
                            "Select Image",
                            style: TextStyle(
                                color: Constants().customBackColor,
                                fontSize: 16),
                          ),
                          onPressed: () {
                            selectFile();
                            //login();
                            //loginOffline();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Constants().customColor2,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: Text(
                            "Upload",
                            style: TextStyle(
                                color: Constants().customBackColor,
                                fontSize: 16),
                          ),
                          onPressed: () {
                            uploadFile();
                            //login();
                            //loginOffline();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Constants().customColor2,
      elevation: 0,
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = "files/${pickedFile!.name}";
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
  }

  addFile() {
    if (pickedFile!.name.isNotEmpty) {
      Map<String, dynamic> fileContentMap = {
        "content": pickedFile,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().addFileContent(widget.topicId, fileContentMap);
    }
  }
}
