import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

import '../model/component.dart';
import '../model/constant.dart';
import '../model/model.dart';
import 'Classes/create_class.dart';

class ClassPostingScreen extends StatefulWidget {
  const ClassPostingScreen({super.key});

  @override
  State<ClassPostingScreen> createState() => _ClassPostingScreenState();
}

class _ClassPostingScreenState extends State<ClassPostingScreen> {
  List<TextEditingController> contentcons = [];

  List<Eachpost> postlist = [];

  TextEditingController codetext = TextEditingController();
  bool floatingshow = false;

  bool submitted = false;
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

    setState(() {});
  }

  Future<void> newcontroller() async {
    var pairone = await Row(
      children: [
        await Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'Text Field',
            style: labelTextStyle,
          ),
        ),
      ],
    );
    Container(
      padding: const EdgeInsets.only(right: 15, bottom: 10, left: 15, top: 10),
      child: TextFormField(
        controller: codetext,
        autofocus: false,
        autocorrect: false,
        textCapitalization: TextCapitalization.words,
        autovalidateMode:
            submitted ? AutovalidateMode.always : AutovalidateMode.disabled,
        validator: RequiredValidator(errorText: "Text field cannot be blank !"),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        // actions: [
        //   GestureDetector(
        //     onTap: () async {
        //       if (_formKey.currentState!.validate() && havetitle == true) {
        //         await postBlog(postlist);
        //       }
        //     },
        //     child: Padding(
        //         padding: const EdgeInsets.fromLTRB(0, 6, 5, 6),
        //         child: Container(
        //           padding: const EdgeInsets.symmetric(horizontal: 8),
        //           decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(10),
        //               color: havetitle ? paledarkmain : Colors.grey[300]),
        //           child: Center(
        //             child: Text(
        //               'Post',
        //               style: TextStyle(
        //                   color: havetitle ? Colors.white : Colors.black,
        //                   fontSize: ScreenUtil().setSp(13),
        //                   fontWeight: FontWeight.w400),
        //             ),
        //           ),
        //         )),
        //   )
        // ],
      ),

      body: Column(
        children: [
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
                            await newcontroller();
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
        ],
      ),

      // floatingActionButton:
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

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
