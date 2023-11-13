import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:class_on_cloud/model/api.dart';
import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/screens/home.dart';
import 'package:class_on_cloud/screens/teacherprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImagepreviewScreen extends StatefulWidget {
  String imagepath;
  int contenttype;
  ImagepreviewScreen(
      {super.key, required this.imagepath, required this.contenttype});

  @override
  State<ImagepreviewScreen> createState() => _ImagepreviewScreenState();
}

class _ImagepreviewScreenState extends State<ImagepreviewScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? galaryimage;
  Future<void> _selectImage() async {
    galaryimage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 100000000000,
        maxHeight: 100000000000,
        imageQuality: 100);
    // imagepath = pickedFile == null ? null : !pickedFile.path.toString();
    // pickedFile == null ? null : galaryimage = pickedFile;
    print('Path >> $galaryimage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backcolor,
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: backcolor,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: darkmain),
              onPressed: () => Navigator.pop(context)),
          // actions: [
          //   widget.contenttype == 2
          //       ? GestureDetector(
          //           onTap: () async {
          //             var res = await uploadprofile(widget.imagepath);
          //             if (res['returncode'] == '200') {
          //               showToast('image is uploaded', 'green');
          //             } else {
          //               showToast('${res["message"]}', 'red');
          //             }
          //             // print(res);
          //           },
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Padding(
          //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //                 child: Text(
          //                   'Upload',
          //                   style: TextStyle(
          //                       color: seccolor,
          //                       fontSize: ScreenUtil().setSp(16),
          //                       fontWeight: FontWeight.w500),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         )
          //       : Container()
          // ],
          title: Text("Profile", style: appbarTextStyle(darkmain))),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "A picture helps people recognize you and lets you know when you're signed in to your account.",
                style: secondTextstyle(Colors.grey[600]),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            widget.contenttype == 1
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: CircleAvatar(
                      radius: 120,
                      child: profileUrl.isEmpty
                          ? Text(
                              name[0].toUpperCase(),
                              style: TextStyle(
                                  color: maincolor,
                                  fontSize: ScreenUtil().setSp(64),
                                  fontWeight: FontWeight.w500),
                            )
                          : CachedNetworkImage(
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          trandarkmain, BlendMode.colorBurn)),
                                ),
                              ),
                              imageUrl:
                                  '$miniohttp/coc/user_profile/$profileUrl',
                              placeholder: (context, url) =>
                                  const SpinKitFadingCube(
                                size: 5,
                                color: Colors.grey,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                    ),
                  )
                : CircleAvatar(
                    radius: 120,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: FileImage(File(widget.imagepath)),
                              fit: BoxFit.cover),
                          color: Colors.grey),
                    ),
                  ),
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Container(
                        // margin: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: MaterialButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: darkmain)),
                          // padding: const EdgeInsets.all(5),
                          color: backcolor,
                          onPressed: () async {
                            await _selectImage();
                            if (galaryimage != null) {
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: ImagepreviewScreen(
                                        imagepath: galaryimage!.path,
                                        contenttype: 2,
                                      )));
                              setState(() {
                                galaryimage = null;
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit,
                                color: darkmain,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text("Change", style: darkmainbuttonTextStyle),
                            ],
                          ),
                        ))),
                widget.contenttype == 2
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Container(
                            // margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height * 0.06,
                            child: MaterialButton(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: darkmain)),
                              // padding: const EdgeInsets.all(5),
                              color: backcolor,
                              onPressed: () async {
                                showLoadingDialog(
                                    context, "Uploading Your Profile");

                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                var res =
                                    await uploadprofileapi(widget.imagepath);
                                if (res['returncode'] == '200') {
                                  await prefs.setString(
                                      'profile_pic', res['data']);
                                  profileUrl = res['data'];
                                  showToast(res['message'], 'green');
                                  setState(() {});
                                } else {
                                  showToast('${res["message"]}', 'red');
                                }
                                Navigator.pop(context);
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: const TeacherDetailScreen()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.upload,
                                    color: darkmain,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text("Upload",
                                      style: darkmainbuttonTextStyle),
                                ],
                              ),
                            )))
                    : profileUrl.isEmpty
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                                // margin: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width * 0.45,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: MaterialButton(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: Colors.red)),
                                  // padding: const EdgeInsets.all(5),
                                  color: backcolor,
                                  onPressed: () async {
                                    showLoadingDialog(
                                        context, "Deleting Profile Picture");

                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var result = await deleteprofileapi();
                                    if (result['returncode'] == '200') {
                                      await prefs.setString('profile_pic', '');
                                      setState(() {
                                        profileUrl = '';
                                      });
                                      showToast('Profile picture is deleted',
                                          'green');
                                    } else {
                                      showToast('${result["message"]}', 'red');
                                    }
                                    Navigator.pop(context);
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child:
                                                const TeacherDetailScreen()));
                                  },
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Remove",
                                          style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
