import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/screens/School/school.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/api.dart';
import '../../model/component.dart';
import '../../model/model.dart';
import '../imagepreview.dart';
import '../teacherprofile.dart';
// import 'class.dart';

class EditSchool extends StatefulWidget {
  String editData;
  EditSchool({
    super.key,
    required this.editData,
  });

  @override
  State<EditSchool> createState() => _EditSchoolState();
}

class _EditSchoolState extends State<EditSchool> {
  DateTime? picked;

  final TextEditingController _schoolemailController = TextEditingController();
  final TextEditingController _schoolnameController = TextEditingController();
  final TextEditingController _start_dateController = TextEditingController();
  final TextEditingController _end_dateController = TextEditingController();
  final TextEditingController _perioddateController = TextEditingController();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  // List<classlistmod> myclass = [];
  classlistmodel? selectedclass;

  bool show = false;
  bool schoolshow = false;
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
  List<String> schoollist = [
    'Eaindar yat',
    'D Nursery Private High School',
  ];
  String url = '';
  bool getloading = false;
  bool submitted = false;
  var editData;
  String coverPic = "";

  initData() {
    print(">>>>>> editdata");
    editData = jsonDecode(widget.editData);
    print(">>>>>>>>>>>> edit data $editData");

    setState(() {
      if (editData != null) {
        _schoolemailController.text = editData["admin_email"] ?? '';
        _schoolnameController.text = editData["school_name"] ?? '';
        _start_dateController.text = editData["start_date"] ?? '';
        _end_dateController.text = editData["end_date"] ?? '';
        _perioddateController.text = editData["subscription_period"] ?? '';

        // schoolId: schoollist[i]['school_id'] ?? "",
        //     schoolName: schoollist[i]['school_name'] ?? "",
        //     adminEmail: schoollist[i]['admin_email'] ?? "",
        //     description: schoollist[i]['description'] ?? "",
        //     schoolProfilePic: schoollist[i]['school_profile_pic'] ?? "",
        //     startDate: schoollist[i]['start_date'] ?? "",
        //     endDate: schoollist[i]["end_date"] ?? "",
        //     subscriptionPeriod: schoollist[i]['subscription'] ?? "",
      }
    });
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  List<XFile>? _imageList;
  final ImagePicker _picker = ImagePicker();
  XFile? chooseFile;
  Future<void> _selectImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 100,
      maxHeight: 100,
      imageQuality: 100,
    );
    setState(() {
      chooseFile = pickedFile;
      _imageList = pickedFile == null ? null : <XFile>[pickedFile];
      coverPic = "";
      print(">>>>>>>>>>>>>>>> image path>>>>>> ${_imageList![0].path}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: backcolor,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: darkmain,
          iconTheme: IconThemeData(
            color: maincolor,
            size: 30,
          ),
          title: Text("Update School", style: appbarTextStyle(maincolor)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.width - 1,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            'School Email',
                            style: labelTextStyle,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          right: 15, bottom: 10, left: 15, top: 10),
                      child: TextFormField(
                        controller: _schoolemailController,
                        autofocus: false,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.words,
                        autovalidateMode: submitted
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        validator: RequiredValidator(
                            errorText: "School Email cannot be blank !"),
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
                        // style: labelTextStyle,
                        // cursorColor: seccolor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            'School Name',
                            style: labelTextStyle,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          right: 15, bottom: 10, left: 15, top: 10),
                      child: TextFormField(
                        controller: _schoolnameController,
                        autofocus: false,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.words,
                        autovalidateMode: submitted
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        validator: RequiredValidator(
                            errorText: "School name cannot be blank !"),
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
                        // style: labelTextStyle,
                        // cursorColor: seccolor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            'Start Date',
                            style: labelTextStyle,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          right: 15, bottom: 10, left: 15, top: 10),
                      child: TextFormField(
                        onTap: () {
                          setState(() {
                            _pickDateDialog();
                          });
                        },
                        controller: _start_dateController,
                        autofocus: false,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.words,
                        autovalidateMode: submitted
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        validator: RequiredValidator(
                            errorText: "Start Date cannot be blank !"),
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
                        // style: labelTextStyle,
                        // cursorColor: seccolor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            'End Date',
                            style: labelTextStyle,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          right: 15, bottom: 10, left: 15, top: 10),
                      child: TextFormField(
                        onTap: () {
                          setState(() {
                            _pickDate();
                          });
                        },
                        controller: _end_dateController,
                        autofocus: false,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.words,
                        autovalidateMode: submitted
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        validator: RequiredValidator(
                            errorText: "End Date cannot be blank !"),
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
                        // style: labelTextStyle,
                        // cursorColor: seccolor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            'Period Date',
                            style: labelTextStyle,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          right: 15, bottom: 10, left: 15, top: 10),
                      child: TextFormField(
                        onTap: () {
                          setState(() {
                            _pickdate();
                          });
                        },
                        controller: _perioddateController,
                        autofocus: false,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.words,
                        autovalidateMode: submitted
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        validator: RequiredValidator(
                            errorText: "Period Date cannot be blank !"),
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
                        // style: labelTextStyle,
                        // cursorColor: seccolor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 30,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: MaterialButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          color: darkmain,
                          onPressed: () async {
                            setState(() {
                              submitted = true;
                            });
                            // if (key.currentState!.validate()) {
                            print(">>>>> $editData");
                            print(">>>>>>>> id ${editData["school_id"]}");
                            setState(() {
                              getloading = true;
                            });
                            var returncode = await editschoolapi(
                              editData["school_id"].toString(),
                              _schoolemailController.text,
                              _schoolnameController.text,
                              _start_dateController.text,
                              _end_dateController.text,
                              _perioddateController.text,
                            );
                            print('><><ret><> $returncode');
                            if (returncode == '200') {
                              // ignore: use_build_context_synchronously
                              // Navigator.pop(context);
                              // ignore: use_build_context_synchronously
                              print("<<<<<<<<<<<<<<<object1>>>>>>>>>>>>>>>");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SchoolScreen()),
                              );
                              _schoolemailController.clear();
                              _schoolnameController.clear();
                              _start_dateController.clear();
                              _end_dateController.clear();
                              _perioddateController.clear();
                              print("<<<<<<<<<<<<<<<object>>>>>>>>>>>>>>>");
                            }
                            setState(() {
                              getloading = false;
                              submitted = false;
                            });
                            print('>>>>>><<<<<<>>>>>>>');
                            // }
                          },
                          child: getloading
                              ? const SpinKitDoubleBounce(
                                  color: Colors.white,
                                  size: 15.0,
                                )
                              : Text(
                                  'Update',
                                  style: TextStyle(
                                      color: maincolor,
                                      fontSize: ScreenUtil().setSp(20),
                                      fontWeight: FontWeight.w500),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        // _start_dateController.text = '${picked!.year} - ${picked!.month} ${picked!.day}';
        _start_dateController.text = DateFormat('yyyy-MM-dd').format(picked!);
      });
    }
  }

  void _pickDate() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _end_dateController.text = DateFormat('yyyy-MM-dd').format(picked!);
      });
    }
  }

  void _pickdate() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _perioddateController.text = DateFormat('yyyy-MM-dd').format(picked!);
      });
    }
  }
}
