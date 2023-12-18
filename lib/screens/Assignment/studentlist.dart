// import 'dart:convert';

// import 'package:class_on_cloud/model/api.dart';
// import 'package:class_on_cloud/model/model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../model/component.dart';
// import '../../model/constant.dart';
// import '../drawer.dart';

// class StudentList extends StatefulWidget {
//   const StudentList({super.key});

//   @override
//   State<StudentList> createState() => _StudentListState();
// }

// class _StudentListState extends State<StudentList> {
//   List<studentlistinClass> mystudent = [];
//   studentlistinClass? selectedstudent;
//   bool show = false;
//   bool ready = false;
//   late var result;
//   classlistmodel? selectedclass;

//   getstudent() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     result = await getstudentapi(selectedclass!.classId);
//     print('>>>>>>>>>>>>>>>>>>>>>>$result');
//     if (result['returncode'] == '300') {
//       setState(() {
//         mystudent = [];
//       });
//     } else if (result['returncode'] == '200') {
//       List studentlist = result['data'];
//       print('>>>>>>>>>>>>>>> student list$studentlist');
//       if (studentlist.isNotEmpty) {
//         for (var i = 0; i < studentlist.length; i++) {
//           mystudent.add(studentlistinClass(
//             username: studentlist[i]['username'] ?? "",
//             studentEmail: studentlist[i]['student_email'] ?? "",
//             studentId: studentlist[i]['student_id'] ?? "",
//           ));
//           // print(">>>>>>>> ${myclass[0].coverpic}");
//         }

//         String encodedstudent = studentlistinClass.encode(mystudent);
//         await prefs.setString('studentlist', encodedstudent);
//       }
//     }

//     var minestudent = prefs.getString('selectedStudent');
//     minestudent == null
//         ? selectedstudent = null
//         : selectedstudent = studentlistinClass.singledecode(minestudent);
//     setState(() {
//       ready = true;
//     });
//   }

//   getselectedclass() async {
//     final prefs = await SharedPreferences.getInstance();
//     var mineclass = prefs.getString('selectedClass');
//     mineclass == null
//         ? selectedclass = null
//         : selectedclass = classlistmodel.singledecode(mineclass);
//   }

//   @override
//   void initState() {
//     getselectedclass();
//     getstudent();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backcolor,
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: darkmain,
//         iconTheme: IconThemeData(
//           color: maincolor,
//           size: 30,
//         ),
//         title: Text("Student List", style: appbarTextStyle(maincolor)),
//       ),
//       drawer: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.8,
//         child: DrawerScreen(
//           pagename: 'Student List',
//         ),
//       ),
//       body: ready
//           ? mystudent.isEmpty
//               ? Center(
//                   child: Text(
//                     "You don't have any list yet!",
//                     style: inputTextStyle,
//                   ),
//                 )
//               : Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 0.0),
//                   child: Container(
//                       height: MediaQuery.of(context).size.height,
//                       width: MediaQuery.of(context).size.width,
//                       child: ListView.builder(
//                           itemCount: mystudent.length,
//                           itemBuilder: (context, i) {
//                             return Slidable(
//                               endActionPane: ActionPane(
//                                 extentRatio: 0.26,
//                                 motion: const DrawerMotion(),
//                                 children: [
//                                   Expanded(
//                                     child: InkWell(
//                                       onTap: () {
//                                         setState(
//                                           () {
//                                             print(">>>>> my data");
//                                             var mydata = jsonEncode({
//                                               "student_id":
//                                                   mystudent[i].studentId,
//                                               "username": mystudent[i].username,
//                                               "student_email":
//                                                   mystudent[i].studentEmail,
//                                             });
//                                             print(">>>>> my data");
//                                             print(mydata);
//                                           },
//                                         );
//                                       },
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Container(
//                                               height: MediaQuery.of(context)
//                                                       .size
//                                                       .height *
//                                                   0.09,
//                                               margin:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 5),
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 2,
//                                                       vertical: 0),
//                                               alignment: Alignment.center,
//                                               // width: 20 *
//                                               //     4, // space for actionPan
//                                               decoration: BoxDecoration(
//                                                   color: paledarkmain,
//                                                   shape: BoxShape.circle),
//                                               child: const Icon(Icons.edit,
//                                                   size: 20,
//                                                   color: Colors.white)),
//                                           Divider(
//                                             color: Colors.grey[300],
//                                             thickness: 1,
//                                             height: 1.1,
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: InkWell(
//                                       onTap: () {
//                                         showDialog(
//                                           context: context,
//                                           builder: (BuildContext context) {
//                                             return AlertDialog(
//                                               contentPadding:
//                                                   const EdgeInsets.only(
//                                                 left: 10,
//                                                 top: 15,
//                                               ),
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                               ),
//                                               content: Column(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   mystudent[i].studentId ==
//                                                           selectedstudent
//                                                               ?.studentId
//                                                       ? Text(
//                                                           "You have been viewing this list! Do you want to delete?",
//                                                           style: TextStyle(
//                                                               color: Colors
//                                                                   .redAccent,
//                                                               fontSize:
//                                                                   ScreenUtil()
//                                                                       .setSp(
//                                                                           15),
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500),
//                                                         )
//                                                       : Text(
//                                                           "Are You sure to delete this list?",
//                                                           style: TextStyle(
//                                                               color: seccolor,
//                                                               fontSize:
//                                                                   ScreenUtil()
//                                                                       .setSp(
//                                                                           15),
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500),
//                                                         ),
//                                                   const SizedBox(
//                                                     height: 10,
//                                                   ),
//                                                   Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.end,
//                                                     children: [
//                                                       TextButton(
//                                                           onPressed: () {
//                                                             Navigator.pop(
//                                                                 context);
//                                                           },
//                                                           child: Text(
//                                                             "Cancel",
//                                                             style: TextStyle(
//                                                                 color: seccolor,
//                                                                 fontSize:
//                                                                     ScreenUtil()
//                                                                         .setSp(
//                                                                             14),
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500),
//                                                           )),
//                                                       TextButton(
//                                                         // 1/9
//                                                         onPressed: () async {},
//                                                         child: Text(
//                                                           'Confirm',
//                                                           style: TextStyle(
//                                                               color: darkmain,
//                                                               fontSize:
//                                                                   ScreenUtil()
//                                                                       .setSp(
//                                                                           14),
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   )
//                                                 ],
//                                               ),
//                                             );
//                                           },
//                                         );
//                                       },
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Container(
//                                               height: MediaQuery.of(context)
//                                                       .size
//                                                       .height *
//                                                   0.09,
//                                               margin:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 5),
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 2,
//                                                       vertical: 0),
//                                               alignment: Alignment.center,
//                                               // width: 20 *
//                                               //     4, // space for actionPan
//                                               decoration: const BoxDecoration(
//                                                   color: Colors.redAccent,
//                                                   shape: BoxShape.circle),
//                                               child: const Icon(Icons.delete,
//                                                   size: 20,
//                                                   color: Colors.white)),
//                                           Divider(
//                                             color: Colors.grey[300],
//                                             thickness: 1,
//                                             height: 1.1,
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               child: StudentModel(
//                                 eachstudent: mystudent[i],
//                               ),
//                             );
//                           })),
//                 )
//           : Center(
//               child: SpinKitFoldingCube(
//                 color: paledarkmain,
//                 size: 50,
//               ),
//             ),
//     );
//   }
// }

// class StudentModel extends StatefulWidget {
//   studentlistinClass eachstudent;
//   // String classname;
//   StudentModel({super.key, required this.eachstudent});

//   @override
//   State<StudentModel> createState() => _StuedentModelState();
// }

// class _StuedentModelState extends State<StudentModel> {
//   List<studentlistinClass> studentlist = [];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           height: MediaQuery.of(context).size.height * 0.1,
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(color: backcolor),
//           padding: const EdgeInsets.all(8),
//           child: Row(
//             // crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               CircleAvatar(
//                   backgroundColor: paledarkmain, 
//                   radius: 25,
//                   child: Text(
//                     widget.eachstudent.username[0].toUpperCase(),
//                     style: buttonTextStyle,
//                   )),
//               const SizedBox(
//                 width: 10,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('${widget.eachstudent.studentEmail.characters.take(36)}',
//                       style: firstTextstyle),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Divider(
//           color: Colors.grey[300],
//           thickness: 1,
//           height: 1.1,
//         )
//       ],
//     );
//   }
// }
