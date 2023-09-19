import 'package:class_on_cloud/model/api.dart';
import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/screens/addfamilyerror.dart';
import 'package:class_on_cloud/screens/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:class_on_cloud/model/model.dart';

class AddFamilymemberScreen extends StatefulWidget {
  const AddFamilymemberScreen({super.key});

  @override
  State<AddFamilymemberScreen> createState() => _AddFamilymemberScreenState();
}

class _AddFamilymemberScreenState extends State<AddFamilymemberScreen> {
  List<studentlistinClass> studentlist = [];
  List<TextEditingController> controllers = [];
  bool ready = false;

  // List<String> emails = [];
  List<List<String>> allemails = [];

  List<studentparentpair> pairlist = [];

  String lastValue = '';
  // late var studentmap;

  bool nofamily = true;
  List<Map<String, dynamic>> editoption = [
    {
      "name": "Edit",
      "menu_id": 1,
    },
    {
      "name": "Remove",
      "menu_id": 2,
    },
  ];
  // FocusNode focus = FocusNode();

  // final emailValidator = MultiValidator([
  //   RequiredValidator(errorText: 'Email is required'),
  //   EmailValidator(errorText: 'enter a valid email address'),
  //   // LYDPhoneValidator(pairlist: pairlist)
  // ]);
  static const _kFontFam = 'Student_error';
  static const String? _kFontPkg = null;

  static const IconData ok_circled =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData info_circled =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var selectedclass =
        classlistmodel.singledecode(prefs.getString('selectedClass'));
    var getparentresult = await getparentapi(email, selectedclass.classId);
    for (var eachpair in getparentresult["data"]) {
      pairlist.add(studentparentpair.fromJson(eachpair));
    }
    // var studentparentlist = studentparentpair.decode(getparentresult["data"]);
    // print('>>>>getparentmodel ${pairlist}');
    var students = prefs.getString("selectedstudentList");
    if (students != null) {
      studentlist = studentlistinClass.decode(students);
      // studentmap = studentlist.asMap();
      controllers =
          List.generate(studentlist.length, (i) => TextEditingController());

      allemails = List.generate(studentlist.length, (i) => []);
      print('>>>>ControllerLength<<<< ${allemails.toString()}');
    }
    setState(() {
      ready = true;
    });
  }

  addemailsfun(List<List<String>> mails) async {
    List<studentparentpair> parentarray = [];
    for (var i = 0; i < mails.length; i++) {
      if (mails[i].isNotEmpty) {
        parentarray.add(studentparentpair(
            studentemail: studentlist[i].studentEmail,
            parentemaillist: mails[i]));
      }
    }
    var result = await addparentArrayapi(parentarray);
    parentarray.clear();
    for (var i = 0; i < allemails.length; i++) {
      setState(() {
        allemails[i].clear();
        controllers[i].clear();
      });
    }
    // print('>>allmailsclean $allemails');
    // print('><<Api result>>< ${result['returncode']}');
    if (result['returncode'] == '408') {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FamilyaddingErrorScreen(
                    result: result['data'],
                  )));
    }
  }

  deleteparentfun(String studentid, String parentemail) async {
    var result = await deleteparentapi(studentid, parentemail);
    print('>Deleres $result');
    if (result['returncode'] == '200') {
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AddFamilymemberScreen()));
    }
  }

  Widget studentdetail(int i, studentlistinClass studentdata) {
    MultiValidator eachValidator = MultiValidator([
      RequiredValidator(errorText: 'Email is required'),
      EmailValidator(errorText: 'enter a valid email address'),
      AlreadyExistValidator(pairlist: pairlist[i])
    ]);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.only(bottom: 8,right: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white ,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: CircleAvatar(
                        backgroundColor: paledarkmain,
                        radius: 22,
                        child: Text(
                          studentdata.username[0].toUpperCase(),
                          style: buttonTextStyle,
                        )),
                  ),
                  Text(
                    studentdata.username,
                    style: labelTextStyle,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.86,
                decoration: BoxDecoration(color: Colors.white),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(pairlist[i].parentemaillist.toString().substring(
                    //     1, pairlist[i].parentemaillist.toString().length - 1)),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          // minHeight: 100,
                          maxHeight: pairlist[i].parentemaillist.isEmpty
                              ? MediaQuery.of(context).size.height * 0.01
                              : pairlist[i].parentemaillist.length > 1
                                  ? pairlist[i].parentemaillist.length > 3
                                      ? MediaQuery.of(context).size.height * 0.2
                                      : MediaQuery.of(context).size.height *
                                          0.12
                                  : MediaQuery.of(context).size.height * 0.05),
                      child: ListView.builder(
                          itemCount: pairlist[i].parentemaillist.length,
                          itemBuilder: (context, index) {
                            return Container(
                              // color: Colors.amber,
                              // padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    trimstring(
                                        pairlist[i].parentemaillist[index]),
                                    style: labelTextStyle,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.done_all_rounded,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 8),
                                      PopupMenuButton(
                                        iconSize: 24.0,
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        icon: const Icon(
                                          Icons.more_vert_rounded,
                                          color: Colors.black,
                                          size: 24.0,
                                        ),
                                        offset: const Offset(0, 10),
                                        itemBuilder: (BuildContext bc) {
                                          return editoption
                                              .map(
                                                (selectedOption) =>
                                                    PopupMenuItem(
                                                  height: 12.0,
                                                  value: selectedOption,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        selectedOption['name'],
                                                        style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(14.0),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      (editoption.length ==
                                                              (editoption.indexOf(
                                                                      selectedOption) +
                                                                  1))
                                                          ? const SizedBox(
                                                              width: 0.0,
                                                              height: 0.0,
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                vertical: 5.0,
                                                              ),
                                                              child: Divider(
                                                                color:
                                                                    Colors.grey,
                                                                height: ScreenUtil()
                                                                    .setHeight(
                                                                        1.0),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .toList();
                                        },
                                        onSelected: (value) async {
                                          print(value);
                                          if (value == editoption[0]) {
                                            print('edit');
                                          } else if (value == editoption[1]) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 15,
                                                          bottom: 10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Remove this parent from student?",
                                                        style: TextStyle(
                                                            color: seccolor,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(14),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color:
                                                                        seccolor,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            14),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )),
                                                          TextButton(
                                                              // 1/9
                                                              onPressed: () {
                                                                deleteparentfun(
                                                                    studentdata
                                                                        .studentId,
                                                                    pairlist[i]
                                                                            .parentemaillist[
                                                                        index]);
                                                                // Navigator.pushReplacementNamed(context, '/login');
                                                              },
                                                              child: Text(
                                                                'Remove',
                                                                style: TextStyle(
                                                                    color:
                                                                        darkmain,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            14),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                      )
                                      // Icon(
                                      //   Icons.info_outline_rounded,
                                      //   color: Colors.blueGrey,
                                      // )
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 8),
                      child: TextFormField(
                        controller: controllers[i],
                        autovalidateMode: controllers[i].text != lastValue
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        validator: eachValidator,
                        textInputAction: TextInputAction.send,
                        // focusNode: focus,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15.0),
                          filled: true,
                          fillColor: backcolor,
                          hintText: 'Add new emails',
                          border: const OutlineInputBorder(
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
                              if (eachValidator
                                  .isValid(controllers[i].text.trim())) {
                                if (!allemails[i].contains(val.trim())) {
                                  allemails[i].add(val.trim());

                                  print(
                                      '>>>>Mails>>  At index $i and $allemails');
                                  controllers[i].clear();
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
                          if (eachValidator
                              .isValid(controllers[i].text.trim())) {
                            setState(() {
                              if (!allemails[i].contains(controllers[i].text)) {
                                allemails[i].add(controllers[i].text.trim());
                                // widget.setList(emails);
                              }
                              controllers[i].clear();
                            });
                            print('>>emaillist ${allemails[i]}');
                          }
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(spacing: 4, children: [
                        ...allemails[i].map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Chip(
                                label: Text(e),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 2,
                                backgroundColor: trandarkmain,
                                labelStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(12),
                                    color: Colors.black),
                                // deleteIcon: Icon(Icons.close_rounded,size: 18,),
                                onDeleted: () => {
                                  setState(() {
                                    allemails[i]
                                        .removeWhere((element) => e == element);
                                  }),
                                  print(allemails[i]),
                                },
                              ),
                            ))
                      ]),
                    ),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    getData();
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
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Add Family Members",
              style: TextStyle(
                color: seccolor,
                fontSize: ScreenUtil().setSp(15),
                fontWeight: FontWeight.w500,
              ))),
      body: ready
          ? SafeArea(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      Column(
                          children: studentlist
                              .asMap()
                              .map((i, eachstud) =>
                                  MapEntry(i, studentdetail(i, eachstud)))
                              .values
                              .toList()),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        color: backcolor,
                      )
                    ],
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
      floatingActionButton: ready
          ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.06,
              child: MaterialButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: darkmain,
                // padding: const EdgeInsets.all(5),
                onPressed: () {
                  addemailsfun(allemails);
                },
                child: Text("+ Invite families", style: buttonTextStyle),
              ),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.06,
            ),
    );
  }
}
