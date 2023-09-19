import 'package:class_on_cloud/main.dart';
import 'package:class_on_cloud/model/api.dart';
import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:class_on_cloud/screens/addfamilymember.dart';
import 'package:class_on_cloud/screens/drawer.dart';
import 'package:class_on_cloud/screens/home.dart';
import 'package:class_on_cloud/screens/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentDetailScreen extends StatefulWidget {
  studentlistinClass studentdata;
  classlistmodel selectedclass;
  StudentDetailScreen(
      {super.key, required this.studentdata, required this.selectedclass});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  late studentlistinClass selectedstudent;
  late classlistmodel selectedclass;
  TextEditingController studentname = TextEditingController();
  TextEditingController studentemail = TextEditingController();
  // TextEditingController familymail = TextEditingController();

  List<studentlistinClass> studentlist = [];

  bool submitted = false;

  deletestudent() async {
    final prefs = await SharedPreferences.getInstance();
    var result = await deletestudentapi(
        selectedclass.classId, selectedstudent.studentId);
    if (result['returncode'] == '200') {
      var getresult = await getstudentapi(selectedclass.classId);
      // print('Getdata >>> ${getresult}');
      List students = getresult['data'];
      studentlist = [];
      for (var i = 0; i < students.length; i++) {
        studentlist.add(studentlistinClass.fromJson(students[i]));
      }
      String encodedData = studentlistinClass.encode(studentlist);
      await prefs.setString('selectedstudentList', encodedData);
      print(">>><><number of student>>>>>> ${studentlist.length}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => NavbarScreen(
            screenindex: 2,
          ),
        ),
      );
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (BuildContext context) => Home()),
      //     (Route<dynamic> route) => route.isFirst);
    } else {
      showToast(result['returncode'], 'red');
    }
  }

  @override
  void initState() {
    setState(() {
      selectedstudent = widget.studentdata;
      selectedclass = widget.selectedclass;
    });
    studentname.text = selectedstudent.username;
    studentemail.text = selectedstudent.studentEmail;
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
          backgroundColor: backcolor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: seccolor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Student Detail", style: appbarTextStyle(seccolor))),
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
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: CircleAvatar(
                                backgroundColor: darkmain,
                                radius: 50,
                                child: Text(
                                  widget.studentdata.username[0].toUpperCase(),
                                  style: profileTextstyle,
                                )),
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
                    ],
                  ),
                  Text(
                    ' Name',
                    style: labelTextStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10, top: 5),
                    child: TextFormField(
                      controller: studentname,
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
                            selectedstudent.studentEmail,
                            style: labelTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.only(bottom: 10, top: 5),
                  //   child: TextFormField(
                  //     controller: studentemail,
                  //     autofocus: false,
                  //     autocorrect: false,
                  //     autovalidateMode: submitted
                  //         ? AutovalidateMode.always
                  //         : AutovalidateMode.disabled,
                  //     decoration: const InputDecoration(
                  //       contentPadding: EdgeInsets.all(15.0),
                  //       filled: true,
                  //       fillColor: Colors.white,
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(
                  //           Radius.circular(10.0),
                  //         ),
                  //         borderSide: BorderSide.none,
                  //       ),
                  //     ),
                  //     style: labelTextStyle,
                  //     cursorColor: seccolor,
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 20),
                    child: InkWell(
                      onTap: () {
                        print('toosometer>>>>');
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: AddFamilymemberScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Family Members',
                              style: labelTextStyle,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: seccolor,
                              size: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                  //   child: TextFormField(
                  //     controller: familymail,
                  //     autovalidateMode:
                  //         focus.hasFocus && familymail.text != lastValue
                  //             ? AutovalidateMode.always
                  //             : AutovalidateMode.disabled,
                  //     validator: emailValidator,
                  //     textInputAction: TextInputAction.send,
                  //     focusNode: focus,
                  //     decoration: const InputDecoration(
                  //       contentPadding: EdgeInsets.all(15.0),
                  //       filled: true,
                  //       fillColor: Colors.white,
                  //       // hintText: 'Enter your email address',
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(
                  //           Radius.circular(10.0),
                  //         ),
                  //         borderSide: BorderSide.none,
                  //       ),
                  //     ),
                  //     style: labelTextStyle,
                  //     cursorColor: seccolor,
                  //     onChanged: (String val) {
                  //       emails.length < 5
                  //           ? setState(() {
                  //               if (val != lastValue && val.endsWith(' ')) {
                  //                 if (emailValidator
                  //                     .isValid(familymail.text.trim())) {
                  //                   if (!emails.contains(val.trim())) {
                  //                     emails.add(val.trim());
                  //                     print('>>>>Mails>> $emails');
                  //                     familymail.clear();
                  //                     // widget.setList(emails);
                  //                   } else {
                  //                     showToast(
                  //                         'This student email is already in the list',
                  //                         'red');
                  //                   }
                  //                 }
                  //               }
                  //             })
                  //           : null;
                  //     },
                  //     onEditingComplete: () {
                  //       if (emailValidator.isValid(familymail.text.trim())) {
                  //         emails.length < 5
                  //             ? updateEmails()
                  //             : showToast(
                  //                 "Only five family member can be add for single student",
                  //                 'red');
                  //       }
                  //     },
                  //   ),
                  // ),
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: Wrap(
                  //       spacing: 4,
                  //       alignment: WrapAlignment.start,
                  //       children: [
                  //         ...emails.map((e) => Padding(
                  //               padding:
                  //                   const EdgeInsets.symmetric(vertical: 5.0),
                  //               child: Chip(
                  //                 label: Text(e),
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(10.0),
                  //                 ),
                  //                 elevation: 2,
                  //                 backgroundColor: Colors.grey[300],
                  //                 labelStyle: TextStyle(
                  //                     fontSize: ScreenUtil().setSp(12),
                  //                     color: Colors.black),
                  //                 // deleteIcon: Icon(Icons.close_rounded,size: 18,),
                  //                 onDeleted: () => {
                  //                   setState(() {
                  //                     emails
                  //                         .removeWhere((element) => e == element);
                  //                   }),
                  //                   print(emails),
                  //                 },
                  //               ),
                  //             ))
                  //       ]),
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Container(
                              // margin: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: MaterialButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // padding: const EdgeInsets.all(5),
                                color: Colors.redAccent,
                                onPressed: () {
                                  logoutdialog(
                                      context,
                                      'Are you sure to remove this student?',
                                      deletestudent);
                                },
                                child: Text("Remove", style: buttonTextStyle),
                              ))),
                      Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Container(
                              // margin: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 0.4,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
