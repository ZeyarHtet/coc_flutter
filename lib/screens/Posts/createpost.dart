import 'dart:io';

import 'package:class_on_cloud/model/api.dart';
import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:class_on_cloud/screens/Posts/getpost.dart';
import 'package:class_on_cloud/screens/home.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PostingScreen extends StatefulWidget {
  classlistmodel selectedclass;
  PostingScreen({super.key, required this.selectedclass});

  @override
  State<PostingScreen> createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  // List<Map<String, dynamic>> postlist = [];
  // List<FocusNode> nodes = [FocusNode()];
  List<Eachpost> postlist = [];
  List<TextEditingController> contentcons = [];
  TextEditingController titletextcontroller = TextEditingController();
  TextEditingController codetextcontroller = TextEditingController();
  TextEditingController duedatecontroller = TextEditingController();
  List<TextEditingController> captiontextcontroller = [];
  List files = [];

  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  int focind = 1;
  bool floatingshow = false;
  bool havetitle = false;
  bool submitted = false;
  bool getloading = false;
  bool isassignment = false;

  final ImagePicker _picker = ImagePicker();
  // List<List<XFile>> galaryimagelist = [];
  List<File> galaryimg = [];
  Future<void> _selectImage() async {
    var pairone = await _picker.pickMultiImage(
        // source: ImageSource.z
        maxHeight: 100000000000,
        imageQuality: 100);
    for (var eachphoto in pairone) {
      captiontextcontroller.add(TextEditingController());
      var index = postlist.length;
      postlist.add(
        Eachpost(
          id: index,
          value: eachphoto,
          type: 'photo',
          widget: Newimagecontainerwithcaption(
            imagepath: eachphoto,
            capcontroller: captiontextcontroller.last,
            deletefun: () {
              setState(() {
                postlist.removeWhere((element) => element.id == index);
              });
            },
          ),
        ),
      );
    }

    setState(() {});
  }

  void uploadPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true, type: FileType.custom, allowedExtensions: ['pdf']);
    print(">>>>>>>>>> result $result");
    XFile file = XFile(result!.files.single.path ?? "");
    print(file.name);
    captiontextcontroller.add(TextEditingController());
    var index = postlist.length;
    postlist.add(
      Eachpost(
        id: index,
        value: file,
        type: 'file',
        widget: Newfilecontainerwithcaption(
          filepath: file,
          capcontroller: captiontextcontroller.last,
          deletefun: () {
            setState(() {
              postlist.removeWhere((element) => element.id == index);
            });
          },
        ),
        // widget: Container(
        //   child: Row(
        //     children: [
        //       Container(
        //         width: 25,
        //         height: 25,
        //         margin: const EdgeInsets.all(5),
        //         child: const Image(
        //           image: AssetImage('images/pdf.png'),
        //           color: Colors.black,
        //         ),
        //       ),
        //       Expanded(
        //         child: Container(
        //           child: const Text('Hello PDF'),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        //  Newfilecontainerwithcaption(
        //   filepath: file,
        //   capcontroller: captiontextcontroller.last,
        //   deletefun: () {
        //     setState(() {
        //       postlist.removeWhere((element) => element.id == index);
        //     });
        //   },
        // ),
      ),
    );
  }

  // Future<void> newcontroller() async {
  //   var pairone = await Row(
  //     children: [
  //       await Padding(
  //         padding: const EdgeInsets.only(left: 15),
  //         child: Text(
  //           'Text Field',
  //           style: labelTextStyle,
  //         ),
  //       ),
  //     ],
  //   );
  //   Container(
  //     padding: const EdgeInsets.only(right: 15, bottom: 10, left: 15, top: 10),
  //     child: TextFormField(
  //       controller: codetext,
  //       autofocus: false,
  //       autocorrect: false,
  //       textCapitalization: TextCapitalization.words,
  //       autovalidateMode:
  //           submitted ? AutovalidateMode.always : AutovalidateMode.disabled,
  //       validator: RequiredValidator(errorText: "Text field cannot be blank !"),
  //       decoration: const InputDecoration(
  //         contentPadding: EdgeInsets.all(15.0),
  //         filled: true,
  //         fillColor: Colors.white,
  //         // hintText: 'Enter your email address',
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.all(
  //             Radius.circular(10.0),
  //           ),
  //           borderSide: BorderSide.none,
  //         ),
  //       ),
  //       style: labelTextStyle,
  //       cursorColor: seccolor,
  //     ),
  //   );
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

  postBlog(List<Eachpost> finallist) async {
    List<Map<String, dynamic>> valuelist = [];
    int sortkey = 0;
    int x = 0;
    int y = 0;
    for (var i = 0; i < finallist.length; i++) {
      if (finallist[i].type == 'text') {
        if (contentcons[x].text.isNotEmpty) {
          sortkey = sortkey + 1;
          valuelist.add({
            "type": 1,
            "content": contentcons[x].text.trim(),
            "sort_key": sortkey
          });
          x++;
        }
      } else if (finallist[i].type == 'photo') {
        sortkey = sortkey + 1;
        File imagepath = finallist[i].value;
        files.add(imagepath);
        valuelist.add({
          "type": 2,
          "caption": captiontextcontroller[y].text.trim(),
          "sort_key": sortkey
        });
        y++;
      } else if (finallist[i].type == 'video') {
        sortkey = sortkey + 1;
        valuelist.add({
          "type": 3,
          "videourl": finallist[i].value,
          "caption": captiontextcontroller[y].text,
          "sort_key": sortkey
        });
        y++;
      } else if (finallist[i].type == 'file') {
        sortkey = sortkey + 1;
        XFile filepath = finallist[i].value;
        files.add(filepath);
        valuelist.add({
          "type": 4,
          "caption": captiontextcontroller[y].text,
          "sort_key": sortkey
        });
        y++;
      }
    }

    print('All value are   >>>>>> $valuelist');
    print('sortnumber   >>>>>> $sortkey');
    if (valuelist.isNotEmpty) {
      Map<String, dynamic> valuestosent = {
        "email": email,
        "class_id": widget.selectedclass.classId,
        "title": titletextcontroller.text.trim(),
        "type": isassignment ? 2 : 1,
        "due_date": isassignment ? duedatecontroller.text.trim() : Null,
        "post_details": valuelist
      };
      print('Our api result is >>>>>>> # post');
      print(valuestosent);
      print(files);
      var result = await createPostApi(valuestosent, files);
      print('Our api result is >>>>>>> # $result');
      if (result['returnCode'] == '200') {
        for (var eachcont in contentcons) {
          eachcont.clear();
        }
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const GetPostScreen(
                // screenindex: 0,
                ),
          ),
        );
        setState(() {
          getloading = false;
          submitted = false;
        });
      } else {
        showToast(result['returnCode'], 'red');
      }
    } else {
      showToast("You need some content to post", 'red');
    }
  }

  // setData() {
  //   postlist.add(Eachpost(
  //       id: 0,
  //       value: contentcons[0].text,
  //       type: 'text',
  //       widget: Customtextfield(
  //         controller: contentcons[1],
  //         hinttext: 'Context',
  //       )));
  //   setState(() {});
  // }

  @override
  void initState() {
    titletextcontroller.addListener(() {
      setState(() {
        titletextcontroller.text.isNotEmpty
            ? havetitle = true
            : havetitle = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    for (var eachcont in contentcons) {
      eachcont.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
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
            title: Text("Create Post", style: appbarTextStyle(darkmain)),
            actions: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    submitted = true;
                    getloading = true;
                  });
                  postBlog(postlist);
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
                          'Post',
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
                // Image.network(
                //     "http://127.0.0.1:9000/coc/post_images/scaled_IMG_20231012_135913_1697095777499.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=2BEO08X6RLFIGUB1QF10%2F20231012%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20231012T080948Z&X-Amz-Expires=604800&X-Amz-Security-Token=eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhY2Nlc3NLZXkiOiIyQkVPMDhYNlJMRklHVUIxUUYxMCIsImV4cCI6MTY5NzEzOTE0OSwicGFyZW50IjoibWluaW9hZG1pbiJ9.htWEAko758wYTIGpoljdhpVtNnGKPvAM3WjmF6RDfzj-nQq5uRHWSO_jUU65kv9ofUU_9t53nSggZ-ePN7VpHA&X-Amz-SignedHeaders=host&versionId=null&X-Amz-Signature=1719e4a6443cb9d75099adb1ea84d97fae5b27328cf3961f26b974bdc61e7e43"),
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
                        SizedBox(width: 10),
                        Text(
                          "Assignment: ",
                          style: labelTextStyle,
                        ),
                        Switch(
                          value: isassignment,
                          onChanged: (value) {
                            setState(() {
                              isassignment = value;
                            });
                          },
                          activeTrackColor: Colors.lightGreenAccent,
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                    isassignment
                        ? Column(
                            children: [
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
                                  readOnly: true,
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
                            ],
                          )
                        : const SizedBox(
                            height: 10,
                          ),
                    ...postlist.map((e) {
                      return e.widget;
                    }),
                    // ]),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButton: AnimatedContainer(
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
                          onTap: () {
                            newtextfield();
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
                        GestureDetector(
                          onTap: () {
                            uploadPDF();
                          },
                          child: Padding(
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
                        GestureDetector(
                          onTap: () async {
                            await _selectImage();
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: seccolor,
                                child: const Icon(
                                  Icons.photo_library_outlined,
                                  size: 18,
                                ),
                              )),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          floatingshow = !floatingshow;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: floatingshow ? seccolor : darkmain,
                          child: Icon(
                            floatingshow
                                ? Icons.arrow_forward_ios
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
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
        duedatecontroller.text = DateFormat('yyyy-MM-dd').format(picked!);
      });
    }
  }
}
