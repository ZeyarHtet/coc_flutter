import 'package:cached_network_image/cached_network_image.dart';
import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BlogDetailScreen extends StatefulWidget {
  EachGetpost thepost;
  BlogDetailScreen({super.key, required this.thepost});

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  late EachGetpost thepost;
  List<Widget> columnlist = [];
  @override
  void initState() {
    setState(() {
      thepost = widget.thepost;
      for (var i = 0; i < thepost.postDetails.length; i++) {
        print('Each type >>>> ${thepost.postDetails[i].type}');
        if (thepost.postDetails[i].type == '2') {
          columnlist.add(Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: CachedNetworkImage(
              imageBuilder: (context, imageProvider) => Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: darkmain,
                  image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter:
                          ColorFilter.mode(trandarkmain, BlendMode.colorBurn)),
                ),
              ),
              imageUrl:
                  '$miniohttp/coc/post_images/${thepost.postDetails[i].content}',
              placeholder: (context, url) => SpinKitCubeGrid(
                size: 5,
                color: paledarkmain,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ));
        } else if (thepost.postDetails[i].type == '1') {
          columnlist.add(Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              thepost.postDetails[i].content,
              style: labelTextStyle,
            ),
          ));
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backcolor,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: seccolor),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    thepost.title,
                    style: appbarTextStyle(seccolor),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${postsdatechange(thepost.createdAt)}. ',
                        style: secondTextstyle(seccolor),
                      ),
                      // const SizedBox(
                      //   width: 8,
                      // ),
                      Icon(
                        Icons.star_rounded,
                        color: paledarkmain,
                        size: 15,
                      ),
                      Text(
                        ' All',
                        style: secondTextstyle(seccolor),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(
                Icons.more_horiz_rounded,
                color: seccolor,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnlist,
            ),
          ),
        ),
      ),
    );
  }
}
