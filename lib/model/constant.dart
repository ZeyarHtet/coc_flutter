import 'package:class_on_cloud/main.dart';
import 'package:class_on_cloud/model/api.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const domain = "http://192.168.1.3:5050";
const miniohttp = "http://192.168.1.3:9000";

var name = "";
var email = "";
var token = "";
var userid = '';
var usertype = 0;
var profileUrl = "";
var contact = '';
var phone = '';
var remark = '';

// classlistmodel defaultclassmodel = classlistmodel(
//     classId: "None",
//     title: "No title",
//     subtitle: "No subtitle",
//     schoolId: "None",
//     privateId: 'None',
//     description: 'None',
//     picUrl: 'None');
Color darkmain = const Color.fromARGB(255, 49, 99, 180);

Color paledarkmain = const Color.fromARGB(180, 0, 138, 237);

Color trandarkmain = const Color.fromARGB(73, 102, 191, 255);

Color maincolor = const Color(0xFFffffff);

Color seccolor = Colors.black;

Color? backcolor = Colors.grey[200];

// TextStyle appBarTitleTextStyle = TextStyle(
//   color: maincolor,
//   fontSize: ScreenUtil().setSp(16),
//   fontWeight: FontWeight.w500,
// );
TextStyle appbarTextStyle(Color? name) {
  return TextStyle(
      color: name,
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.w500);
}

TextStyle titleTextStyle = TextStyle(
  color: darkmain,
  fontSize: ScreenUtil().setSp(24),
  fontWeight: FontWeight.w500,
);
TextStyle labelTextStyle = TextStyle(
    color: Colors.black,
    fontSize: ScreenUtil().setSp(13),
    fontWeight: FontWeight.w400);

TextStyle buttonTextStyle = TextStyle(
    color: maincolor,
    fontSize: ScreenUtil().setSp(15),
    fontWeight: FontWeight.w500);

TextStyle darkmainbuttonTextStyle = TextStyle(
    color: darkmain,
    fontSize: ScreenUtil().setSp(15),
    fontWeight: FontWeight.w500);

TextStyle searchfieldTextStyle = TextStyle(
    color: Colors.white,
    fontSize: ScreenUtil().setSp(14),
    fontWeight: FontWeight.w400);

TextStyle inputTextStyle = TextStyle(
    color: Colors.black,
    fontSize: ScreenUtil().setSp(16),
    fontWeight: FontWeight.w500);

TextStyle profileTextstyle = TextStyle(
    color: Colors.white,
    fontSize: ScreenUtil().setSp(16),
    fontWeight: FontWeight.w500);

// TextStyle secondTextstyle = TextStyle(
//     color: Colors.grey[600],
//     fontSize: ScreenUtil().setSp(11),
//     fontWeight: FontWeight.w400);
TextStyle secondTextstyle(Color? name) {
  return TextStyle(
      color: name,
      fontSize: ScreenUtil().setSp(11),
      fontWeight: FontWeight.w500);
}

TextStyle firstTextstyle = TextStyle(
    color: seccolor,
    fontSize: ScreenUtil().setSp(14),
    fontWeight: FontWeight.w400);
