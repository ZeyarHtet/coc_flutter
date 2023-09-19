import 'package:class_on_cloud/model/api.dart';
import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:class_on_cloud/screens/home.dart';
import 'package:class_on_cloud/screens/student.dart';
import 'package:class_on_cloud/screens/testscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
// import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddStudentScreen extends StatefulWidget {
  classlistmodel? selectedclass;
  AddStudentScreen({super.key, required this.selectedclass});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  // TextEditingController realemailcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();

  bool showerror = false;
  bool getloading = false;
  bool submitted = false;
  // bool isready = false;

  List<String> emails = [];
  String notexist = '';
  String notstudeent = '';
  String alreadyinclass = '';
  String successfullyadded = '';

  List<studentlistinClass> studentlist = [];
  // List<String> titlelist = [];
  // String initialtitle = '';
  // String initialtitleId = '';
  String lastValue = '';
  double mailheignt = 0;

  FocusNode focus = FocusNode();

  // AutovalidateMode emailautovalidate = AutovalidateMode.disabled;

  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final containerkey = GlobalKey();

  updateEmails() {
    setState(() {
      if (!emails.contains(emailcontroller.text)) {
        emails.add(emailcontroller.text.trim());
        // widget.setList(emails);
      }
      emailcontroller.clear();
    });
    print('>>emaillist $emails');
  }

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'enter a valid email address'),
  ]);
  static const _kFontFam = 'Student_error';
  static const String? _kFontPkg = null;

  static const IconData ok_circled =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData info_circled =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData attention =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData help_circled =
      IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  // getclassdata() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // var instruder = prefs.getString('UserData');
  //   // instruder == null?  null :
  //   setState(() {
  //     var mineclass = prefs.getString('selectedClass');
  //     print(">><mineclass ${mineclass.toString()}");
  //     mineclass == null
  //         ? selectedclass = null
  //         : selectedclass = classlistmodel.singledecode(mineclass);
  //     print('<<<<SElectedone>>>${selectedclass?.title}');

  //     isready = true;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    focus.addListener(() {
      print('>>focus< ${focus.hasFocus}');
    });
  }

  @override
  void dispose() {
    focus.dispose();
    // TODO: implement dispose
    super.dispose();
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
            onPressed: () {
              // Navigator.pop(context);
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => NavbarScreen(
                    screenindex: 2,
                  ),
                ),
              );
            },
          ),
          title: Text("Add Students", style: appbarTextStyle(seccolor))),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              //here
              FocusScope.of(context).unfocus();
            },
            child: Form(
                key: key,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Class',
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
                                  widget.selectedclass!.title,
                                  style: labelTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'Student Emails',
                          style: labelTextStyle,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: emailcontroller,
                            textCapitalization: TextCapitalization.none,
                            autovalidateMode: emailcontroller.text != lastValue
                                ? AutovalidateMode.always
                                : AutovalidateMode.disabled,
                            validator: emailValidator,
                            textInputAction: TextInputAction.send,
                            focusNode: focus,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(15.0),
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
                            onChanged: (String val) {
                              setState(() {
                                if (val != lastValue && val.endsWith(' ')) {
                                  if (emailValidator
                                      .isValid(emailcontroller.text.trim())) {
                                    if (!emails.contains(val.trim())) {
                                      emails.add(val.trim());
                                      print('>>>>Mails>> $emails');
                                      emailcontroller.clear();
                                      // widget.setList(emails);
                                    } else {
                                      showToast(
                                          'This student email is already in the list',
                                          'red');
                                    }
                                  }
                                }
                              });
                            },
                            onEditingComplete: () {
                              if (emailValidator
                                  .isValid(emailcontroller.text.trim())) {
                                updateEmails();
                              }
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Wrap(
                              spacing: 4,
                              alignment: WrapAlignment.start,
                              children: [
                                ...emails.map((e) => Chip(
                                      label: Text(e),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 1,
                                      backgroundColor: trandarkmain,
                                      labelStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(12),
                                          color: Colors.black),
                                      // deleteIcon: Icon(Icons.close_rounded,size: 18,),
                                      onDeleted: () => {
                                        print(emails),
                                        setState(() {
                                          emails.removeWhere(
                                              (element) => e == element);
                                        })
                                      },
                                    ))
                              ]),
                        ),
                        // Container(
                        //   padding: const EdgeInsets.only(top: 10),
                        //   child: DropdownButtonFormField(
                        //     value: initialtitle,
                        //     isExpanded: true,
                        //     items: titlelist
                        //         .map((item) => DropdownMenuItem<String>(
                        //               value: item,
                        //               child: Text(
                        //                   '${item.characters.take(36)}'),
                        //             ))
                        //         .toList(),
                        //     onChanged: (newValue) async {
                        //       setState(() {
                        //         for (var i = 0; i < myclass.length; i++) {
                        //           if (myclass[i].title ==
                        //               newValue.toString()) {
                        //             initialtitleId = myclass[i].classId;
                        //             print(
                        //                 ">>>>inserted ID >>> $initialtitleId");
                        //           }
                        //         }
                        //         initialtitle = newValue.toString();
                        //       });
                        //     },
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
                        //   ),
                        // ),
                        Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: MaterialButton(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  color: darkmain,
                                  onPressed: emails.isEmpty &&
                                          emailcontroller.text.isEmpty
                                      ? () {
                                          showToast(
                                              'pls add some student emails',
                                              'red');
                                        }
                                      : () async {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          // if (key.currentState!.validate()) {
                                          if (emailcontroller.text.isNotEmpty) {
                                            emails.add(emailcontroller.text);
                                          }
                                          setState(() {
                                            getloading = true;
                                            showerror = false;

                                            emailcontroller.clear();
                                          });
                                          FocusScope.of(context).unfocus();

                                          var resturn = await addstudentapi(
                                              emails,
                                              widget.selectedclass!.classId);

                                          setState(() {
                                            submitted = true;
                                            notexist = resturn["Not_Found"];
                                            notstudeent =
                                                resturn["Not_Student"];
                                            alreadyinclass =
                                                resturn["Already_Exists"];
                                            successfullyadded =
                                                resturn["Success"];
                                          });
                                          var getresult = await getstudentapi(
                                              widget.selectedclass!.classId);
                                          // print('Getdata >>> ${getresult}');
                                          List students = getresult['data'];
                                          studentlist = [];
                                          for (var i = 0;
                                              i < students.length;
                                              i++) {
                                            studentlist.add(studentlistinClass
                                                .fromJson(students[i]));
                                          }
                                          String encodedData =
                                              studentlistinClass
                                                  .encode(studentlist);
                                          await prefs.setString(
                                              'selectedstudentList',
                                              encodedData);
                                          print(
                                              ">>><><number of student>>>>>> ${studentlist.length}");
                                          setState(() {
                                            emails = [];
                                          });
                                          if (notexist == '' &&
                                              notstudeent == '' &&
                                              alreadyinclass == '') {
                                            setState(() {
                                              showerror = false;
                                            });
                                            showToast(
                                                "successfully added", 'green');
                                            Navigator.pop(context);
                                            // ignore: use_build_context_synchronously
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        NavbarScreen(
                                                  screenindex: 2,
                                                ),
                                              ),
                                            );
                                          } else {
                                            setState(() {
                                              showerror = true;
                                            });
                                          }
                                          setState(() {
                                            getloading = false;
                                          });
                                          // }
                                        },
                                  child: getloading
                                      ? const SpinKitWave(
                                          color: Colors.white,
                                          size: 15.0,
                                        )
                                      : Text('Add', style: buttonTextStyle),
                                ))),
                        submitted
                            ? showerror
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // const Padding(
                                      //   padding: EdgeInsets.only(
                                      //       top: 30.0, bottom: 20),
                                      //   child: MySeparator(),
                                      // ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          'Some emails are not valid!',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: ScreenUtil().setSp(14),
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      successfullyadded == ''
                                          ? Container()
                                          : ErrorCard(
                                              leftborder: Colors.green,
                                              bgcolor: const Color.fromARGB(
                                                  255, 207, 235, 220),
                                              leadingicon: ok_circled,
                                              emaillist: successfullyadded,
                                              title: 'Successfully Added'),
                                      notexist == ''
                                          ? Container()
                                          : ErrorCard(
                                              leftborder: Colors.orange,
                                              bgcolor: const Color(0xffFDEEDC),
                                              leadingicon: attention,
                                              emaillist: notexist,
                                              title: "Emails Not Registered"),
                                      notstudeent == ''
                                          ? Container()
                                          : ErrorCard(
                                              leftborder: Colors.red,
                                              bgcolor: const Color(0xffFFCAC8),
                                              leadingicon: help_circled,
                                              emaillist: notstudeent,
                                              title: 'Not Students'),
                                      alreadyinclass == ''
                                          ? Container()
                                          : ErrorCard(
                                              leftborder: Colors.blue,
                                              bgcolor: const Color(0xffDAEAF1),
                                              leadingicon: info_circled,
                                              emaillist: alreadyinclass,
                                              title: 'Already in class'),
                                    ],
                                  )
                                : Container()
                            // : Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       const Icon(
                            //         ok_circled,
                            //         color: Colors.green,
                            //       ),
                            //       Padding(
                            //         padding:
                            //             const EdgeInsets.only(left: 8.0),
                            //         child: Text(
                            //           'Successfully added',
                            //           style: TextStyle(
                            //               color: Colors.green,
                            //               fontSize: ScreenUtil().setSp(14),
                            //               fontWeight: FontWeight.w400),
                            //         ),
                            //       ),
                            //     ],
                            //   )
                            : Container(),
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
