import 'package:class_on_cloud/screens/School/school.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import '../../model/api.dart';
import '../../model/constant.dart';

class CreateSchool extends StatefulWidget {
  const CreateSchool({super.key});

  @override
  State<CreateSchool> createState() => _CreateSchoolState();
}

class _CreateSchoolState extends State<CreateSchool> {
  DateTime? picked;
  // bool isLoading = false;
  final TextEditingController _schoolemailController = TextEditingController();
  final TextEditingController _schoolnameController = TextEditingController();
  // final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _start_dateController = TextEditingController();
  final TextEditingController _end_dateController = TextEditingController();
  final TextEditingController _perioddateController = TextEditingController();
  bool getloading = false;
  bool submitted = false;

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
        title: Text("Create School", style: appbarTextStyle(maincolor)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Form(
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
                    // Row(
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 15),
                    //       child: Text(
                    //         'Description',
                    //         style: labelTextStyle,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.only(
                    //       right: 15, bottom: 10, left: 15, top: 10),
                    //   child: TextFormField(
                    //     maxLines: 3,
                    //     keyboardType: TextInputType.multiline,

                    //     controller: _descriptionController,
                    //     autofocus: false,
                    //     autocorrect: false,
                    //     textCapitalization: TextCapitalization.words,
                    //     autovalidateMode: submitted
                    //         ? AutovalidateMode.always
                    //         : AutovalidateMode.disabled,
                    //     validator: RequiredValidator(
                    //         errorText: "Class name cannot be blank !"),
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
                    //     // style: labelTextStyle,
                    //     // cursorColor: seccolor,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
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
                            errorText: "Period Date name cannot be blank !"),
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
                            print(">>>>>>>>");
                            setState(() {
                              getloading = true;
                            });
                            var returncode = await createschoolapi(
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
                                  'Create',
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
            ),
          ],
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
