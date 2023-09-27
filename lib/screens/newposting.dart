import 'package:class_on_cloud/model/api.dart';
import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:class_on_cloud/screens/createpost.dart';
import 'package:class_on_cloud/screens/getpost.dart';
import 'package:class_on_cloud/screens/home.dart';
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

  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  int focind = 1;
  bool floatingshow = false;
  bool havetitle = false;
  bool submitted = false;
  bool getloading = false;

  final ImagePicker _picker = ImagePicker();
  // List<List<XFile>> galaryimagelist = [];
  List<XFile> galaryimg = [];
  Future<void> _selectImage() async {
    var pairone = await _picker.pickMultiImage(
        // source: ImageSource.z
        maxHeight: 100000000000,
        imageQuality: 100);
    for (var eachphoto in pairone) {
      contentcons.add(TextEditingController());
      var index = postlist.length;
      postlist.add(Eachpost(
          id: index,
          value: eachphoto,
          type: 'photo',
          widget: Newimagecontainerwithcaption(
            imagepath: eachphoto,
            capcontroller: contentcons.last,
            deletefun: () {
              setState(() {
                postlist.removeWhere((element) => element.id == index);
              });
            },
          )));
    }
    // if (postlist.last.type == 'pic') {
    //   for (var element in pairone) {
    //     galaryimg.add(element);
    //   }
    //   postlist.last.widget = Imagecontainer(galaryimage: galaryimg);
    //   setState(() {});
    // } else {
    //   List<String> imgvalue = [];
    //   for (var element in pairone) {
    //     imgvalue.add(element.name);
    //   }
    //   postlist.add(Eachpost(
    //       value: imgvalue,
    //       type: 'pic',
    //       widget: Imagecontainer(
    //         galaryimage: pairone,
    //       )));
    //   // galaryimg = [];
    //   setState(() {});
    // }
    setState(() {});
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
    for (var i = 0; i < finallist.length; i++) {
      if (finallist[i].type == 'text') {
        if (contentcons[i].text.isNotEmpty) {
          sortkey = sortkey + 1;
          valuelist.add({
            "type": 1,
            "content": contentcons[i].text.trim(),
            "sort_key": sortkey
          });
        }
      } else if (finallist[i].type == 'photo') {
        print('caption >>>>>> ${contentcons[i].text}');
        if (contentcons[i].text.isNotEmpty) {
          sortkey = sortkey + 1;
          valuelist.add(
              {"type": 1, "content": contentcons[i].text, "sort_key": sortkey});
        }
        var imageresult = await uploadimageapi(finallist[i].value);
        if (imageresult['message'] == 'success') {
          sortkey = sortkey + 1;
          valuelist.add(
              {"type": 2, "content": imageresult['url'], "sort_key": sortkey});
        } else {
          showToast('Image Uploading error', 'red');
          return null;
        }
      }
      // else {
      //   sortkey = sortkey + 1;
      //   valuelist
      //       .add({"type": 3, "content": finallist[i].value, "sort_key": i});
      // }
    }

    print('All value are   >>>>>> $valuelist');
    print('sortnumber   >>>>>> $sortkey');
    if (valuelist.isNotEmpty) {
      Map<String, dynamic> valuestosent = {
        "email": email,
        "class_id": widget.selectedclass.classId,
        "title": titletextcontroller.text.trim(),
        "type": 1,
        "post_details": valuelist
      };
      var resul = await createPostApi(valuestosent);
      print('Our api result is >>>>>>> # $resul');
      if (resul['returnCode'] == '200') {
        for (var eachcont in contentcons) {
          eachcont.clear();
        }
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => NavbarScreen(
              screenindex: 0,
            ),
          ),
        );
      } else {
        showToast(resul['returnCode'], 'red');
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
    // setData();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    for (var eachcont in contentcons) {
      eachcont.dispose();
    }
    // TODO: implement dispose
    super.dispose();
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
          title: Text("Create Posts", style: appbarTextStyle(darkmain)),
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
                var returncode = await createpostapi(
                    widget.selectedclass.classId,
                    titletextcontroller.text,
                    [],
                    duedatecontroller.text);
                print('><><ret><> $returncode');
                if (returncode == '200') {
                  print("<<<<<<<x<<<<<<<<object1>>>>>>>>>>>>>>>");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GetPostScreen()),
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

        // floatingActionButton: AnimatedContainer(
        //   duration: const Duration(milliseconds: 300),
        //   width: floatingshow
        //       ? MediaQuery.of(context).size.width * 0.8
        //       : MediaQuery.of(context).size.width * 0.14,
        //   height: MediaQuery.of(context).size.width * 0.14,
        //   decoration: BoxDecoration(
        //       color: paledarkmain, borderRadius: BorderRadius.circular(15)),
        //   child: SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     child: Row(
        //       children: [
        //       floatingshow
        //           ? Row(
        //               children: [
        //                 CircleAvatar(
        //                     radius: 20,
        //                     backgroundColor: backcolor,
        //                     child: const Icon(
        //                       Icons.code_rounded,
        //                       size: 18,
        //                     )),
        //                 const SizedBox(
        //                   width: 7,
        //                 ),
        //                 CircleAvatar(
        //                     radius: 20,
        //                     backgroundColor: backcolor,
        //                     child: const Icon(
        //                       Icons.insert_drive_file_outlined,
        //                       size: 18,
        //                     )),
        //                 const SizedBox(
        //                   width: 7,
        //                 ),
        //                 CircleAvatar(
        //                     radius: 20,
        //                     backgroundColor: backcolor,
        //                     child: const Icon(
        //                       Icons.video_library_outlined,
        //                       size: 18,
        //                     )),
        //                 const SizedBox(
        //                   width: 7,
        //                 ),
        //                 GestureDetector(
        //                    onTap: () async {
        //                     print("Zawnayla");
        //                     // var place = postlist.indexWhere(
        //                     //     (element) => element['id'] == widgetId);
        //                     // if (galaryimage.isNotEmpty) {
        //                     //   // getimagewid(galaryimage!);
        //                     //   contentlist.add(getimagewid(galaryimage));
        //                     setState(() {});
        //                     // }
        //                   },
        //                   child: CircleAvatar(
        //                       radius: 20,
        //                       backgroundColor: backcolor,
        //                       child: const Icon(
        //                         Icons.photo_library_outlined,
        //                         size: 18,
        //                       )),
        //                 ),
        //                 const SizedBox(
        //                   width: 7,
        //                 ),
        //                 CircleAvatar(
        //                     radius: 20,
        //                     backgroundColor: backcolor,
        //                     child: const Icon(
        //                       Icons.camera_alt_outlined,
        //                       size: 18,
        //                     )),
        //                 const SizedBox(
        //                   width: 7,
        //                 ),
        //               ],
        //             )
        //           : Container(),
        //       GestureDetector(
        //           onTap: () {
        //             print('mawindkd');
        //             setState(() {
        //               floatingshow = !floatingshow;
        //             });
        //           },
        //           child: Icon(
        //               floatingshow
        //                   ? Icons.arrow_forward_ios_rounded
        //                   : Icons.add,
        //               color: Colors.white,
        //               size: 20)),
        //     ]),
        //   ),
        // ),
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
