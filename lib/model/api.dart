import 'dart:convert';
import 'dart:io';

import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http_parser/http_parser.dart';
// import 'package:http/http.dart' as http;

var dio = Dio();

refreshToken() async {
  final prefs = await SharedPreferences.getInstance();
  var url = '$domain/api/auth/refreshtoken';
  var params = {
    "email": email,
    "token": token,
  };
  Response res = await dio.post(
    url,
    options: Options(headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    }),
    data: jsonEncode(params),
  );
  // var res = await http.post(
  //   Uri.parse(url),
  //   headers: {"Content-Type": "application/x-www-form-urlencoded"},
  //   body: {"email": email, "token": token},
  // );
  var result = res.data;
  print('token<><>< $token');
  if (result["returncode"] == "200") {
    print('<><><>mes ${result['message']}');
    await prefs.setString('token', result['token']);
    token = prefs.getString('token')!;
  } else {
    showToast(res.statusCode.toString(), 'green');
  }
  return result;
}

createclassapi(
  String title,
  String subtitle,
  String description,
  // String school,
) async {
  var url = "$domain/api/teacher/createclass";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  var params = {
    "email": email,
    "title": title,
    "description": description,
    "subtitle": subtitle,
    // "school_id": school,
    // "cover_pic": coverpic,
    "is_active": true
  };
  try {
    Response res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: jsonEncode(params),
    );
    var result = res.data;
    // print('>><?><>><< ${result['returncode']}');
    if (result['returncode'] == '200') {
      showToast('Class is created', "darkmain");
    }
    // else if (res.statusCode == 401) {
    //   var refreshresult = await refreshToken();
    //   if (refreshresult['returncode'] == '200') {
    //     await Future.delayed(const Duration(seconds: 2));
    //     createclassapi(classname, gradename);
    //   }
    //   print('><><><><tokres ${refreshresult['returncode']} ');
    // } else {
    //   showToast(result['returncode'], 'darkmain');
    // }
    return result['returncode'].toString();
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        createclassapi(
          title,
          description,
          subtitle,
        );
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}

editclassapi(
  String id,
  String title,
  String subtitle,
  String desc,
  String school,
  String coverpic,
) async {
  var url = "$domain/api/teacher/editclass";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  var params = {
    "email": email,
    "classid": id,
    "title": title,
    "subtitle": subtitle,
    "description": desc,
    "school_id": school,
    "cover_pic": coverpic,
    "is_active": true
  };
  print(params);
  print('>>>>>>>>>>>');
  try {
    Response res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: jsonEncode(params),
    );
    var result = res.data;
    if (result['returncode'] == '200') {
      showToast('Class is updated', "darkmain");
    }

    return result['returncode'].toString();
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        editclassapi(
          id,
          title,
          subtitle,
          desc,
          school,
          coverpic,
        );
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}

getclassapi() async {
  var url = "$domain/api/teacher/getclass";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    var params = {"email": email};
    // var res = await http.post(
    //   Uri.parse(url),
    //   headers: {
    //      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
    //     'Authorization': 'Bearer $token',
    //   },
    //   body: {"email": email},
    // );
    var res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: jsonEncode(params),
    );
    print('>><?><>><< ${res.data}');

    var result = res.data;
    return result;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        getclassapi();
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
    print("geterror >>>> $e");
  }
}

uploadcoverpic(String classid, String imagepath) async {
  var url = "$domain/api/teacher/uploadcoverpic";
  try {
    var imagefile = await MultipartFile.fromFile(
      imagepath,
      filename: imagepath,
      contentType: MediaType('image', imagepath.split(".").last),
    );
    FormData formdata = FormData.fromMap(
        {"classid": classid, "email": email, "file": imagefile});
    // print(">>>>>>>>>>> form data ${formdata["classid"]}");
    Response res = await dio.post(
      url,
      options: Options(headers: {
        "Content-Type":
            "multipart/form-data; boundary=<calculated when request is sent>",
        'Authorization': 'Bearer $token',
      }),
      data: formdata,
    );

    print("4444>>>>>> DAta is  ");
    print(res.data);

    return res.data;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      print('>>>>> refresh token $refreshresult');
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        uploadcoverpic(classid, imagepath);
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    print("uploaderror $e");
  }
}

deleteclassapi(String classid) async {
  var url = "$domain/api/teacher/delete_class";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    var params = {"email": email, "classid": classid};
    Response res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: jsonEncode(params),
    );
    var result = res.data;
    // print('>><?><>><< ${result['returncode']}');
    // if (result['returncode'] == '200') {
    //   // showToast('Arrived', "darkmain");
    //   return result;
    // } else if (res.statusCode == 401) {
    //   var refreshresult = await refreshToken();
    //   if (refreshresult['returncode'] == '200') {
    //     await Future.delayed(const Duration(seconds: 2));
    //     deleteclassapi(classid);
    //   }
    //   print('><><><><tokres ${refreshresult['returncode']} ');
    // } else {
    //   showToast(result['returncode'], 'darkmain');
    // }

    return result;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        deleteclassapi(classid);
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}

addstudentapi(studentemails, classid) async {
  var url = "$domain/api/teacher/addstudent";
  var testbody = jsonEncode(
      {"email": email, "classid": classid, "studentArray": studentemails});
  // print('>>testbody $testbody');
  // var studentlist = {"student2@gmail.com", "student3@gmail.com"}.toString();
  try {
    Response res = await dio.post(url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        }),
        data: testbody);
    var result = res.data;
    print('>><addstudent><>><< $result');
    // if (result['returncode'] == '305') {
    //   showToast('Students are added', "darkmain");
    // } else if (res.statuscode == 401) {
    //   var result = await refreshToken();
    //   if (result['returncode'] == '200') {
    //     await Future.delayed(const Duration(seconds: 2));
    //     addstudentapi(studentemails, classid);
    // }
    //   print('><><><><tokres ${result['returncode']} ');
    // } else if (res.statuscode == 401) {
    //   showToast(result['message'], "red");
    // } else {
    //   showToast(result['returncode'], 'darkmain');
    // }

    return result;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        addstudentapi(studentemails, classid);
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
    print('Rrreor $e');
  }
}

getsingleclassapi(String classid) async {
  var url = "$domain/api/teacher/get_single_class";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    var params = {"email": email, "classid": classid};
    // var res = await http.post(
    //   Uri.parse(url),
    //   headers: {
    //      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
    //     'Authorization': 'Bearer $token',
    //   },
    //   body: {"email": email, "classid": classid},
    // );
    var res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: jsonEncode(params),
    );
    var result = res.data;
    // print('>><?><>><< ${result['returncode']}');

    return result;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        getsingleclassapi(classid);
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}

addparentArrayapi(parentarray) async {
  var url = "$domain/api/teacher/addparentArray";
  // var parentlist = studentparentpair.decode(parentarray);
  var mainbody = studentparentpair.encode(parentarray, email);
  print('>>> mainbody >> $mainbody');
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    var res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: mainbody,
    );
    var result = res.data;
    print('>><?><>><< $result');
    return result;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        addparentArrayapi(parentarray);
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    // showToast(e.toString(), 'red');
    print('myerror>>${e}');
  }
}

getparentapi(String email, String classid) async {
  var url = "$domain/api/teacher/getparent";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  var mainbody = jsonEncode({"email": email, "classid": classid});
  print('getparent>>Body<< $mainbody');
  try {
    var res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: mainbody,
    );
    var result = res.data;
    print('>><?><>><< ${result}');

    return result;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        getparentapi(email, classid);
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    // showToast(e.toString(), 'red');
    print('myerror>>$e');
  }
}

getstudentapi(String classid) async {
  var url = "$domain/api/teacher/getstudent";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  var mainbody = jsonEncode(
    {"email": email, "classid": classid},
  );
  try {
    var res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: mainbody,
    );
    var result = res.data;
    // print('>><?><>><< ${result['returncode']}');
    return result;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        getstudentapi(classid);
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}

deletestudentapi(String classid, String studentid) async {
  var url = "$domain/api/teacher/delete_student";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  var mainbody =
      jsonEncode({"email": email, "classid": classid, "student_id": studentid});
  try {
    var res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: mainbody,
    );
    var result = res.data;

    return result;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        deletestudentapi(classid, studentid);
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}

deleteparentapi(String studentId, String parentemail) async {
  var url = "$domain/api/teacher/delete_parent";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  var mainbody = jsonEncode(
      {"email": email, "student_id": studentId, "parent_email": parentemail});
  try {
    var res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: mainbody,
    );
    var result = res.data;
    // print('>><?><>><< ${result['returncode']}');

    return result;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        deleteparentapi(studentId, parentemail);
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}

uploadprofileapi(String imagepath) async {
  var url = "$domain/api/auth/uploadprofile";
  try {
    var imagefile = await MultipartFile.fromFile(
      imagepath,
      filename: "profile.${imagepath.split(".").last}",
      contentType: MediaType('image', '"profile.${imagepath.split(".").last}"'),
    );
    FormData formdata = FormData.fromMap({"email": email, "file": imagefile});
    Response res = await dio.post(
      url,
      options: Options(headers: {
        "Content-Type":
            "multipart/form-data; boundary=<calculated when request is sent>",
        'Authorization': 'Bearer $token',
      }),
      data: formdata,
    );

    print("4444>>>>>> DAta is  ");
    print(res.data);

    return res.data;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        uploadprofileapi(imagepath);
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    print("uploaderror $e");
  }
}

deleteprofileapi() async {
  var url = "$domain/api/auth/deleteprofile";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  var mainbody = jsonEncode({"email": email});
  try {
    Response res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: mainbody,
    );
    var result = res.data;
    // print('>><?><>><< ${result['returncode']}');

    return result;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        deleteprofileapi();
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}

// createPostApi(Map<String, dynamic> allvaluelist) async {
//   var url = "$domain/api/post/createPost";
//   // SharedPreferences prefs = await SharedPreferences.getInstance();
//   var mainbody = jsonEncode(allvaluelist);
//   try {
//     Response res = await dio.post(
//       url,
//       options: Options(headers: {
//         HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
//         'Authorization': 'Bearer $token',
//       }),
//       data: mainbody,
//     );
//     var result = res.data;
//     // print('>><?><>><< ${result['returncode']}');

//     return result;
//   } on DioError catch (err) {
//     print('dioerror >>>  ${err.response!.data["returncode"]}');
//     var errres = err.response!.data;
//     if (errres['returncode'] == '301') {
//       var refreshresult = await refreshToken();
//       if (refreshresult['returncode'] == '200') {
//         await Future.delayed(const Duration(seconds: 2));
//         deleteprofileapi();
//       }
//       print('><><><><tokres ${refreshresult['returncode']} ');
//     }
//   } catch (e) {
//     showToast(e.toString(), 'red');
//   }
// }
createPostApi(Map<String, dynamic> allvaluelist, List<XFile> files) async {
  var url = "$domain/api/post/createPost";
  List storefile = [];
  print("<><><><><><><>><><<><>><>1");
  if (files.isNotEmpty) {
    for (var i = 0; i < files.length; i++) {
      print(">>>>>>>>>>>>>>>>>>>>> file ${files[i].path}");
      var imagefile = await MultipartFile.fromFile(
        files[i].path,
        filename: files[i].name,
        contentType: MediaType('image', files[i].path.split(".").last),
      );
      storefile.add(imagefile);
    }
  }
  print("<><><><><><><>><><<><>><>2");
  FormData mainbody = FormData.fromMap({
    "email": allvaluelist["email"],
    "class_id": allvaluelist["class_id"],
    "title": allvaluelist["title"],
    "type": allvaluelist["type"],
    "due_date": allvaluelist["due_date"],
    "post_details": allvaluelist["post_details"],
    "files": storefile,
  });
  print("<><><><><><><>><><<><>><>3");
  try {
    Response res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: mainbody,
    );
    var result = res.data;
    print('>><?><>><< ${result['returncode']}');
    return result;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        createPostApi(allvaluelist, files);
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}

getPostApi(String classid) async {
  var url = "$domain/api/post/getPostsByClassId";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  var mainbody = jsonEncode({'email': email, "class_id": classid});
  try {
    Response res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: mainbody,
    );
    var result = res.data;
    // print('>><?><>><< ${result['returncode']}');
    if (result['returnCode'] == '200') {
      return result;
    }
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      await Future.delayed(const Duration(seconds: 2));
      print('><><><><tokres ${refreshresult['returncode']} ');

      getPostApi(classid);
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}

uploadimageapi(XFile imagepath) async {
  var url = "$domain/api/post/uploadImage";
  try {
    var imagefile = await MultipartFile.fromFile(
      imagepath.path,
      filename: imagepath.name,
      contentType: MediaType('image', imagepath.path.split(".").last),
    );
    FormData formdata = FormData.fromMap({"email": email, "file": imagefile});
    Response res = await dio.post(
      url,
      options: Options(headers: {
        "Content-Type":
            "multipart/form-data; boundary=<calculated when request is sent>",
        'Authorization': 'Bearer $token',
      }),
      data: formdata,
    );

    print("4444>>>>>> DAta is  ");
    print(res.data);

    return res.data;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        uploadimageapi(imagepath);
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    print("uploaderror $e");
  }
}

getschoolapi() async {
  var url = "$domain/api/school/getallschool";
  try {
    var params = {
      "email": email,
    };
    var res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: jsonEncode(params),
    );
    print('>><?><>><< ${res.data}');

    var result = res.data;
    return result;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        getschoolapi();
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
    print("geterror >>>> $e");
  }
}

createschoolapi(
  String schoolemail,
  String schoolname,
  String startdate,
  String enddate,
  String perioddate,
) async {
  var url = "$domain/api/school/createschool";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  var params = {
    "email": email,
    "school_email": schoolemail,
    "school_name": schoolname,
    "start_date": startdate,
    "end_date": enddate,
    "subscription_period": perioddate,
  };
  debugPrint(">>>>>> create school param $params");
  try {
    Response res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: jsonEncode(params),
    );
    var result = res.data;
    // print('>><?><>><< ${result['returncode']}');
    if (result['returncode'] == '200') {
      showToast('Class is created', "darkmain");
    }

    return result['returncode'].toString();
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        createschoolapi(
            schoolemail, schoolname, startdate, enddate, perioddate);
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}

getoneschoolapi(String school_id) async {
  var url = "$domain/api/school/getOneSchool";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    var params = {"email": email, "school_id": school_id};
    // var res = await http.post(
    //   Uri.parse(url),
    //   headers: {
    //      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
    //     'Authorization': 'Bearer $token',
    //   },
    //   body: {"email": email, "classid": classid},
    // );
    var res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: jsonEncode(params),
    );
    var result = res.data;
    // print('>><?><>><< ${result['returncode']}');

    return result;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        getoneschoolapi(school_id);
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}

deleteschoolapi(String schoolid) async {
  var url = "$domain/api/school/deleteOneSchool";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    var params = {"email": email, "school_id": schoolid};
    Response res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: jsonEncode(params),
    );
    var result = res.data;
    // print('>><?><>><< ${result['returncode']}');
    // if (result['returncode'] == '200') {
    //   // showToast('Arrived', "darkmain");
    //   return result;
    // } else if (res.statusCode == 401) {
    //   var refreshresult = await refreshToken();
    //   if (refreshresult['returncode'] == '200') {
    //     await Future.delayed(const Duration(seconds: 2));
    //     deleteclassapi(classid);
    //   }
    //   print('><><><><tokres ${refreshresult['returncode']} ');
    // } else {
    //   showToast(result['returncode'], 'darkmain');
    // }

    return result;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        deleteschoolapi(schoolid);
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}

editschoolapi(
  String id,
  String schoolemail,
  String schoolname,
  String startdate,
  String enddate,
  String perioddate,
) async {
  var url = "$domain/api/school/updateschool";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  var params = {
    "email": email,
    "school_id": id,
    "school_email": schoolemail,
    "school_name": schoolname,
    "start_date": startdate,
    "end_date": enddate,
    "subscription_period": perioddate,
    "description": "",
    "school_profile_pic": "",
    "is_active": true
  };
  print('>>>>>>>>>>>edit school params $params');
  try {
    Response res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: jsonEncode(params),
    );
    var result = res.data;
    if (result['returncode'] == '200') {
      showToast('School is updated', "darkmain");
    }

    return result['returncode'].toString();
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        editschoolapi(
          id,
          schoolemail,
          schoolname,
          startdate,
          enddate,
          perioddate,
        );
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}

createpostapi(
  String classid,
  String title,
  List postdetails,
  String dudedate,
  int type,
) async {
  var url = "$domain/api/post/createPost";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  var params = {
    "email": email,
    "class_id": classid,
    "title": title,
    "type": type,
    "post_details": postdetails,
    "due_date": dudedate,
  };
  print(">>>>>>>>>>>>> post body $params");
  try {
    Response res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: jsonEncode(params),
    );
    var result = res.data;
    // print('>><?><>><< ${result['returncode']}');
    if (result['returnCode'] == '200') {
      print(">>>>>> res returncode ${result['returnCode']}");
      return result['returnCode'].toString();
    }
    // else if (res.statusCode == 401) {
    //   var refreshresult = await refreshToken();
    //   if (refreshresult['returncode'] == '200') {
    //     await Future.delayed(const Duration(seconds: 2));
    //     createclassapi(classname, gradename);
    //   }
    //   print('><><><><tokres ${refreshresult['returncode']} ');
    // } else {
    //   showToast(result['returncode'], 'darkmain');
    // }
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returnCode"]}');
    var errres = err.response!.data;
    if (errres['returnCode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returnCode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        createpostapi(
          classid,
          title,
          postdetails,
          dudedate,
          type,
        );
      }
      print('><><><><tokres ${refreshresult['returnCode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}

getclasspostapi() async {
  var url = "$domain/api/post/getPosts";
  try {
    var params = {
      "email": email,
    };
    var res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: jsonEncode(params),
    );
    print('>><?><>><< ${res.data}');

    var result = res.data;
    return result;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        getschoolapi();
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
    print("geterror >>>> $e");
  }
}

deleteclasspostapi(String postid) async {
  var url = "$domain/api/post/deletePost";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    var params = {"email": email, "post_id": postid};
    Response res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: jsonEncode(params),
    );
    var result = res.data;
    // print('>><?><>><< ${result['returncode']}');
    // if (result['returncode'] == '200') {
    //   // showToast('Arrived', "darkmain");
    //   return result;
    // } else if (res.statusCode == 401) {
    //   var refreshresult = await refreshToken();
    //   if (refreshresult['returncode'] == '200') {
    //     await Future.delayed(const Duration(seconds: 2));
    //     deleteclassapi(classid);
    //   }
    //   print('><><><><tokres ${refreshresult['returncode']} ');
    // } else {
    //   showToast(result['returncode'], 'darkmain');
    // }

    return result;
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returncode"]}');
    var errres = err.response!.data;
    if (errres['returncode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returncode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        deleteschoolapi(postid);
      }
      print('><><><><tokres ${refreshresult['returncode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}

editclasspostapi(
  String postid,
  String title,
  String duedate,
) async {
  var url = "$domain/api/post/updatePost";
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  var params = {
    "email": email,
    "post_id": postid,
    "title": title,
    "type": 1,
    "post_details": [],
    "due_date": duedate,
  };
  print('>>>>>>>>>>>edit post params $params');
  try {
    Response res = await dio.post(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      data: jsonEncode(params),
    );
    var result = res.data;
    if (result['returnCode'] == '200') {
      showToast('Post is updated', "darkmain");
    }

    return result['returnCode'].toString();
  } on DioError catch (err) {
    print('dioerror >>>  ${err.response!.data["returnCode"]}');
    var errres = err.response!.data;
    if (errres['returnCode'] == '301') {
      var refreshresult = await refreshToken();
      if (refreshresult['returnCode'] == '200') {
        await Future.delayed(const Duration(seconds: 2));
        editclasspostapi(
          postid,
          title,
          duedate,
        );
      }
      print('><><><><tokres ${refreshresult['returnCode']} ');
    }
  } catch (e) {
    showToast(e.toString(), 'red');
  }
}




// userprofileupdate(
//       // username,
//       fullname,
//       userid,
//       email,
//       othername,
//       address,
//       dob,
//       gender,
//       bloodtype,
//       allergicdrug,
//       cmt,
//       // identifiednumber,
//       nrccode,
//       nrcregion,
//       nrctype,
//       nrcnumber,
//       profilephoto,
//       identifiedphotofront,
//       identifiedphotoback) async {
//     var response;
//     var apiUrl = “user/profile/update”;
//     // var param = jsonEncode({
//     //   “username”: username,
//     //   “fullname”: fullname,
//     //   “userid”: userid,
//     //   “password”: password,
//     //   “email”: email
//     // });
//     // print(“Param>> $param”);
// //     FormData formData = new FormData.fromMap({
// //    “name”: “wendux”,
// //    “file1": new UploadFileInfo(new File(“./upload.jpg”), “upload1.jpg”)
// // });
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     try {
//       print(“1111>>>“);
//       var dioRequest = Dio();
//       dioRequest.options.baseUrl = baseUrl;
//       String tok = prefs.getString(“token”) ?? “”;
//       var tokenheader = tok;
//       //[2] ADDING TOKEN
//       dioRequest.options.headers = {
//         ‘Authorization’: tokenheader.toString(),
//         ‘Content-Type’:
//             ‘multipart/form-data; boundary=<calculated when request is sent>‘,
//       };
//       print(“2222>>>“);
//       print(“TOK>> $nrccode, $nrcregion, $nrctype, $nrcnumber”);
//       // final bytes = await profilephoto.readAsBytes();
//       // final MultipartFile profile = MultipartFile.fromBytes(
//       //   bytes,
//       //   filename: profilephoto.path,
//       // );
//       // final bytes1 = await identifiedphoto.readAsBytes();
//       // final MultipartFile identifiedfront = MultipartFile.fromBytes(
//       //   bytes1,
//       //   filename: identifiedphoto.path,
//       // );
//       // final bytes2 = await identifiedphoto.readAsBytes();
//       // final MultipartFile identifiedback = MultipartFile.fromBytes(
//       //   bytes1,
//       //   filename: identifiedphoto.path + “back”,
//       // );
//       //[3] ADDING EXTRA INFO
//       print(“URL>>> $url”);
//       FormData formData = new FormData.fromMap({
//         “profileimage”:
//             // profile,
//             // “identifiedphoto_front”: identifiedfront,
//             // “identifiedphoto_back”: identifiedback,
//             (profilephoto == “none” || profilephoto == null)
//                 ? “”
//                 : (kIsWeb)
//                     ? await MultipartFile.fromBytes(
//                         profilephoto!.first.bytes!,
//                         filename: profilephoto!.first.name,
//                       )
//                     : await MultipartFile.fromFile(
//                         profilephoto.path,
//                         filename: basename(profilephoto.path),
//                       ),
//         “identifiedphoto_front”:
//             (identifiedphotofront == “none” || identifiedphotofront == null)
//                 ? “”
//                 : (kIsWeb)
//                     ? await MultipartFile.fromBytes(
//                         identifiedphotofront!.first.bytes!,
//                         filename: identifiedphotofront!.first.name,
//                       )
//                     : await MultipartFile.fromFile(
//                         identifiedphotofront.path,
//                         filename: basename(identifiedphotofront.path),
//                       ),
//         “identifiedphoto_back”:
//             (identifiedphotoback == “none” || identifiedphotoback == null)
//                 ? “”
//                 : (kIsWeb)
//                     ? await MultipartFile.fromBytes(
//                         identifiedphotoback!.first.bytes!,
//                         filename: identifiedphotoback!.first.name,
//                       )
//                     : await MultipartFile.fromFile(
//                         identifiedphotoback.path,
//                         filename: basename(identifiedphotoback.path),
//                       ),
//         ‘userid’: userid,
//         // ‘username’: username,
//         ‘fullname’: fullname,
//         ‘othername’: othername,
//         ‘email’: email,
//         ‘address’: address,
//         ‘dob’: dob,
//         ‘gender’: gender,
//         ‘bloodtype’: bloodtype,
//         ‘allergicdrug’: allergicdrug,
//         ‘cmt’: cmt,
//         ‘nrccode’: nrccode,
//         ‘nrcregion’: nrcregion,
//         ‘nrctype’: nrctype,
//         ‘nrcnumber’: nrcnumber
//         // ‘identifiednumber’: identifiednumber
//         // “data”: jsonEncode({
//         //   ‘userid’: userid,
//         //   ‘username’: username,
//         //   ‘fullname’: fullname,
//         //   ‘othername’: othername,
//         //   ‘email’: email,
//         //   ‘address’: address,
//         //   ‘dob’: dob,
//         //   ‘gender’: gender,
//         //   ‘bloodtype’: bloodtype,
//         //   ‘allergicdrug’: allergicdrug,
//         //   ‘cmt’: cmt,
//         //   ‘identifiednumber’: identifiednumber
//         // })
//       });
//       print(“3333>>>“);
//       // //[4] ADD PROFILE IMAGE TO UPLOAD
//       // var file = await MultipartFile.fromFile(profilephoto.path,
//       //     filename: basename(profilephoto.path),
//       //     contentType: MediaType(“image”, basename(profilephoto.path)));
//       // formData.files.add(MapEntry(‘profileimage’, file));
//       // //[4] ADD PROFILE IMAGE TO UPLOAD
//       // var file1 = await MultipartFile.fromFile(identifiedphoto.path,
//       //     filename: basename(identifiedphoto.path),
//       //     contentType: MediaType(“image”, basename(identifiedphoto.path)));
//       // formData.files.add(MapEntry(‘identifiedphoto_front’, file1));
//       // //[4] ADD PROFILE IMAGE TO UPLOAD
//       // var file2 = await MultipartFile.fromFile(identifiedphoto.path,
//       //     filename: basename(identifiedphoto.path),
//       //     contentType: MediaType(“image”, basename(identifiedphoto.path)));
//       // formData.files.add(MapEntry(‘identifiedphoto_back’, file2));
//       // print(“4444>>>“);
//       //[5] SEND TO SERVER
//       var dioReq = await dioRequest.post(
//         apiUrl,
//         data: formData,
//       );
//       print(“4444>> “);
//       var jsondio = json.decode(dioReq.toString());
//       print(“Return Status>> $jsondio”);
//       response = ResponseModel.fromJson(jsondio);
//       // if (res.statusCode == 200) {
//       // response = AppUserModel.fromJson(res);
//       // var jsonMap = json.decode(jsonString);
//       // response = AppUserModel.fromJson(jsonMap);
//       // print(“SUCCESS>> ${response.status}“);
//       // }
//       // print(“Status>> ${res.statusCode}“);
//       // if (res.statusCode == 200) {
//       //   var jsonString = res.body;
//       //   var jsonMap = json.decode(jsonString);
//       //   response = AppUserModel.fromJson(jsonMap);
//       //   // print(“SUCCESS>> ${response}“);
//       // }
//     } catch (e) {
//       print(“USER PROFILE UPDATE ERROR : $e”);
//       return response;
//     }
//     return await response;
//   }