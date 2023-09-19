// import 'dart:html';

import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/model/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // TextEditingController titlecontroller = TextEditingController();
  // TextEditingController contentcontroller = TextEditingController();
  List<TextEditingController> contentcons = [];
  List<FocusNode> nodes = [];
  // List<Eachpost> controlnodelist = [];

  bool floatingshow = false;
  // List<Widget> contentlist = [];
  // int myid = 2;
  deletefunc(int widgetId) {
    // var place = postlist.indexWhere((element) => element['id'] == widgetId);
    postlist.removeAt(widgetId);
    // var removed = contentcons.removeAt(widgetId);
    // removed.dispose();
    setState(() {});
  }

  List<Map<String, dynamic>> postlist = [];
  // int totalwidgind = 0;
  int focusind = 0;

  // editcompfun(int widgetId) async {
  //   // setState(() {
  //   //   myid = myid + 1;
  //   // });

  //   var place = postlist.indexWhere((element) => element['id'] == widgetId);

  //   FocusScope.of(context).unfocus();
  //   nodes[place].unfocus();

  //   // listnum.insert(place + 1, listnum.length);
  //   print('$widgetId place is >>>> $place');

  //   setState(() {});
  //   // contentlist.insert(
  //   //     plusindex,
  //   //     customtextfield(
  //   //       controller: contentcons[plusindex],
  //   //       labeltext: '${nodes[plusindex]}',
  //   //       focusnode: nodes[plusindex],
  //   //       // index: plusindex,
  //   //       // iscurrent: true,
  //   //       editingcomp: () {
  //   //         FocusScope.of(context).unfocus();
  //   //         editcompfun(plusindex + 1);
  //   //       },
  //   //       deletefun: () async {
  //   //         deletefunc(nodes[plusindex]);
  //   //         // contentlist.remove(customtextfield().focusnode);
  //   //         print('Such an Idiot k');
  //   //         // setState(() {});
  //   //       },
  //   //     ));
  //   int listnumind = nodes.length;
  //   // newfoc.requestFocus();
  //   postlist.insert(place + 1, {
  //     'id': listnumind,
  //     'value': contentcons[place + 1].text,
  //     'widget': customtextfield(
  //       controller: contentcons[place + 1],
  //       // labeltext: '$listnumind',
  //       focusnode: nodes[place + 1],
  //       editingcomp: () {
  //         editcompfun(listnumind);
  //       },
  //       deletefun: () {
  //         FocusScope.of(context).unfocus();
  //         deletefunc(listnumind);
  //       },
  //     )
  //   });
  //   setState(() {});
  //   // for (var i = 0; i < nodes.length; i++) {
  //   //   nodes[i].addListener(() {
  //   //     // print(" $i Has focus: ${nodes[i].hasFocus}");
  //   //     if (nodes[i].hasFocus) {
  //   //       isfocused = i;
  //   //       setState(() {});
  //   //       print(" $isfocused Has focus>>>>>>>>");
  //   //     }
  //   //   });
  //   // }
  //   // print(" $isfocused Has focus outside");
  // }

  editcompletefunc() {
    contentcons.add(TextEditingController());
    nodes.add(FocusNode());
    // var index = postlist.indexWhere((element) => element['id'] == widgid);
    // controlnodelist
    //     .add(Eachpost(control: TextEditingController(), focusnod: FocusNode()));
    // for (var each in nodes) {
    //   setState(() {
    //     each.unfocus();
    //   });
    // }
    //
    // print('>>>> Widind is >>>> $widgind');
    // var newinsert = widgind + 1;
    for (var i = 0; i < nodes.length; i++) {
      nodes[i].addListener(() {
        if (nodes[i].hasFocus) {
          print('now foucus is att >>> $i');
          setState(() {
            focusind = i + 1;
          });
        }
      });
    }
    // nodes[index + 1].requestFocus();
    // var totallength = contentcons.length - 1;\
    // nodes[newinsert].requestFocus();

    // totalwidgind = totalwidgind + 1;
    var currentlengthind = nodes.length - 1;
    // print('current lengthind is >>> $currentlengthind');
    nodes[currentlengthind].requestFocus();
    // var lastval = controlnodelist.last;
    // var newid = totalwidgind;
    setState(() {});
    postlist.insert(focusind, {
      'id': currentlengthind,
      'value': contentcons[currentlengthind].text,
      'widget': TextFormField(
        focusNode: nodes[currentlengthind],
        controller: contentcons[currentlengthind],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10.0),
          filled: true,
          fillColor: focusind == nodes.indexOf(nodes[currentlengthind])
              ? Colors.grey[300]
              : backcolor,
          hintText: currentlengthind.toString(),
          hintStyle: inputTextStyle,
          suffixIcon: focusind == nodes.indexOf(nodes[currentlengthind])
              ? null
              : IconButton(
                  onPressed: () {
                    // setState(() {
                    //   showstack = !showstack;
                    // });
                  },
                  splashRadius: 2,
                  icon: Icon(
                    // showstack
                    //     ? Icons.remove_circle_outline_outlined
                    //     :
                    Icons.add_circle_outline,
                    color: darkmain,
                  )),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide.none,
          ),
        ),
        style: inputTextStyle,
        cursorColor: seccolor,
        onEditingComplete: () {
          editcompletefunc();
        },
      )
    });
    setState(() {});
  }

  setData() async {
    nodes.add(FocusNode());
    contentcons.add(TextEditingController());
    // controlnodelist
    //     .add(Eachpost(control: TextEditingController(), focusnod: FocusNode()));
    // controlnodelist
    //     .add(Eachpost(control: TextEditingController(), focusnod: FocusNode()));
    postlist.add({
      'id': 0,
      'value': contentcons[0].text,
      'widget': TextFormField(
        focusNode: nodes[0],
        controller: contentcons[0],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10.0),
          filled: true,
          fillColor: focusind == nodes.indexOf(nodes[0])
              ? Colors.grey[300]
              : backcolor,
          hintText: 0.toString(),
          hintStyle: inputTextStyle,
          suffixIcon: focusind == nodes.indexOf(nodes[0])
              ? null
              : IconButton(
                  onPressed: () {
                    // setState(() {
                    //   showstack = !showstack;
                    // });
                  },
                  splashRadius: 2,
                  icon: Icon(
                    // showstack
                    //     ? Icons.remove_circle_outline_outlined
                    //     :
                    Icons.add_circle_outline,
                    color: darkmain,
                  )),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide.none,
          ),
        ),
        style: inputTextStyle,
        cursorColor: seccolor,
        onEditingComplete: () {
          editcompletefunc();
        },
      )
    });
    // nodes[0].requestFocus();
    // postlist.add(Eachpost(id: 0, value: [
    //   contentcons[0].text
    // ], widget: [
    //   Container(
    //     width: 20,
    //     height: 20,
    //     color: Colors.black,
    //   )
    // ]));
    // nodes[0].requestFocus();
  }

  final ImagePicker _picker = ImagePicker();
  List<List<XFile>> galaryimagelist = [];
  Future<void> _selectImage() async {
    List<XFile> eachone = await _picker.pickMultiImage(
        // source: ImageSource.gallery,
        maxWidth: 100000000000,
        maxHeight: 100000000000,
        imageQuality: 100);
    galaryimagelist.add(eachone);
    // imagepath = pickedFile == null ? null : !pickedFile.path.toString();
    // pickedFile == null ? null : galaryimage = pickedFile;
    print('Path >> ${galaryimagelist.length}');
  }

  // getnextcontroller() {
  //   contentcons.add(TextEditingController());
  // }

  // Widget getimagewid(List<XFile?> imagepath) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     height: MediaQuery.of(context).size.height * 0.5,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10), color: Colors.grey),
  //     child: imagepath.isEmpty
  //         ? Container()
  //         : GridView.count(
  //             shrinkWrap: true,
  //             physics: const BouncingScrollPhysics(),
  //             crossAxisCount: 2,
  //             crossAxisSpacing: 1,
  //             mainAxisSpacing: 1,
  //             children: List.generate(imagepath.length, (index) {
  //               return Stack(
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {
  //                       showDialog(
  //                         context: context,
  //                         builder: (_) => PreviewImageDialog(
  //                           imagePath: imagepath[index]!,
  //                         ),
  //                       );
  //                       setState(() {});
  //                     },
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.circular(8.0),
  //                       child: Image.file(
  //                         File(imagepath[index]!.path),
  //                         width: 200,
  //                         fit: BoxFit.cover,
  //                         frameBuilder:
  //                             (context, child, frame, wasSynchronouslyLoaded) {
  //                           if (wasSynchronouslyLoaded) {
  //                             return child;
  //                           } else {
  //                             return AnimatedOpacity(
  //                               opacity: frame == null ? 0 : 1,
  //                               duration: const Duration(milliseconds: 300),
  //                               curve: Curves.easeOut,
  //                               child: child,
  //                             );
  //                           }
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                   Positioned(
  //                     right: 0.2,
  //                     top: 0.2,
  //                     child: GestureDetector(
  //                       onTap: () {
  //                         // imagepath.removeAt(index);
  //                         // setState(() {});
  //                       },
  //                       child: const Padding(
  //                         padding: EdgeInsets.all(3.0),
  //                         child: CircleAvatar(
  //                           radius: 12,
  //                           backgroundColor: Color.fromARGB(182, 108, 107, 107),
  //                           child: Icon(
  //                             Icons.close,
  //                             size: 12,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               );
  //             }),
  //           ),
  //   );
  // }

  @override
  void initState() {
    setData();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    for (var focusNode in nodes) {
      focusNode.dispose();
    }
    for (var controller in contentcons) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
          title: Text("2222",
              style: TextStyle(
                  color: darkmain,
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.w500)),
          actions: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 5, 6),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[400]),
                  child: Center(
                    child: Text(
                      'POST',
                      style: labelTextStyle,
                    ),
                  ),
                ))
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: TextEditingController(),
                      // autofocus: true,
                      focusNode: FocusNode(),
                      // autovalidateMode: controllers[i].text != lastValue
                      //     ? AutovalidateMode.onUserInteraction
                      //     : AutovalidateMode.disabled,
                      validator: RequiredValidator(
                          errorText: 'Title is required to create post'),
                      maxLines: 3,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      // textInputAction: TextInputAction.send,
                      // focusNode: focus,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintText: 'Title',
                        hintStyle: inputTextStyle,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      // style: inputTextStyle,
                      cursorColor: seccolor,
                    ),
                  ),
                  // Column(
                  //   children: contentlist,
                  // ),
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    ...postlist.map((e) {
                      return e['widget'];
                    })
                  ]),

                  ElevatedButton(
                      onPressed: () {
                        for (var elemen in contentcons) {
                          print('TExt are >>>>> ${elemen.text}');
                        }
                      },
                      child: Text('SEE texts')),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: MediaQuery.of(context).size.height,
                  //   child: ListView.builder(itemBuilder: (context, index) {
                  //     return Container();
                  //   }),
                  // ),
                  // Imagecontainer(galaryimage: galaryimage),
                  // Container(
                  //   height: galaryimage.length > 9
                  //       ? MediaQuery.of(context).size.height * 0.4
                  //       : null,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: galaryimage.isEmpty
                  //       ? Container()
                  //       : galaryimage.length == 1
                  //           ? Stack(
                  //               children: [
                  //                 GestureDetector(
                  //                   onTap: () {
                  //                     showDialog(
                  //                       context: context,
                  //                       builder: (_) => PreviewImageDialog(
                  //                         imagePath: galaryimage[0],
                  //                       ),
                  //                     );
                  //                     setState(() {});
                  //                   },
                  //                   child: ClipRRect(
                  //                     borderRadius: BorderRadius.circular(4.0),
                  //                     child: Image.file(
                  //                       File(galaryimage[0].path),
                  //                       width: 200,
                  //                       fit: BoxFit.cover,
                  //                       // frameBuilder: (context, child, frame,
                  //                       //     wasSynchronouslyLoaded) {
                  //                       //   if (wasSynchronouslyLoaded) {
                  //                       //     return child;
                  //                       //   } else {
                  //                       //     return AnimatedOpacity(
                  //                       //       opacity: frame == null ? 0 : 1,
                  //                       //       duration: const Duration(
                  //                       //           milliseconds: 300),
                  //                       //       curve: Curves.easeOut,
                  //                       //       child: child,
                  //                       //     );
                  //                       //   }
                  //                       // },
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Positioned(
                  //                   right: 0.2,
                  //                   top: 0.2,
                  //                   child: GestureDetector(
                  //                     onTap: () {
                  //                       galaryimage.removeAt(0);
                  //                       setState(() {});
                  //                     },
                  //                     child: const Padding(
                  //                       padding: EdgeInsets.all(3.0),
                  //                       child: CircleAvatar(
                  //                         radius: 12,
                  //                         backgroundColor: Color.fromARGB(
                  //                             182, 108, 107, 107),
                  //                         child: Icon(
                  //                           Icons.close,
                  //                           size: 12,
                  //                           color: Colors.white,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             )
                  //           : GridView.count(
                  //               shrinkWrap: true,
                  //               reverse: false,
                  //               physics: const BouncingScrollPhysics(),
                  //               crossAxisCount:
                  //                   setcrossaxiscount(galaryimage.length),
                  //               crossAxisSpacing: 2,
                  //               mainAxisSpacing: 2,
                  //               children:
                  //                   List.generate(galaryimage.length, (index) {
                  //                 return Stack(
                  //                   children: [
                  //                     GestureDetector(
                  //                       onTap: () {
                  //                         showDialog(
                  //                           context: context,
                  //                           builder: (_) => PreviewImageDialog(
                  //                             imagePath: galaryimage[index],
                  //                           ),
                  //                         );
                  //                         setState(() {});
                  //                       },
                  //                       child: ClipRRect(
                  //                         borderRadius:
                  //                             BorderRadius.circular(8.0),
                  //                         child: Image.file(
                  //                           File(galaryimage[index].path),
                  //                           width: 200,
                  //                           fit: BoxFit.cover,
                  //                           // frameBuilder: (context, child, frame,
                  //                           //     wasSynchronouslyLoaded) {
                  //                           //   if (wasSynchronouslyLoaded) {
                  //                           //     return child;
                  //                           //   } else {
                  //                           //     return AnimatedOpacity(
                  //                           //       opacity: frame == null ? 0 : 1,
                  //                           //       duration: const Duration(
                  //                           //           milliseconds: 300),
                  //                           //       curve: Curves.easeOut,
                  //                           //       child: child,
                  //                           //     );
                  //                           //   }
                  //                           // },
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     Positioned(
                  //                       right: 0.2,
                  //                       top: 0.2,
                  //                       child: GestureDetector(
                  //                         onTap: () {
                  //                           galaryimage.removeAt(index);
                  //                           setState(() {});
                  //                         },
                  //                         child: const Padding(
                  //                           padding: EdgeInsets.all(3.0),
                  //                           child: CircleAvatar(
                  //                             radius: 12,
                  //                             backgroundColor: Color.fromARGB(
                  //                                 182, 108, 107, 107),
                  //                             child: Icon(
                  //                               Icons.close,
                  //                               size: 12,
                  //                               color: Colors.white,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 );
                  //               }),
                  //             ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: floatingshow
              ? MediaQuery.of(context).size.width * 0.8
              : MediaQuery.of(context).size.width * 0.14,
          height: MediaQuery.of(context).size.width * 0.14,
          decoration: BoxDecoration(
              color: paledarkmain, borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                floatingshow
                    ? Row(
                        children: [
                          CircleAvatar(
                              radius: 20,
                              backgroundColor: backcolor,
                              child: const Icon(
                                Icons.code_rounded,
                                size: 18,
                              )),
                          const SizedBox(
                            width: 7,
                          ),
                          CircleAvatar(
                              radius: 20,
                              backgroundColor: backcolor,
                              child: const Icon(
                                Icons.insert_drive_file_outlined,
                                size: 18,
                              )),
                          const SizedBox(
                            width: 7,
                          ),
                          CircleAvatar(
                              radius: 20,
                              backgroundColor: backcolor,
                              child: const Icon(
                                Icons.video_library_outlined,
                                size: 18,
                              )),
                          const SizedBox(
                            width: 7,
                          ),
                          GestureDetector(
                            onTap: () async {
                              // var place = postlist.indexWhere(
                              //     (element) => element['id'] == widgetId);
                              await _selectImage();
                              // if (galaryimage.isNotEmpty) {
                              //   // getimagewid(galaryimage!);
                              //   contentlist.add(getimagewid(galaryimage));
                              setState(() {});
                              // }
                            },
                            child: CircleAvatar(
                                radius: 20,
                                backgroundColor: backcolor,
                                child: const Icon(
                                  Icons.photo_library_outlined,
                                  size: 18,
                                )),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          CircleAvatar(
                              radius: 20,
                              backgroundColor: backcolor,
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                size: 18,
                              )),
                          const SizedBox(
                            width: 7,
                          ),
                           CircleAvatar(
                              radius: 20,
                              backgroundColor: backcolor,
                              child: const Icon(
                                Icons.code,
                                size: 18,
                              )),
                          const SizedBox(
                            width: 7,
                          ),
                        ],
                      )
                    : Container(),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        floatingshow = !floatingshow;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(
                          floatingshow
                              ? Icons.arrow_forward_ios_rounded
                              : Icons.add,
                          color: Colors.white,
                          size: 20),
                    )),
              ]),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
