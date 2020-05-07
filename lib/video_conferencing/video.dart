import 'package:flutter/material.dart';
import 'package:teacheralpine/video_conferencing/src/pages/index.dart';

class video extends StatefulWidget {
  @override
  _videoState createState() => _videoState();
}

class _videoState extends State<video> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Conference"),
        elevation: 0.1,
        centerTitle: true,
      ),
      backgroundColor: Color.fromRGBO(58, 66, 86,1.0),
      body: IndexPage(),
    );
  }
}
