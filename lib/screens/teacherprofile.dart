import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/screens/home.dart';
import 'package:class_on_cloud/screens/imagepreview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/api.dart';

class TeacherDetailScreen extends StatefulWidget {
  const TeacherDetailScreen({super.key});

  @override
  State<TeacherDetailScreen> createState() => _TeacherDetailScreenState();
}

class _TeacherDetailScreenState extends State<TeacherDetailScreen> {
  TextEditingController disnamecontroller = TextEditingController(text: name);
  TextEditingController phonecontroller = TextEditingController(text: phone);
  TextEditingController remarkcontroller = TextEditingController(text: remark);
  TextEditingController birthdaycontroller =
      TextEditingController(text: 'April 13, 2001');

  bool submitted = false;

  // void _setImageFileListFromFile(XFile? value) {
  //   _imageList = value == null ? null : <XFile>[value];
  //   if (_imageList != null) {
  //     image_path = _imageList![0].path.toString();
  //   }
  //   setState(() {});
  //   print('image_path');
  // }

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
            onPressed: () => Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.leftToRight,
                    child: NavbarScreen(screenindex: 0))),
          ),
          title: Text("Profile", style: appbarTextStyle(darkmain))),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showbottomsheet(context);
                          print('imgurl ?>>> $profileUrl');
                          // Navigator.push(
                          //     context,
                          //     PageTransition(
                          //         type: PageTransitionType.rightToLeft,
                          //         child: const ImagepreviewScreen()));
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: CircleAvatar(
                                radius: 50,
                                child: profileUrl.isEmpty
                                    ? Text(
                                        name[0].toUpperCase(),
                                        style: TextStyle(
                                            color: maincolor,
                                            fontSize: ScreenUtil().setSp(24),
                                            fontWeight: FontWeight.w500),
                                      )
                                    : CachedNetworkImage(
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        imageUrl:
                                            '$miniohttp/coc/user_profile/$profileUrl',
                                        placeholder: (context, url) =>
                                            SpinKitFadingCube(
                                          size: 5,
                                          color: Colors.grey,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                              ),
                            ),
                            CircleAvatar(
                                backgroundColor: Colors.grey[400],
                                radius: 15,
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.black,
                                  size: 18,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' Name',
                        style: labelTextStyle,
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 10, top: 5),
                        child: TextFormField(
                          controller: disnamecontroller,
                          autofocus: false,
                          autocorrect: false,
                          autovalidateMode: submitted
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            // label: Text('Name',style: labelTextStyle,),
                            filled: true,
                            fillColor: Colors.white,
                            // hintText: 'Enter your email address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: labelTextStyle,
                          cursorColor: seccolor,
                        ),
                      ),
                      Text(
                        ' Brithday',
                        style: labelTextStyle,
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 10, top: 5),
                        child: TextFormField(
                          controller: birthdaycontroller,
                          autofocus: false,
                          autocorrect: false,
                          autovalidateMode: submitted
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            // label: Text('Name',style: labelTextStyle,),
                            filled: true,
                            fillColor: Colors.white,
                            // hintText: 'Enter your email address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: labelTextStyle,
                          cursorColor: seccolor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    ' Email',
                    style: labelTextStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            email,
                            style: labelTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    ' Phone',
                    style: labelTextStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10, top: 5),
                    child: TextFormField(
                      controller: phonecontroller,
                      autofocus: false,
                      autocorrect: false,
                      autovalidateMode: submitted
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        // label: Text('Name',style: labelTextStyle,),
                        filled: true,
                        fillColor: Colors.white,
                        // hintText: 'Enter your email address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: labelTextStyle,
                      cursorColor: seccolor,
                    ),
                  ),
                  Text(
                    ' Remark',
                    style: labelTextStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10, top: 5),
                    child: TextFormField(
                      controller: remarkcontroller,
                      maxLines: 4,
                      autofocus: false,
                      autocorrect: false,
                      autovalidateMode: submitted
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        // label: Text('Name',style: labelTextStyle,),
                        filled: true,
                        fillColor: Colors.white,
                        // hintText: 'Enter your email address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: labelTextStyle,
                      cursorColor: seccolor,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                                onPressed: () {},
                                child: Text("Cancel",
                                    style: darkmainbuttonTextStyle),
                              ))),
                      Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: SizedBox(
                              // margin: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: MaterialButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // padding: const EdgeInsets.all(5),
                                color: darkmain,
                                onPressed: () {},
                                child: Text("Update", style: buttonTextStyle),
                              ))),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

showbottomsheet(BuildContext context) {
  final ImagePicker _picker = ImagePicker();
  XFile? galaryimage;
  XFile? cameraimage;
  // List<XFile>? _imageList;
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

  Future<void> _cameraImage() async {
    cameraimage = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 100000000000,
        maxHeight: 100000000000,
        imageQuality: 100);
    // imagepath = pickedFile == null ? null : !pickedFile.path.toString();
    // pickedFile == null ? null : camerapath = pickedFile.path.toString();
    print('camerePath >> $cameraimage');
  }

  return showModalBottomSheet(
      backgroundColor: Color.fromARGB(0, 80, 80, 80),
      barrierColor: Color.fromARGB(92, 80, 80, 80),
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 18),
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ImagepreviewScreen(
                                imagepath: profileUrl,
                                contenttype: 1,
                              )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: backcolor,
                            child: Icon(
                              Icons.person_outline_rounded,
                              color: Colors.black,
                              size: 22,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'View profile picture',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(14),
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _cameraImage();

                      Navigator.pop(context);
                      cameraimage == null
                          ? null
                          // ignore: use_build_context_synchronously
                          : Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: ImagepreviewScreen(
                                    imagepath: cameraimage!.path,
                                    contenttype: 2,
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: backcolor,
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.black,
                              size: 22,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Take photo',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(14),
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _selectImage();

                      Navigator.pop(context);
                      galaryimage == null
                          ? null
                          // ignore: use_build_context_synchronously
                          : Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: ImagepreviewScreen(
                                    imagepath: galaryimage!.path,
                                    contenttype: 2,
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: backcolor,
                            child: const Icon(
                              Icons.photo_library_outlined,
                              color: Colors.black,
                              size: 22,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Choose from library',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(14),
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      logoutdialog(
                        context,
                        'Are you sure to delete this profile picture?',
                        () async {
                          if (profileUrl.isEmpty) {
                            showToast('There is no profile pic yet', 'red');
                            Navigator.pop(context);
                          } else {
                            showLoadingDialog(
                                context, "Deleting Profile Picture");

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var result = await deleteprofileapi();
                            if (result['returncode'] == '200') {
                              await prefs.setString('profile_pic', '');
                              profileUrl = '';
                              showToast('Profile picture is deleted', 'green');
                            } else {
                              showToast('${result["message"]}', 'red');
                            }
                            Navigator.pop(context);
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: const TeacherDetailScreen()));
                          }
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: backcolor,
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red,
                              size: 22,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Remove current profile',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: ScreenUtil().setSp(14),
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        );
      });
}
