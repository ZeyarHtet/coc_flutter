import 'package:class_on_cloud/screens/classposting.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class classlistmodel {
  String classId;
  String title;
  String subtitle;
  String? schoolId;
  String? privateId;
  String? description;
  String? picUrl;
  String? coverpic;

  classlistmodel({
    required this.classId,
    required this.title,
    required this.subtitle,
    required this.schoolId,
    required this.privateId,
    required this.description,
    required this.picUrl,
    required this.coverpic,
  });

  factory classlistmodel.fromJson(Map<String, dynamic> jsonData) {
    return classlistmodel(
      classId: jsonData['class_id'],
      title: jsonData['title'],
      subtitle: jsonData['subtitle'],
      schoolId: jsonData['school_id'],
      privateId: jsonData['private_id'],
      description: jsonData['description'],
      picUrl: jsonData['pic_url'],
      coverpic: jsonData['cover_pic'],
    );
  }

  static Map<String, dynamic> toMap(classlistmodel music) => {
        'class_id': music.classId,
        'title': music.title,
        'subtitle': music.subtitle,
        'school_id': music.schoolId,
        'private_id': music.privateId,
        'description': music.description,
        'pri_url': music.picUrl
      };

  static String encode(List<classlistmodel> classes) => json.encode(
        classes
            .map<Map<String, dynamic>>(
                (eachclass) => classlistmodel.toMap(eachclass))
            .toList(),
      );

  static List<classlistmodel> decode(String classes) => (json.decode(classes)
          as List<dynamic>)
      .map<classlistmodel>((eachclass) => classlistmodel.fromJson(eachclass))
      .toList();

  static String sigleencode(classlistmodel single) =>
      json.encode(classlistmodel.toMap(single));
  static classlistmodel singledecode(dynamic single) =>
      classlistmodel.fromJson(json.decode(single));
}

class schoollistmodel {
  String schoolId;
  String schoolName;
  String adminEmail;
  String description;
  String schoolProfilePic;
  String startDate;
  String endDate;
  String subscriptionPeriod;

  schoollistmodel({
    required this.schoolId,
    required this.schoolName,
    required this.adminEmail,
    required this.description,
    required this.schoolProfilePic,
    required this.startDate,
    required this.endDate,
    required this.subscriptionPeriod,
  });

  factory schoollistmodel.fromJson(Map<String, dynamic> jsonData) {
    return schoollistmodel(
      schoolId: jsonData['school_id'],
      schoolName: jsonData['school_name'],
      adminEmail: jsonData['admin_email'],
      description: jsonData['description'],
      schoolProfilePic: jsonData['school_profile_pic'],
      startDate: jsonData['start_date'],
      endDate: jsonData['end_date'],
      subscriptionPeriod: jsonData['subscription_period'],
    );
  }

  static Map<String, dynamic> toMap(schoollistmodel school) => {
        "school_id": school.schoolId,
        "school_name": school.schoolName,
        "admin_email": school.adminEmail,
        "description": school.description,
        "school_profile_pic": school.schoolProfilePic,
        "start_date": school.startDate,
        "subscription_period": school.subscriptionPeriod,
        "end_date": school.endDate,
        "is_active": null
      };

  static String encode(List<schoollistmodel> classes) => json.encode(
        classes
            .map<Map<String, dynamic>>(
                (eachclass) => schoollistmodel.toMap(eachclass))
            .toList(),
      );

  static List<schoollistmodel> decode(String classes) => (json.decode(classes)
          as List<dynamic>)
      .map<schoollistmodel>((eachclass) => schoollistmodel.fromJson(eachclass))
      .toList();

  static String sigleencode(schoollistmodel single) =>
      json.encode(schoollistmodel.toMap(single));
  static schoollistmodel singledecode(dynamic single) =>
      schoollistmodel.fromJson(json.decode(single));
}

class studentlistinClass {
  String username;
  String studentEmail;
  String studentId;

  studentlistinClass({
    required this.username,
    required this.studentEmail,
    required this.studentId,
  });

  factory studentlistinClass.fromJson(Map<String, dynamic> jsonData) {
    return studentlistinClass(
        username: jsonData['username'],
        studentEmail: jsonData['student_email'],
        studentId: jsonData['student_id']);
  }

  static Map<String, dynamic> toMap(studentlistinClass music) => {
        'username': music.username,
        'student_email': music.studentEmail,
        'student_id': music.studentId
      };

  static String encode(List<studentlistinClass> students) => json.encode(
        students
            .map<Map<String, dynamic>>(
                (student) => studentlistinClass.toMap(student))
            .toList(),
      );

  static List<studentlistinClass> decode(String students) =>
      (json.decode(students) as List<dynamic>)
          .map<studentlistinClass>((item) => studentlistinClass.fromJson(item))
          .toList();
}

class studentparentpair {
  String studentemail;
  List<dynamic> parentemaillist;

  studentparentpair(
      {required this.studentemail, required this.parentemaillist});

  factory studentparentpair.fromJson(Map<String, dynamic> jsonData) {
    return studentparentpair(
      studentemail: jsonData['student_email'],
      parentemaillist: jsonData['parent_email'],
    );
  }

  static Map<String, dynamic> toMap(studentparentpair music) => {
        'student_email': music.studentemail,
        'parent_email': music.parentemaillist,
      };

  static String encode(List<studentparentpair> students, String email) =>
      json.encode({
        "email": email,
        "parentArray": students
            .map<Map<String, dynamic>>((e) => studentparentpair.toMap(e))
            .toList()
      });
  // json.encode(
  //   students
  //       .map<Map<String, dynamic>>(
  //           (student) => studentparentpair.toMap(student))
  //       .toList(),
  // );

  static List<studentparentpair> decode(String students) =>
      (json.decode(students) as List<dynamic>)
          .map<studentparentpair>((item) => studentparentpair.fromJson(item))
          .toList();
}

class Studentparenterror {
  Studentparenterror({
    required this.notFound,
    required this.notParent,
  });

  List<String> notFound;
  List<String> notParent;

  factory Studentparenterror.fromRawJson(String str) =>
      Studentparenterror.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Studentparenterror.fromJson(Map<String, dynamic> json) =>
      Studentparenterror(
        notFound: List<String>.from(json["NotFound"].map((x) => x)),
        notParent: List<String>.from(json["NotParent"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "NotFound": List<dynamic>.from(notFound.map((x) => x)),
        "NotParent": List<dynamic>.from(notParent.map((x) => x)),
      };
}

class Eachpost {
  Eachpost({
    required this.id,
    required this.value,
    required this.type,
    required this.widget,
  });
  int id;
  dynamic value;
  String type;
  Widget widget;
}

class EachGetpost {
  EachGetpost({
    required this.postId,
    required this.title,
    required this.classId,
    required this.teacherId,
    required this.date,
    required this.type,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    required this.postDetails,
  });

  String postId;
  String title;
  String classId;
  String teacherId;
  String date;
  String type;
  dynamic dueDate;
  DateTime createdAt;
  DateTime updatedAt;
  List<PostDetail> postDetails;

  factory EachGetpost.fromRawJson(String str) =>
      EachGetpost.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EachGetpost.fromJson(Map<String, dynamic> json) => EachGetpost(
        postId: json["post_id"],
        title: json["title"],
        classId: json["class_id"],
        teacherId: json["teacher_id"],
        date: json["date"],
        type: json["type"],
        dueDate: json["due_date"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        postDetails: List<PostDetail>.from(
            json["post_details"].map((x) => PostDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "title": title,
        "class_id": classId,
        "teacher_id": teacherId,
        "date": date,
        "type": type,
        "due_date": dueDate,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "post_details": List<dynamic>.from(postDetails.map((x) => x.toJson())),
      };
}

class classpostlistmodel {
  String postId;
  String classId;
  String title;
  String type;
  String duedate;

  classpostlistmodel({
    required this.postId,
    required this.classId,
    required this.title,
    required this.type,
    required this.duedate,
  });

  factory classpostlistmodel.fromJson(Map<String, dynamic> jsonData) {
    return classpostlistmodel(
      postId: jsonData['post_id'],
      classId: jsonData['class_id'],
      title: jsonData['title'],
      type: jsonData['type'],
      duedate: jsonData['due_date'],
    );
  }

  static Map<String, dynamic> toMap(classpostlistmodel classpost) => {
        "post_id": classpost.postId,
        "class_id": classpost.classId,
        "title": classpost.title,
        "type": classpost.type,
        "due_date": classpost.duedate
      };

  static String encode(List<classpostlistmodel> classes) => json.encode(
        classes
            .map<Map<String, dynamic>>(
                (eachclass) => classpostlistmodel.toMap(eachclass))
            .toList(),
      );

  static List<classpostlistmodel> decode(String classes) =>
      (json.decode(classes) as List<dynamic>)
          .map<classpostlistmodel>(
              (eachclass) => classpostlistmodel.fromJson(eachclass))
          .toList();

  static String sigleencode(classpostlistmodel single) =>
      json.encode(classpostlistmodel.toMap(single));
  static classpostlistmodel singledecode(dynamic single) =>
      classpostlistmodel.fromJson(json.decode(single));
}

class PostDetail {
  PostDetail({
    required this.detailsId,
    required this.type,
    required this.content,
    required this.sortKey,
    required this.createdAt,
    required this.updatedAt,
    required this.postId,
  });

  String detailsId;
  String type;
  String content;
  int sortKey;
  DateTime createdAt;
  DateTime updatedAt;
  String postId;

  factory PostDetail.fromRawJson(String str) =>
      PostDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostDetail.fromJson(Map<String, dynamic> json) => PostDetail(
        detailsId: json["details_id"],
        type: json["type"],
        content: json["content"],
        sortKey: json["sort_key"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        postId: json["post_id"],
      );

  Map<String, dynamic> toJson() => {
        "details_id": detailsId,
        "type": type,
        "content": content,
        "sort_key": sortKey,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "post_id": postId,
      };
}
