import 'package:flutter/material.dart';

import '../../model/constant.dart';

class PostInside extends StatefulWidget {
  const PostInside({super.key});

  @override
  State<PostInside> createState() => _PostInsideState();
}

class _PostInsideState extends State<PostInside> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: backcolor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: darkmain,
        iconTheme: IconThemeData(
          color: maincolor,
          size: 30,
        ),
        title: Text("Post", style: appbarTextStyle(maincolor)),
      ),
    );
  }
}