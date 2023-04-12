import 'package:flutter/material.dart';

import '../shared/constants.dart';

class VideoTile extends StatefulWidget {
  final String content;

  const VideoTile({Key? key, required this.content}) : super(key: key);

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // nextScreen(
        //     context,
        //     ChatPage(
        //       groupId: widget.groupId,
        //       groupName: widget.groupName,
        //       userName: widget.userName,
        //     ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              "V",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Constants().customBackColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
          title: const Text(
            "Video File",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            widget.content,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
