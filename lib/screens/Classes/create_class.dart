import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/api.dart';
import '../../model/constant.dart';
import 'class.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({super.key});

  @override
  State<CreateClass> createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  TextEditingController classnamecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  // TextEditingController schoolcontroller = TextEditingController();
  TextEditingController customgradecontroller = TextEditingController();
  // final GlobalKey<FormState> key = GlobalKey<FormState>();

  bool getloading = false;
  bool submitted = false;
  bool show = false;
  bool ready = false;
  late var result;
  String coverPic = "";
  bool schoolshow = false;

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
        title: Text("Create Class", style: appbarTextStyle(maincolor)),
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
                          'Class Name',
                          style: labelTextStyle,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        right: 15, bottom: 10, left: 15, top: 10),
                    child: TextFormField(
                      controller: classnamecontroller,
                      autofocus: false,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: submitted
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      validator: RequiredValidator(
                          errorText: "Class name cannot be blank !"),
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
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          'Description',
                          style: labelTextStyle,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        right: 15, bottom: 10, left: 15, top: 10),
                    child: TextFormField(
                      maxLines: 3,
                      controller: descriptioncontroller,
                      autofocus: false,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: submitted
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      validator: RequiredValidator(
                          errorText: "Description cannot be blank !"),
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
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectImage();
                      setState(() {});
                    },
                    child:
                        // coverPic != ""
                        //     ? Container(
                        //         width: 100,
                        //         height: 100,
                        //         child: CachedNetworkImage(
                        //           imageBuilder: (context, imageProvider) =>
                        //               Container(
                        //             decoration: BoxDecoration(
                        //               border: Border.all(color: Colors.grey),
                        //               shape: BoxShape.circle,
                        //               image: DecorationImage(
                        //                   image: imageProvider,
                        //                   fit: BoxFit.cover,
                        //                   colorFilter: ColorFilter.mode(
                        //                       trandarkmain, BlendMode.colorBurn)),
                        //             ),
                        //           ),
                        //           imageUrl: coverPic,
                        //           placeholder: (context, url) =>
                        //               const SpinKitFadingCube(
                        //             size: 5,
                        //             color: Colors.grey,
                        //           ),
                        //           errorWidget: (context, url, error) =>
                        //               const Icon(Icons.error),
                        //         ),
                        //       )
                        //     :
                        Center(
                      child: _imageList == null
                          ? const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Select Image",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : Image(
                              width: 100,
                              height: 150,
                              image: FileImage(File(_imageList![0].path)),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Row(
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 15),
                  //       child: Text(
                  //         'Choose Your School',
                  //         style: labelTextStyle,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Stack(children: [
                  //   Column(
                  //     children: [
                  //       Container(
                  //         padding: const EdgeInsets.only(
                  //             right: 15, bottom: 10, left: 15, top: 10),
                  //         child: TextFormField(
                  //           controller: schoolcontroller,
                  //           autofocus: false,
                  //           autocorrect: false,
                  //           textCapitalization: TextCapitalization.words,
                  //           autovalidateMode: submitted
                  //               ? AutovalidateMode.always
                  //               : AutovalidateMode.disabled,
                  //           validator: RequiredValidator(
                  //               errorText: "Class name cannot be blank !"),
                  //           decoration: InputDecoration(
                  //               contentPadding: const EdgeInsets.all(15.0),
                  //               filled: true,
                  //               fillColor: Colors.white,
                  //               // hintText: 'Enter your email address',
                  //               border: const OutlineInputBorder(
                  //                 borderRadius: BorderRadius.all(
                  //                   Radius.circular(10.0),
                  //                 ),
                  //                 borderSide: BorderSide.none,
                  //               ),
                  //               suffixIcon: GestureDetector(
                  //                   onTap: () {
                  //                     setState(() {
                  //                       schoolshow = !schoolshow;
                  //                       print('>>>>> $schoolshow');
                  //                     });
                  //                   },
                  //                   child: Icon(
                  //                     Icons.arrow_drop_down,
                  //                     color: seccolor,
                  //                     size: 30,
                  //                   ))),
                  //           style: labelTextStyle,
                  //           cursorColor: seccolor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  //   schoolshow
                  //       ? Container(
                  //           height: 130,
                  //           width: MediaQuery.of(context).size.width - 20,
                  //           decoration: const BoxDecoration(
                  //               color: Colors.white,
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(10))),
                  //           child: ListView.builder(
                  //             itemCount: schoollist.length,
                  //             itemBuilder: (context, index) {
                  //               return Column(
                  //                 children: [
                  //                   GestureDetector(
                  //                     onTap: () {
                  //                       schoolcontroller.text =
                  //                           schoollist[index].toString();
                  //                       setState(() {
                  //                         schoolshow = false;
                  //                       });
                  //                     },
                  //                     child: ListTile(
                  //                       title: Text(schoollist[index]),
                  //                     ),
                  //                   ),
                  //                   index != 11
                  //                       ? Padding(
                  //                           padding: const EdgeInsets.symmetric(
                  //                               horizontal: 8.0),
                  //                           child: Divider(
                  //                             color: darkmain,
                  //                           ),
                  //                         )
                  //                       : Container()
                  //                 ],
                  //               );
                  //             },
                  //           ),
                  //         )
                  //       : Container()
                  // ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          'Choose Your Grade',
                          style: labelTextStyle,
                        ),
                      ),
                    ],
                  ),
                  Stack(children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              right: 15, bottom: 10, left: 15, top: 10),
                          child: TextFormField(
                            controller: customgradecontroller,
                            autofocus: false,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.words,
                            autovalidateMode: submitted
                                ? AutovalidateMode.always
                                : AutovalidateMode.disabled,
                            validator: RequiredValidator(
                                errorText: "Class name cannot be blank !"),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(15.0),
                                filled: true,
                                fillColor: Colors.white,
                                // hintText: 'Enter your email address',
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        show = !show;
                                        print('>>>>>> $show');
                                      });
                                    },
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: seccolor,
                                      size: 30,
                                    ))),
                            style: labelTextStyle,
                            cursorColor: seccolor,
                          ),
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
                                  var returncode = await createclassapi(
                                    classnamecontroller.text,
                                    descriptioncontroller.text,
                                    customgradecontroller.text,
                                  );
                                  print('><><ret><> $returncode');
                                  if (returncode == '200') {
                                    // ignore: use_build_context_synchronously
                                    // Navigator.pop(context);
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ClassesScreen()),
                                    );
                                    classnamecontroller.clear();
                                    descriptioncontroller.clear();
                                    customgradecontroller.clear();
                                    // schoolcontroller.clear();
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
                                        'Create Class',
                                        style: TextStyle(
                                            color: maincolor,
                                            fontSize: ScreenUtil().setSp(20),
                                            fontWeight: FontWeight.w500),
                                      ),
                              )),
                        ),
                      ],
                    ),
                    show
                        ? Container(
                            height: 130,
                            width: MediaQuery.of(context).size.width - 20,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: ListView.builder(
                              itemCount: dropdownlist.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        customgradecontroller.text =
                                            dropdownlist[index].toString();
                                        setState(() {
                                          show = false;
                                        });
                                      },
                                      child: ListTile(
                                        title: Text(dropdownlist[index]),
                                      ),
                                    ),
                                    index != 11
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Divider(
                                              color: darkmain,
                                            ),
                                          )
                                        : Container()
                                  ],
                                );
                              },
                            ),
                          )
                        : Container()
                  ]),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
