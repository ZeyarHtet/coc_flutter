// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:class_on_cloud/model/api.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:class_on_cloud/screens/Assignment/assignment_details.dart';
import 'package:class_on_cloud/screens/Posts/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/component.dart';
import '../../model/constant.dart';
import '../drawer.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  bool searchBoolean = false;

  List<assignmentlistmodel> myassignment = [];
  assignmentlistmodel? selectedassignment;
  classlistmodel? selectedclass;
  bool ready = false;

  Future<void> _refresh() async {
    await getassignment();
    return Future.delayed(const Duration(seconds: 2));
  }

  getassignment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mineclass = prefs.getString('selectedClass');
    mineclass == null
        ? selectedclass = null
        : selectedclass = classlistmodel.singledecode(mineclass);
    var result = await getclasspostapi(selectedclass!.classId);
    print('>>>>>>>>>>>>>>>>>>>>>>$result');
    if (result['returnCode'] == '300') {
      setState(() {
        myassignment = [];
      });
    } else if (result['returnCode'] == '200') {
      List assignmentList = result['posts'];
      if (assignmentList.isNotEmpty) {
        for (var i = 0; i < assignmentList.length; i++) {
          if (assignmentList[i]['type'] == 2) {
            myassignment.add(
              assignmentlistmodel(
                postId: assignmentList[i]['post_id'] ?? "",
                classId: assignmentList[i]['class_id'] ?? "",
                title: assignmentList[i]['title'] ?? "",
                duedate: assignmentList[i]['due_date'] ?? "",
              ),
            );
          }
        }
        print(">>>>>>>>>>>>> assignment length ${myassignment.length}");

        String encodedassignment = assignmentlistmodel.encode(myassignment);
        await prefs.setString('assignmentList', encodedassignment);
      }
    }

    var mineassignment = prefs.getString('selectedassignment');
    mineassignment == null
        ? selectedassignment = null
        : selectedassignment = assignmentlistmodel.singledecode(mineassignment);
    setState(() {
      ready = true;
    });
  }

  @override
  void initState() {
    getassignment();
    super.initState();
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
          title: Text("Assignment", style: appbarTextStyle(maincolor)),
        ),
        drawer: searchBoolean
            ? null
            : SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: DrawerScreen(
                  pagename:
                      selectedclass == null ? 'Home' : selectedclass!.title,
                ),
              ),
        body: ready
            ? myassignment.isEmpty
                ? Center(
                    child: Text(
                      "You don't have any assignment yet!",
                      style: inputTextStyle,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: myassignment.length,
                          itemBuilder: (context, i) {
                            return ClassAssignmentModel(
                              eachassignment: myassignment[i],
                            );
                          },
                        ),
                      ),
                    ),
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

  // dialog(i) {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         contentPadding: const EdgeInsets.only(
  //           left: 10,
  //           top: 15,
  //         ),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             myclasspost[i].postId == selectedclasspost?.postId
  //                 ? Text(
  //                     "You have been viewing this assignment! Do you want to delete?",
  //                     style: TextStyle(
  //                         color: Colors.redAccent,
  //                         fontSize: ScreenUtil().setSp(15),
  //                         fontWeight: FontWeight.w500),
  //                   )
  //                 : Text(
  //                     "Are You sure to delete this asignment?",
  //                     style: TextStyle(
  //                         color: seccolor,
  //                         fontSize: ScreenUtil().setSp(15),
  //                         fontWeight: FontWeight.w500),
  //                   ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text(
  //                     "Cancel",
  //                     style: TextStyle(
  //                       color: seccolor,
  //                       fontSize: ScreenUtil().setSp(
  //                         14,
  //                       ),
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget assignmentbody() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 0.0),
  //     child: Container(
  //       height: MediaQuery.of(context).size.height,
  //       width: MediaQuery.of(context).size.width,
  //       child: RefreshIndicator(
  //         onRefresh: _refresh,
  //         child: ListView.builder(
  //           shrinkWrap: true,
  //           itemCount: myclasspost.length,
  //           itemBuilder: (context, i) {
  //             // return Slidable(
  //             //   endActionPane: ActionPane(
  //             //     extentRatio: 0.26,
  //             //     motion: const DrawerMotion(),
  //             //     children: [
  //             //       Expanded(
  //             //         child: InkWell(
  //             //           onTap: () {
  //             //             setState(() {});
  //             //           },
  //             //           child: Column(
  //             //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             //             children: [
  //             //               Container(
  //             //                 height: MediaQuery.of(context).size.height * 0.09,
  //             //                 margin: const EdgeInsets.symmetric(horizontal: 5),
  //             //                 padding: const EdgeInsets.symmetric(
  //             //                     horizontal: 2, vertical: 0),
  //             //                 alignment: Alignment.center,
  //             //                 decoration: BoxDecoration(
  //             //                   color: paledarkmain,
  //             //                   shape: BoxShape.circle,
  //             //                 ),
  //             //                 child: const Icon(
  //             //                   Icons.edit,
  //             //                   size: 20,
  //             //                   color: Colors.white,
  //             //                 ),
  //             //               ),
  //             //               Divider(
  //             //                 color: Colors.grey[300],
  //             //                 thickness: 1,
  //             //                 height: 1.1,
  //             //               )
  //             //             ],
  //             //           ),
  //             //         ),
  //             //       ),
  //             //       Expanded(
  //             //         child: InkWell(
  //             //           onTap: () {
  //             //             dialog(i);
  //             //           },
  //             //           child: Column(
  //             //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             //             children: [
  //             //               Container(
  //             //                   height:
  //             //                       MediaQuery.of(context).size.height * 0.09,
  //             //                   margin:
  //             //                       const EdgeInsets.symmetric(horizontal: 5),
  //             //                   padding: const EdgeInsets.symmetric(
  //             //                       horizontal: 2, vertical: 0),
  //             //                   alignment: Alignment.center,
  //             //                   decoration: const BoxDecoration(
  //             //                       color: Colors.redAccent,
  //             //                       shape: BoxShape.circle),
  //             //                   child: const Icon(Icons.delete,
  //             //                       size: 20, color: Colors.white)),
  //             //               Divider(
  //             //                 color: Colors.grey[300],
  //             //                 thickness: 1,
  //             //                 height: 1.1,
  //             //               )
  //             //             ],
  //             //           ),
  //             //         ),
  //             //       ),
  //             //     ],
  //             //   ),
  //             //   child: ClassPostModel(
  //             //     eachclasspost: myclasspost[i],
  //             //   ),
  //             // );
  //             return ClassPostModel(
  //               eachclasspost: myclasspost[i],
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class ClassAssignmentModel extends StatefulWidget {
  final assignmentlistmodel eachassignment;

  const ClassAssignmentModel({super.key, required this.eachassignment});

  @override
  State<ClassAssignmentModel> createState() => _ClassAssignmentModelState();
}

class _ClassAssignmentModelState extends State<ClassAssignmentModel> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('post_id', widget.eachassignment.postId);
        setState(() {});
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AssignmentDetailsScreen(),
          ),
        );
      },
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
                    widget.eachassignment.title == ""
                        ? ""
                        : widget.eachassignment.title[0].toUpperCase(),
                    style: buttonTextStyle,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.eachassignment.title.characters.take(36)}',
                      style: firstTextstyle,
                    ),
                    Text(
                      widget.eachassignment.duedate == ""
                          ? ""
                          : DateFormat("dd-MM-yyyy").format(
                              DateTime.parse(widget.eachassignment.duedate)),
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
