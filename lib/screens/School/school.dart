import 'dart:convert';

import 'package:class_on_cloud/model/api.dart';
import 'package:class_on_cloud/screens/School/createschool.dart';
import 'package:class_on_cloud/screens/School/edit_school.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/component.dart';
import '../../model/constant.dart';
import '../../model/model.dart';
import '../drawer.dart';
import '../home.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  List<schoollistmodel> myschool = [];
  schoollistmodel? selectedschool;
  bool show = false;
  bool ready = false;
  late var result;

  getschool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    result = await getschoolapi();
    print('>>>>>>>>>>>>>>>>>>>>>>$result');
    if (result['returncode'] == '300') {
      setState(() {
        myschool = [];
      });
    } else if (result['returncode'] == '200') {
      List schoollist = result['data'];
      print('>>>>>>>>>>>>>>> school list$schoollist');
      if (schoollist.isNotEmpty) {
        for (var i = 0; i < schoollist.length; i++) {
          myschool.add(
            schoollistmodel(
              schoolId: schoollist[i]['school_id'] ?? "",
              schoolName: schoollist[i]['school_name'] ?? "",
              adminEmail: schoollist[i]['admin_email'] ?? "",
              description: schoollist[i]['description'] ?? "",
              schoolProfilePic: schoollist[i]['school_profile_pic'] ?? "",
              startDate: schoollist[i]['start_date'] ?? "",
              endDate: schoollist[i]["end_date"] ?? "",
              subscriptionPeriod: schoollist[i]['subscription_period'] ?? "",
            ),
          );
          // print(">>>>>>>> ${myclass[0].coverpic}");
        }

        String encodedschool = schoollistmodel.encode   (myschool);
        await prefs.setString('schoolList', encodedschool);
      }
    }

    var mineschool = prefs.getString('selectedSchool');
    mineschool == null
        ? selectedschool = null
        : selectedschool = schoollistmodel.singledecode(mineschool);
    setState(() {
      ready = true;
    });
  }

  deleteschool(String schoolid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    result = await deleteschoolapi(schoolid);

    print('>><><><>< before>>${myschool.length}');
    if (schoolid == selectedschool?.schoolId) {
      var removedData =
          myschool.removeWhere((element) => element.schoolId == schoolid);

      print('>><><><>< ${myschool.length}');
      if (myschool.isEmpty) {
        var addinnull = await prefs.remove('selectedSchool');
        print('><><>>>>>Nulling $addinnull');
      } else {
        String selectedencode = schoollistmodel.sigleencode(myschool[0]);
        await prefs.setString("selectedSchool", selectedencode);
        // await prefs.setStringList('classdata', [
        //   myclass[0].classId,
        //   myclass[0].title,
        //   myclass[0].subtitle,
        //   myclass[0].schoolId ?? 'N',
        //   myclass[0].privateId ?? 'N',
        //   myclass[0].description ?? "N",
        //   myclass[0].picUrl ?? 'N'
        // ]);
      }
    }
    if (result['returncode'] == '200') {
      Navigator.pop(context);
      showToast('successfully deleted', 'darkmain');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SchoolScreen()),
          (route) => false);
    } else {
      Navigator.pop(context);
      showToast('${result['returncode']}', 'red');
    }
    setState(() {});
  }

  @override
  void initState() {
    getschool();
    super.initState();
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
        title: Text("School", style: appbarTextStyle(maincolor)),
      ),
      drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: DrawerScreen(
            pagename: 'School',
          )),
      body: ready
          ? myschool.isEmpty
              ? Center(
                  child: Text(
                    "You don't have any class yet!",
                    style: inputTextStyle,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          itemCount: myschool.length,
                          itemBuilder: (context, i) {
                            return Slidable(
                              endActionPane: ActionPane(
                                extentRatio: 0.26,
                                motion: const DrawerMotion(),
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          print(">>>>> my data");
                                          var mydata = jsonEncode({
                                            "school_id": myschool[i].schoolId,
                                            "school_name":
                                                myschool[i].schoolName,
                                            "admin_email":
                                                myschool[i].adminEmail,
                                            "description":
                                                myschool[i].description,
                                            "school_profile_pic":
                                                myschool[i].schoolProfilePic,
                                            "start_date": myschool[i].startDate,
                                            "subscription_period":
                                                myschool[i].subscriptionPeriod,
                                            "end_date": myschool[i].endDate,
                                          });
                                          print(">>>>> my data");
                                          print(mydata);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditSchool(
                                                editData: mydata,
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                      // borderRadius:
                                      //     BorderRadius.circular(16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.09,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2,
                                                      vertical: 0),
                                              alignment: Alignment.center,
                                              // width: 20 *
                                              //     4, // space for actionPan
                                              decoration: BoxDecoration(
                                                  color: paledarkmain,
                                                  shape: BoxShape.circle),
                                              child: const Icon(Icons.edit,
                                                  size: 20,
                                                  color: Colors.white)),
                                          Divider(
                                            color: Colors.grey[300],
                                            thickness: 1,
                                            height: 1.1,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                left: 10,
                                                top: 15,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  myschool[i].schoolId ==
                                                          selectedschool
                                                              ?.schoolId
                                                      ? Text(
                                                          "You have been viewing this class! Do you want to delete?",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          15),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                      : Text(
                                                          "Are You sure to delete this class?",
                                                          style: TextStyle(
                                                              color: seccolor,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          15),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                color: seccolor,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            14),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )),
                                                      TextButton(
                                                        // 1/9
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          showLoadingDialog(
                                                              context,
                                                              "Loading. . .");

                                                          // showLoadingDialog(
                                                          //     context);
                                                          await deleteschool(
                                                              myschool[i]
                                                                  .schoolId);
                                                          // ignore: use_build_context_synchronously
                                                        },
                                                        child: Text(
                                                          'Confirm',
                                                          style: TextStyle(
                                                              color: darkmain,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          14),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      // borderRadius:
                                      //     BorderRadius.circular(16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.09,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2,
                                                      vertical: 0),
                                              alignment: Alignment.center,
                                              // width: 20 *
                                              //     4, // space for actionPan
                                              decoration: const BoxDecoration(
                                                  color: Colors.redAccent,
                                                  shape: BoxShape.circle),
                                              child: const Icon(Icons.delete,
                                                  size: 20,
                                                  color: Colors.white)),
                                          Divider(
                                            color: Colors.grey[300],
                                            thickness: 1,
                                            height: 1.1,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              child: SchoolModel(
                                eachschool: myschool[i],
                              ),
                            );
                          })),
                )
          : Center(
              child: SpinKitFoldingCube(
                color: paledarkmain,
                size: 50,
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: darkmain,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateSchool()));
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class SchoolModel extends StatefulWidget {
  schoollistmodel eachschool;
  // String classname;
  SchoolModel({super.key, required this.eachschool});

  @override
  State<SchoolModel> createState() => _SchoolModelState();
}

class _SchoolModelState extends State<SchoolModel> {
  List<studentlistinClass> studentlist = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // print(">>><><>>>>>> ${widget.eachclass.classId}");
        final prefs = await SharedPreferences.getInstance();
        showLoadingDialog(context, 'Preparing Your class');
        var apiresult = await getsingleclassapi(widget.eachschool.schoolId);
        List students = apiresult['student'];
        for (var i = 0; i < students.length; i++) {
          studentlist.add(studentlistinClass(
              username: students[i]['username'],
              studentEmail: students[i]['student_email'],
              studentId: students[i]['student_id']));
        }
        String encodedData = studentlistinClass.encode(studentlist);
        await prefs.setString('selectedstudentList', encodedData);
        print(">>><><number of student>>>>>> ${studentlist.length}");
        String selectedencode = schoollistmodel.sigleencode(widget.eachschool);
        await prefs.setString("selectedClass", selectedencode);
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NavbarScreen(
                    screenindex: 0,
                  )),
        );
      },
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: backcolor),
            padding: const EdgeInsets.all(8),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                    backgroundColor: paledarkmain,
                    radius: 25,
                    child: Text(
                      widget.eachschool.schoolName[0].toUpperCase(),
                      style: buttonTextStyle,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${widget.eachschool.schoolName.characters.take(36)}',
                        style: firstTextstyle),
                    Text(
                      widget.eachschool.startDate,
                      style: secondTextstyle(Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
            height: 1.1,
          )
        ],
      ),
    );
  }
}
