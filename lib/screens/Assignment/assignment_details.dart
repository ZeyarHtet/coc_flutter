import 'dart:convert';

import 'package:class_on_cloud/model/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/constant.dart';
import '../../model/model.dart';
import '../drawer.dart';

class AssignmentDetailsScreen extends StatefulWidget {
  const AssignmentDetailsScreen({super.key});

  @override
  State<AssignmentDetailsScreen> createState() =>
      _AssignmentDetailsScreenState();
}

class _AssignmentDetailsScreenState extends State<AssignmentDetailsScreen> {
  bool searchBoolean = false;

  List<classassignmentlistmodel> myclassassignment = [];
  classassignmentlistmodel? selectedclassassignment;
  bool ready = false;

  late var result;
  getOneClassAssignment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String postid = prefs.getString('post_id')!;
    print(">>>>>>>>>>>>>> post id $postid");
    // var mineclass = prefs.getString('selectedClass');
    // mineclass == null
    //     ? selectedclass = null
    //     : selectedclass = classlistmodel.singledecode(mineclass);
    result = await getOneAssignmentApi(postid);
    print('>>>>>>>>>>>>>>>>>>>>>>$result');
    if (result['returnCode'] == '300') {
      setState(() {
        myclassassignment = [];
      });
    } else if (result['returnCode'] == '200') {
      List classassignmentList = List.from(result["post"]['assignments']);
      print('>>>>>>>>>>>>>>> classassignmentlist$classassignmentList');
      if (classassignmentList.isNotEmpty) {
        for (var i = 0; i < classassignmentList.length; i++) {
          myclassassignment.add(
            classassignmentlistmodel(
              assignmentId: classassignmentList[i]['asignment_id'] ?? "",
              postid: classassignmentList[i]['post_id'] ?? "",
              title: classassignmentList[i]['post_title'] ?? "",
              duedate: classassignmentList[i]['due_date'] ?? "",
            ),
          );
        }
        print(">>>>>>>>>>>>> class length ${myclassassignment.length}");

        String encodedclassassignment =
            classassignmentlistmodel.encode(myclassassignment);
        await prefs.setString('classassignmentList', encodedclassassignment);
      }
    }

    var mineclassassignment = prefs.getString('selectedclassAssignment');
    mineclassassignment == null
        ? selectedclassassignment = null
        : selectedclassassignment =
            classassignmentlistmodel.singledecode(mineclassassignment);
    setState(() {
      ready = true;
    });
  }

  @override
  void initState() {
    getOneClassAssignment();
    super.initState();
  }

  Future<void> _refresh() {
    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: darkmain,
          iconTheme: IconThemeData(
            color: maincolor,
            size: 30,
          ),
          title: Text("Assignment Details", style: appbarTextStyle(maincolor)),
        ),
        drawer: searchBoolean
            ? null
            : const SizedBox(
                // width: MediaQuery.of(context).size.width * 0.8,
                // child: DrawerScreen(
                //   pagename:
                //       selectedclass == null ? 'Home' : selectedclass!.title,
                // ),
                ),
        body: ready
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: myclassassignment.length,
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
                                            "assignment_id":
                                                myclassassignment[i]
                                                    .assignmentId,
                                            "class_id":
                                                myclassassignment[i].postid,
                                            "post_title":
                                                myclassassignment[i].title,
                                            "due_date":
                                                myclassassignment[i].duedate
                                          });
                                          print(">>>>> my data");
                                          print(mydata);
                                          // Navigator.push(
                                          //   context,
                                          //   PageTransition(
                                          //     type: PageTransitionType
                                          //         .bottomToTop,
                                          //     child: EditPost(
                                          //       editData: mydata,
                                          //       selectedclass:
                                          //           selectedclass!,
                                          //     ),
                                          //   ),
                                          // );
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
                                                  myclassassignment[i]
                                                              .assignmentId ==
                                                          selectedclassassignment
                                                              ?.assignmentId
                                                      ? Text(
                                                          "You have been viewing this assignment! Do you want to delete?",
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
                                                          "Are You sure to delete this assignment?",
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
                                                      // TextButton(
                                                      //   // 1/9
                                                      //   onPressed:
                                                      //       () async {
                                                      //     Navigator.pop(
                                                      //         context);
                                                      //     showLoadingDialog(
                                                      //         context,
                                                      //         "Loading. . .");

                                                      //     // showLoadingDialog(
                                                      //     //     context);
                                                      //     await delectedclasspost(
                                                      //         myclassassignment[i]
                                                      //             .assignmentId);
                                                      //   },
                                                      //   child: Text(
                                                      //     'Confirm',
                                                      //     style: TextStyle(
                                                      //         color:
                                                      //             darkmain,
                                                      //         fontSize:
                                                      //             ScreenUtil()
                                                      //                 .setSp(
                                                      //                     14),
                                                      //         fontWeight:
                                                      //             FontWeight
                                                      //                 .w500),
                                                      //   ),
                                                      // ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
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
                              child: ClassAssignmentModel(
                                eachclassassignment: myclassassignment[i],
                              ),
                            );
                          }),
                    )),
              )
            : Center(
                child: SpinKitFoldingCube(
                  color: paledarkmain,
                  size: 50,
                ),
              ),
      ),
    );
  }
}

class ClassAssignmentModel extends StatefulWidget {
  classassignmentlistmodel eachclassassignment;

  ClassAssignmentModel({super.key, required this.eachclassassignment});

  @override
  State<ClassAssignmentModel> createState() => _ClassAssignmentModelState();
}

class _ClassAssignmentModelState extends State<ClassAssignmentModel> {
  // List<studentlistinClass> studentlist = [];

  @override
  void initState() {
    setState(() {
      print(">>>>>>>>> assignments ${widget.eachclassassignment}");
      print(">>>>>>>>> assignments title ${widget.eachclassassignment.title}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: paledarkmain,
                  radius: 23,
                  child: Text(
                    widget.eachclassassignment.title == ""
                        ? ""
                        : widget.eachclassassignment.title[0].toUpperCase(),
                    // "",
                    style: buttonTextStyle,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '${widget.eachclassassignment.title.characters.take(36)}',
                  style: firstTextstyle,
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
