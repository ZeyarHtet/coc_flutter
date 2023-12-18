import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../model/api.dart';
import '../../model/component.dart';
import '../../model/constant.dart';
import '../../model/model.dart';
import '../home.dart';
import 'post.dart';

class EditPost extends StatefulWidget {
  classlistmodel selectedclass;
  String editData;
  EditPost({
    super.key,
    required this.editData,
    required this.selectedclass,
  });

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  List<Eachpost> postlist = [];
  List<TextEditingController> contentcons = [];
  TextEditingController titletextcontroller = TextEditingController();
  TextEditingController codetextcontroller = TextEditingController();
  TextEditingController duedatecontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  int focind = 1;
  bool floatingshow = false;
  bool havetitle = false;
  bool submitted = false;
  bool getloading = false;
  var editData;

  // final ImagePicker _picker = ImagePicker();
  // // List<List<XFile>> galaryimagelist = [];
  // List<XFile> galaryimg = [];
  // Future<void> _selectImage() async {
  //   var pairone = await _picker.pickMultiImage(
  //       // source: ImageSource.z
  //       maxHeight: 100000000000,
  //       imageQuality: 100);
  //   for (var eachphoto in pairone) {
  //     contentcons.add(TextEditingController());
  //     var index = postlist.length;
  //     postlist.add(Eachpost(
  //         id: index,
  //         value: eachphoto,
  //         type: 'photo',
  //         widget: Newimagecontainerwithcaption(
  //           imagepath: eachphoto,
  //           capcontroller: contentcons.last,
  //           deletefun: () {
  //             setState(() {
  //               postlist.removeWhere((element) => element.id == index);
  //             });
  //           },
  //         )));
  //   }
  //   setState(() {});
  // }

  newtextfield() {
    contentcons.add(TextEditingController());
    var index = postlist.length;
    postlist.add(
      Eachpost(
        id: index,
        value: contentcons.last.text,
        type: 'text',
        widget: Customtextfield(
          controller: contentcons.last,
          hinttext: 'New TextField Here',
          deletefun: () {
            setState(() {
              postlist.removeWhere((element) => element.id == index);
            });
          },
        ),
      ),
    );

    setState(() {});
  }

  initData() {
    print(">>>>>> editdata");
    editData = jsonDecode(widget.editData);
    print(">>>>>>>>>>>> edit data $editData");

    setState(() {
      if (editData != null) {
        titletextcontroller.text = editData["title"] ?? '';
        duedatecontroller.text = editData["due_date"] ?? '';
      }
    });
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: backcolor,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: backcolor,
          leading: IconButton(
              icon: Icon(Icons.close, color: darkmain),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text("Update Posts", style: appbarTextStyle(darkmain)),
          actions: [
            GestureDetector(
              onTap: () async {
                setState(() {
                  submitted = true;
                });
                // if (key.currentState!.validate()) {
                print(">>>>>>>>");
                setState(() {
                  getloading = true;
                });
                var returnCode = await editclasspostapi(
                    editData["post_id"].toString(),
                    titletextcontroller.text,
                    duedatecontroller.text);
                print('><><ret><> $returnCode');
                if (returnCode == '200') {
                  print("<<<<<<<x<<<<<<<<object1>>>>>>>>>>>>>>>");
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PostScreen()),
                  );
                  titletextcontroller.clear();
                  duedatecontroller.clear;

                  print("<<<<<<<<<<<<<<<object>>>>>>>>>>>>>>>");
                }
                setState(() {
                  getloading = false;
                  submitted = false;
                });
                print('>>>>>><<<<<<>>>>>>>');
                // }
              },
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 6, 5, 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: havetitle ? paledarkmain : Colors.grey[300]),
                    child: Center(
                      child: Text(
                        'Update',
                        style: TextStyle(
                            color: havetitle ? Colors.white : Colors.black,
                            fontSize: ScreenUtil().setSp(13),
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: TextFormField(
                      controller: titletextcontroller,
                      maxLines: 4,
                      minLines: 1,
                      validator: RequiredValidator(
                          errorText: 'Title is required to post'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 8),
                        filled: true,
                        fillColor: backcolor,
                        hintText: "Title",
                        hintStyle: labelTextStyle,
                        border: const OutlineInputBorder(
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
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          'Due Date',
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
                      controller: duedatecontroller,
                      autofocus: false,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: submitted
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      validator: RequiredValidator(
                          errorText: "Due Date cannot be blank !"),
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

                  // SizedBox(
                  //   height: 10,
                  // ),
                  // galaryimg.isEmpty
                  //     ? Container()
                  //     : Imagecontainer(galaryimage: galaryimg),
                  // Column(mainAxisSize: MainAxisSize.min, children: [
                  ...postlist.map((e) {
                    return e.widget;
                  }),
                  // ]),
                ],
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: floatingshow
                    ? MediaQuery.of(context).size.width * 0.7
                    : MediaQuery.of(context).size.width * 0.13,
                height: MediaQuery.of(context).size.height * 0.07,
                curve: Curves.ease,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15)),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await newtextfield();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: seccolor,
                                  child: const Icon(
                                    Icons.code_rounded,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: seccolor,
                                child: const Icon(
                                  Icons.insert_drive_file_outlined,
                                  size: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: seccolor,
                                child: const Icon(
                                  Icons.video_library_outlined,
                                  size: 18,
                                ),
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () async {
                            //     await _selectImage();
                            //   },
                            //   child: Padding(
                            //       padding: const EdgeInsets.only(left: 8.0),
                            //       child: CircleAvatar(
                            //         radius: 20,
                            //         backgroundColor: seccolor,
                            //         child: const Icon(
                            //           Icons.photo_library_outlined,
                            //           size: 18,
                            //         ),
                            //       )),
                            // )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              floatingshow = !floatingshow;
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  floatingshow ? seccolor : darkmain,
                              child: Icon(
                                floatingshow
                                    ? Icons.arrow_back_ios
                                    : Icons.add_photo_alternate_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
        duedatecontroller.text = DateFormat('yyyy-MM-dd').format(picked!);
      });
    }
  }
}
