import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/api.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:class_on_cloud/screens/Classes/create_class.dart';
import 'package:class_on_cloud/screens/classposting.dart';
import 'package:class_on_cloud/screens/drawer.dart';
import 'package:class_on_cloud/screens/Classes/edit_class.dart';
import 'package:class_on_cloud/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:class_on_cloud/model/component.dart';

// import 'package:http/http.dart' as http;

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  TextEditingController classnamecontroller = TextEditingController();

  TextEditingController customgradecontroller = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  List<classlistmodel> myclass = [];
  classlistmodel? selectedclass;

  bool show = false;
  bool ready = false;
  late var result;
  List<String> dropdownlist = [
    'KG',
    'Grade 1',
    'Grade 2',
    'Grade 3',
    'Grade 4',
    'Grade 5',
    'Grade 6',
    'Grade 7',
    'Grade 8',
    'Grade 9',
    'Grade 10',
    'Grade 11'
  ];

  getclass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    result = await getclassapi();
    print('>>>>>>>>>>>>>>>>>>>>>>$result');
    if (result['returncode'] == '300') {
      setState(() {
        myclass = [];
      });
    } else if (result['returncode'] == '200') {
      List classlist = result['data'];
      print('>>>>>>>>>>>>>>> class list$classlist');
      if (classlist.isNotEmpty) {
        for (var i = 0; i < classlist.length; i++) {
          myclass.add(
            classlistmodel(
              classId: classlist[i]['class_id'],
              title: classlist[i]['title'],
              subtitle: classlist[i]['subtitle'],
              schoolId: classlist[i]['school_id'],
              privateId: classlist[i]['private_id'],
              description: classlist[i]['description'],
              picUrl: classlist[i]["pic_url"],
              coverpic: classlist[i]["cover_pic"],
            ),
          );
          print(">>>>>>>> ${myclass[0].coverpic}");
        }

        String encodedclass = classlistmodel.encode(myclass);
        await prefs.setString('classList', encodedclass);
      }
    }

    var mineclass = prefs.getString('selectedClass');
    mineclass == null
        ? selectedclass = null
        : selectedclass = classlistmodel.singledecode(mineclass);
    setState(() {
      ready = true;
    });
  }

  deleteclass(String classid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    result = await deleteclassapi(classid);

    print('>><><><>< before>>${myclass.length}');
    if (classid == selectedclass?.classId) {
      var removedData =
          myclass.removeWhere((element) => element.classId == classid);

      print('>><><><>< ${myclass.length}');
      if (myclass.isEmpty) {
        var addinnull = await prefs.remove('selectedClass');
        print('><><>>>>>Nulling $addinnull');
      } else {
        String selectedencode = classlistmodel.sigleencode(myclass[0]);
        await prefs.setString("selectedClass", selectedencode);
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
          MaterialPageRoute(builder: (context) => const ClassesScreen()),
          (route) => false);
    } else {
      Navigator.pop(context);
      showToast('${result['returncode']}', 'red');
    }
    setState(() {});
  }

  String url = '';
  bool getloading = false;
  bool submitted = false;

  @override
  void initState() {
    getclass();
    // TODO: implement initState
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
        // automaticallyImplyLeading:  searchBoolean ? false : true,
        title: Text("Classes", style: appbarTextStyle(maincolor)),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Icon(
        //       Icons.search_sharp,
        //       color: maincolor,
        //       size: 30,
        //     ),
        //   )
        // ],
      ),
      drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: DrawerScreen(
            pagename: 'Classes',
          )),
      body: ready
          ? myclass.isEmpty
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
                          itemCount: myclass.length,
                          itemBuilder: (context, i) {
                            return Slidable(
                              endActionPane: ActionPane(
                                extentRatio: 0.26,
                                motion: const DrawerMotion(),
                                children: [
                                  Expanded(
                                    //  InkWell(
                                    //                 onTap: (() {
                                    //                   setState(() {
                                    //                     Navigator.push(
                                    //                       context,
                                    //                       MaterialPageRoute(
                                    //                         builder: (context) =>
                                    //                             EditCategory(
                                    //                           editData:
                                    //                               categoryList[
                                    //                                   i],
                                    //                         ),
                                    //                       ),
                                    //                     );
                                    //                   });
                                    //                 }),
                                    //                 child: Container(
                                    //                   height: 50,
                                    //                   width: 50,
                                    //                   color: Colors.blue,
                                    //                   child: const Icon(
                                    //                     Icons.edit,
                                    //                     size: 15,
                                    //                     color: Colors.white,
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //               const SizedBox(
                                    //                 width: 10,
                                    //               ),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          print(">>>>> my data");
                                          var mydata = jsonEncode({
                                            "classId": myclass[i].classId,
                                            "description":
                                                myclass[i].description,
                                            "picUrl": myclass[i].picUrl,
                                            "privateId": myclass[i].privateId,
                                            "schoolId": myclass[i].schoolId,
                                            "subtitle": myclass[i].subtitle,
                                            "title": myclass[i].title,
                                            "cover_pic": myclass[i].coverpic,
                                          });
                                          print(">>>>> my data");
                                          print(mydata);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditClass(
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
                                                  myclass[i].classId ==
                                                          selectedclass?.classId
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
                                                          await deleteclass(
                                                              myclass[i]
                                                                  .classId);
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
                              child: ClassModel(
                                eachclass: myclass[i],
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
              MaterialPageRoute(builder: (context) => const CreateClass()));
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: darkmain,
      //   onPressed: () {
      //     showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return StatefulBuilder(builder: (context, setState) {
      //           return Form(
      //             key: key,
      //             child: AlertDialog(
      //               backgroundColor: backcolor,
      //               insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      //               contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      //               titlePadding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      //               shape: const RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.all(Radius.circular(10.0))),
      //               title: Column(
      //                 children: [
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       Text(
      //                         'Create New Class',
      //                         style: TextStyle(
      //                             color: darkmain,
      //                             fontSize: ScreenUtil().setSp(20),
      //                             fontWeight: FontWeight.w500),
      //                       ),
      //                       GestureDetector(
      //                         onTap: () {
      //                           Navigator.pop(context);
      //                         },
      //                         child: const Icon(
      //                           Icons.close,
      //                           color: Color.fromARGB(255, 28, 28, 28),
      //                           size: 30,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   const Divider(
      //                     color: Colors.grey,
      //                     thickness: 1,
      //                   ),
      //                 ],
      //               ),
      //               content: SingleChildScrollView(
      //                 child: SizedBox(
      //                   width: MediaQuery.of(context).size.width,
      //                   height: MediaQuery.of(context).size.width - 80,
      //                   child: Column(
      //                     children: [
      //                       Row(
      //                         children: [
      //                           Text(
      //                             'ClassName',
      //                             style: labelTextStyle,
      //                           ),
      //                         ],
      //                       ),
      //                       Container(
      //                         padding: const EdgeInsets.only(top: 10),
      //                         child: TextFormField(
      //                           controller: classnamecontroller,
      //                           autofocus: false,
      //                           autocorrect: false,
      //                           textCapitalization: TextCapitalization.words,
      //                           autovalidateMode: submitted
      //                               ? AutovalidateMode.always
      //                               : AutovalidateMode.disabled,
      //                           validator: RequiredValidator(
      //                               errorText: "Class name cannot be blank !"),
      //                           decoration: const InputDecoration(
      //                             contentPadding: EdgeInsets.all(15.0),
      //                             filled: true,
      //                             fillColor: Colors.white,
      //                             // hintText: 'Enter your email address',
      //                             border: OutlineInputBorder(
      //                               borderRadius: BorderRadius.all(
      //                                 Radius.circular(10.0),
      //                               ),
      //                               borderSide: BorderSide.none,
      //                             ),
      //                           ),
      //                           style: labelTextStyle,
      //                           cursorColor: seccolor,
      //                         ),
      //                       ),
      //                       const SizedBox(
      //                         height: 20,
      //                       ),
      //                       Row(
      //                         children: [
      //                           Text(
      //                             'Choose Your Grade',
      //                             style: labelTextStyle,
      //                           ),
      //                         ],
      //                       ),
      //                       Stack(children: [
      //                         Column(
      //                           children: [
      //                             Container(
      //                               padding: const EdgeInsets.only(top: 10),
      //                               child: TextFormField(
      //                                 controller: customgradecontroller,
      //                                 autofocus: false,
      //                                 autocorrect: false,
      //                                 textCapitalization:
      //                                     TextCapitalization.words,
      //                                 autovalidateMode: submitted
      //                                     ? AutovalidateMode.always
      //                                     : AutovalidateMode.disabled,
      //                                 validator: RequiredValidator(
      //                                     errorText:
      //                                         "Class name cannot be blank !"),
      //                                 decoration: InputDecoration(
      //                                     contentPadding:
      //                                         const EdgeInsets.all(15.0),
      //                                     filled: true,
      //                                     fillColor: Colors.white,
      //                                     // hintText: 'Enter your email address',
      //                                     border: const OutlineInputBorder(
      //                                       borderRadius: BorderRadius.all(
      //                                         Radius.circular(10.0),
      //                                       ),
      //                                       borderSide: BorderSide.none,
      //                                     ),
      //                                     suffixIcon: GestureDetector(
      //                                         onTap: () {
      //                                           setState(() {
      //                                             show = !show;
      //                                             print('>>>>> $show');
      //                                           });
      //                                         },
      //                                         child: Icon(
      //                                           Icons.arrow_drop_down,
      //                                           color: seccolor,
      //                                           size: 30,
      //                                         ))),
      //                                 style: labelTextStyle,
      //                                 cursorColor: seccolor,
      //                               ),
      //                             ),
      //                             Padding(
      //                               padding: const EdgeInsets.only(top: 20.0),
      //                               child: SizedBox(
      //                                   width:
      //                                       MediaQuery.of(context).size.width -
      //                                           30,
      //                                   height:
      //                                       MediaQuery.of(context).size.height *
      //                                           0.06,
      //                                   child: MaterialButton(
      //                                     elevation: 0,
      //                                     shape: RoundedRectangleBorder(
      //                                       borderRadius:
      //                                           BorderRadius.circular(6),
      //                                     ),
      //                                     color: darkmain,
      //                                     onPressed: () async {
      //                                       setState(() {
      //                                         submitted = true;
      //                                       });
      //                                       if (key.currentState!.validate()) {
      //                                         setState(() {
      //                                           getloading = true;
      //                                         });
      //                                         var returncode =
      //                                             await createclassapi(
      //                                                 classnamecontroller.text,
      //                                                 customgradecontroller
      //                                                     .text);
      //                                         print('><><ret><> $returncode');
      //                                         if (returncode == '200') {
      //                                           // ignore: use_build_context_synchronously
      //                                           Navigator.pop(context);
      //                                           // ignore: use_build_context_synchronously
      //                                           Navigator.push(
      //                                             context,
      //                                             MaterialPageRoute(
      //                                                 builder: (context) =>
      //                                                     const ClassesScreen()),
      //                                           );
      //                                           classnamecontroller.clear();
      //                                           customgradecontroller.clear();
      //                                         }
      //                                         setState(() {
      //                                           getloading = false;
      //                                           submitted = false;
      //                                         });
      //                                       }
      //                                     },
      //                                     child: getloading
      //                                         ? const SpinKitDoubleBounce(
      //                                             color: Colors.white,
      //                                             size: 15.0,
      //                                           )
      //                                         : Text(
      //                                             'Create',
      //                                             style: TextStyle(
      //                                                 color: maincolor,
      //                                                 fontSize: ScreenUtil()
      //                                                     .setSp(20),
      //                                                 fontWeight:
      //                                                     FontWeight.w500),
      //                                           ),
      //                                   )),
      //                             ),
      //                           ],
      //                         ),
      //                         show
      //                             ? Container(
      //                                 height: 130,
      //                                 width: MediaQuery.of(context).size.width -
      //                                     20,
      //                                 decoration: const BoxDecoration(
      //                                     color: Colors.white,
      //                                     borderRadius: BorderRadius.all(
      //                                         Radius.circular(10))),
      //                                 child: ListView.builder(
      //                                   itemCount: dropdownlist.length,
      //                                   itemBuilder: (context, index) {
      //                                     return Column(
      //                                       children: [
      //                                         GestureDetector(
      //                                           onTap: () {
      //                                             customgradecontroller.text =
      //                                                 dropdownlist[index]
      //                                                     .toString();
      //                                             setState(() {
      //                                               show = false;
      //                                             });
      //                                           },
      //                                           child: ListTile(
      //                                             title:
      //                                                 Text(dropdownlist[index]),
      //                                           ),
      //                                         ),
      //                                         index != 11
      //                                             ? Padding(
      //                                                 padding: const EdgeInsets
      //                                                         .symmetric(
      //                                                     horizontal: 8.0),
      //                                                 child: Divider(
      //                                                   color: darkmain,
      //                                                 ),
      //                                               )
      //                                             : Container()
      //                                       ],
      //                                     );
      //                                   },
      //                                 ),
      //                               )
      //                             : Container()
      //                       ]),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           );
      //         });
      //       },
      //     );
      //   },
      //   child: const Icon(
      //     Icons.add,
      //     size: 30,
      //   ),
      // ),
    );
  }
}

class ClassModel extends StatefulWidget {
  classlistmodel eachclass;
  // String classname;
  ClassModel({super.key, required this.eachclass});

  @override
  State<ClassModel> createState() => _ClassModelState();
}

class _ClassModelState extends State<ClassModel> {
  List<studentlistinClass> studentlist = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // print(">>><><>>>>>> ${widget.eachclass.classId}");
        final prefs = await SharedPreferences.getInstance();
        showLoadingDialog(context, 'Preparing Your class');
        var apiresult = await getsingleclassapi(widget.eachclass.classId);
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
        String selectedencode = classlistmodel.sigleencode(widget.eachclass);
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
                      widget.eachclass.title[0].toUpperCase(),
                      style: buttonTextStyle,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${widget.eachclass.title.characters.take(36)}',
                        style: firstTextstyle),
                    // Text(
                    //   '${widget.eachclass.description}',
                    //   style: secondTextstyle(Colors.grey[600]),
                    // ),
                    //  Text(
                    //   '${widget.eachclass.schoolId}',
                    //   style: secondTextstyle(Colors.grey[600]),
                    // ),
                    Text(
                      widget.eachclass.subtitle,
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
