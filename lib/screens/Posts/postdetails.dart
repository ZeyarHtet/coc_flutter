import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/constant.dart';

class PostDetailsPage extends StatefulWidget {
  final classpostlistmodel eachPost;
  const PostDetailsPage({
    super.key,
    required this.eachPost,
  });

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  late classpostlistmodel eachPost;
  List detailsImageList = [];
  @override
  void initState() {
    getInitData();
    super.initState();
  }

  getInitData() {
    eachPost = widget.eachPost;
    detailsImageList = [];
    if (eachPost.postDetails.isNotEmpty) {
      for (var i = 0; i < eachPost.postDetails.length; i++) {
        // if (eachPost.postDetails[i]["type"].toString() == "2") {
        detailsImageList.add({
          "caption": eachPost.postDetails[i]["caption"],
          "image":
              "$miniohttp/coc/post_images/${eachPost.postDetails[i]["content"]}",
        });
        // }
      }
    }
    setState(() {
      print(">>>>>>>>>> details $detailsImageList");
    });
  }

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
        title: Text(
          eachPost.title,
          style: appbarTextStyle(maincolor),
        ),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: detailsImageList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: (MediaQuery.of(context).size.width) / 2,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    child: CachedNetworkImage(
                      imageUrl: detailsImageList[index]["image"],
                      placeholder: (context, url) => Container(),
                      errorWidget: (context, url, error) => Container(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
