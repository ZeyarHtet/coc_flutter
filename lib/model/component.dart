import 'dart:io' as io;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

showToast(msg, color) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color == "green"
          ? Colors.green
          : color == "darkmain"
              ? darkmain
              : color == "red"
                  ? Colors.red[300]
                  : Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}

showLoadingDialog(BuildContext context, String msg) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        // insetPadding: EdgeInsets.all(8.0),
        backgroundColor: Colors.white,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitCircle(
              color: darkmain,
              size: 40.0,
            ),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                msg,
                style: TextStyle(
                    color: darkmain,
                    // fontSize: 22,
                    fontSize: ScreenUtil().setSp(15),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      );
    },
  );
}

Widget searchTextField() {
  return TextField(
    autofocus: false,
    cursorColor: maincolor,
    style: searchfieldTextStyle,
    textInputAction: TextInputAction.search,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.all(10.0),
      filled: true,
      fillColor: trandarkmain,
      hintText: 'Search. . .',
      hintStyle: searchfieldTextStyle,
      border: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
        borderSide: BorderSide.none,
      ),
      //  enabledBorder:
      //     const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      // focusedBorder:
      //     UnderlineInputBorder(borderSide: BorderSide(color: trandarkmain)),
    ),
  );
}

// class CustomemailValidator extends TextFieldValidator {
//   // pass the error text to the super constructor
//   CustomemailValidator({String errorText = 'enter vilidate email'})
//       : super(errorText);

//   // return false if you want the validator to return error
//   // message when the value is empty.
//   @override
//   bool get ignoreEmptyValues => true;

//   @override
//   bool isValid(String? value) {
//   String pattern =
//       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//   RegExp regex = RegExp(pattern);
//   return regex.hasMatch(value!);
//   }
// }

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}

class AlreadyExistValidator extends TextFieldValidator {
  studentparentpair pairlist;
  // pass the error text to the super constructor
  AlreadyExistValidator(
      {String errorText = 'Already Existed Family Member',
      required this.pairlist})
      : super(errorText);

  // return false if you want the validator to return error
  // message when the value is empty.
  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String? value) {
    if (pairlist.parentemaillist.isNotEmpty) {
      for (var eachparent in pairlist.parentemaillist) {
        if (eachparent == value!.trim()) {
          return false;
        }
      }
    }
    return true;

    // return hasMatch(r'^((+|00)?218|0?)?(9[0-9]{8})$', value!, caseSensitive: false);
  }
}

class ErrorCard extends StatelessWidget {
  Color leftborder;
  Color bgcolor;
  IconData leadingicon;
  String title;
  String emaillist;
  ErrorCard(
      {super.key,
      required this.leftborder,
      required this.bgcolor,
      required this.leadingicon,
      required this.emaillist,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 13),
      padding: const EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: leftborder,
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(126, 158, 158, 158),
            offset: Offset(0.0, 0.4), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      // height: 50,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(5.0),
              bottomRight: Radius.circular(5.0)),
          color: bgcolor,
        ),
        child: ListTile(
          leading: Icon(
            leadingicon,
            size: 26,
            color: leftborder,
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(15),
                  fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Text(
            emaillist,
            style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(12),
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}

logoutdialog(BuildContext context, String distex, Function() func) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding:
            const EdgeInsets.only(left: 10, right: 0, top: 15, bottom: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              distex,
              style: TextStyle(
                  color: seccolor,
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: seccolor,
                          fontSize: ScreenUtil().setSp(14),
                          fontWeight: FontWeight.w500),
                    )),
                TextButton(
                    // 1/9
                    onPressed: () {
                      func();
                      // Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                          color: darkmain,
                          fontSize: ScreenUtil().setSp(14),
                          fontWeight: FontWeight.w500),
                    )),
              ],
            )
          ],
        ),
      );
    },
  );
}

class PreviewImageDialog extends StatelessWidget {
  XFile imagePath;
  PreviewImageDialog({Key? key, required this.imagePath}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 10,
        child: Image.file(
          io.File(imagePath.path),
          width: MediaQuery.of(context).size.width * 0.8,
          // height: MediaQuery.of(context).size.height * 0.8,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class Imagecontainer extends StatefulWidget {
  List<XFile> galaryimage;
  Imagecontainer({super.key, required this.galaryimage});

  @override
  State<Imagecontainer> createState() => _ImagecontainerState();
}

class _ImagecontainerState extends State<Imagecontainer> {
  int setcrossaxiscount(int listlength) {
    var count = 1;
    if (listlength <= 4) {
      count = 2;
    } else if (listlength >= 5) {
      count = 3;
    } else {
      count = 1;
    }
    return count;
  }

  // bool isover = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      // height: widget.galaryimage.length > 9
      //     ? MediaQuery.of(context).size.height * 0.48
      //     : null,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.transparent),
      child: widget.galaryimage.isEmpty
          ? Container()
          : widget.galaryimage.length == 1
              ? Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => PreviewImageDialog(
                            imagePath: widget.galaryimage[0],
                          ),
                        );
                        setState(() {});
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Image.file(
                          io.File(widget.galaryimage[0].path),
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0.2,
                      top: 0.2,
                      child: GestureDetector(
                        onTap: () {
                          widget.galaryimage.removeAt(0);
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(150, 117, 117, 117)),
                          child: Icon(
                            Icons.close,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : GridView.count(
                  shrinkWrap: true,
                  reverse: false,
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: setcrossaxiscount(widget.galaryimage.length),
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  children: List.generate(
                      widget.galaryimage.length <= 9
                          ? widget.galaryimage.length
                          : 9, (index) {
                    return Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => PreviewImageDialog(
                                imagePath: widget.galaryimage[index],
                              ),
                            );
                            setState(() {});
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              io.File(widget.galaryimage[index].path),
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0.2,
                          top: 0.2,
                          child: GestureDetector(
                            onTap: () {
                              widget.galaryimage.removeAt(index);
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromARGB(150, 117, 117, 117)),
                              child: Icon(
                                Icons.close,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        if (widget.galaryimage.length > 9 && index == 8)
                          Positioned(
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                              child: Text(
                                '+${widget.galaryimage.length - 9}',
                                style: inputTextStyle,
                              ),
                            ),
                          )
                        else
                          Positioned(child: Container())
                      ],
                    );
                  }),
                ),
    );
  }
}

class Customtextfield extends StatefulWidget {
  TextEditingController controller;
  String hinttext;
  void Function()? deletefun;

  Customtextfield(
      {super.key,
      required this.controller,
      required this.hinttext,
      required this.deletefun});

  @override
  State<Customtextfield> createState() => _CustomtextfieldState();
}

class _CustomtextfieldState extends State<Customtextfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: 10,
      minLines: 1,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: widget.deletefun,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(
              Icons.close,
              size: 15,
              color: Colors.black,
            ),
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
        filled: true,
        fillColor: Colors.grey[200],
        hintText: widget.hinttext,
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
    );
  }
}

class Newimagecontainerwithcaption extends StatefulWidget {
  XFile imagepath;
  TextEditingController capcontroller;
  void Function()? deletefun;
  Newimagecontainerwithcaption(
      {super.key,
      required this.imagepath,
      required this.capcontroller,
      required this.deletefun});

  @override
  State<Newimagecontainerwithcaption> createState() =>
      _NewimagecontainerwithcaptionState();
}

class _NewimagecontainerwithcaptionState
    extends State<Newimagecontainerwithcaption> {
  bool isWeb = GetPlatform.isWeb;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            color: Colors.grey[500],
          ),
          TextFormField(
            controller: widget.capcontroller,
            maxLines: 4,
            minLines: 1,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
              filled: true,
              fillColor: Colors.grey[200],
              hintText: 'write caption here',
              hintStyle: labelTextStyle,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide: BorderSide.none,
              ),
            ),
            style: inputTextStyle,
            cursorColor: seccolor,
          ),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: isWeb
                    ? Image.network(
                        widget.imagepath.path,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        io.File(widget.imagepath.path),
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                right: 0.2,
                top: 0.2,
                child: GestureDetector(
                  onTap: widget.deletefun,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromARGB(150, 117, 117, 117)),
                    child: const Icon(
                      Icons.close,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class customtextfield extends StatefulWidget {
//   TextEditingController? controller;
//   String? labeltext;
//   void Function()? editingcomp;
//   void Function()? deletefun;

//   // void Function()? addwidgetfun;
//   FocusNode? focusnode;
//   // bool iscurrent;
//   // int? index;
//   customtextfield({
//     super.key,
//     this.controller,
//     // this.index,
//     this.labeltext,
//     this.editingcomp,
//     this.deletefun,
//     // this.addwidgetfun,
//     this.focusnode,
//     // required this.iscurrent
//   });

//   @override
//   State<customtextfield> createState() => _customtextfieldState();
// }

// class _customtextfieldState extends State<customtextfield> {
//   bool foricon = false;
//   bool showstack = false;
//   bool textempty = true;
//   // late FocusNode foc;
//   FocusNode rawfoc = FocusNode();

//   @override
//   void initState() {
//     // setState(() {
//     //   foc = widget.focusnode;
//     // });
//     // foc.requestFocus();
//     widget.focusnode!.addListener(() {
//       if (widget.focusnode!.hasFocus) {
//         setState(() {
//           foricon = true;
//         });
//       } else {
//         setState(() {
//           foricon = false;
//           showstack = false;
//         });
//         // foc.unfocus();
//       }
//     });

//     widget.controller!.addListener(() {
//       setState(() {
//         widget.controller!.text.isEmpty ? textempty = true : textempty = false;
//       });
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // widget.focusnode.dispose();
//     rawfoc.dispose();
//     // widget.focusnode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       // width: !showstack ? 0 : MediaQuery.of(context).size.width * 0.5,
//       height: !foricon
//           ? MediaQuery.of(context).size.height * 0.054
//           : !showstack
//               ? MediaQuery.of(context).size.height * 0.054
//               : MediaQuery.of(context).size.height * 0.11,
//       decoration: BoxDecoration(
//           color: foricon ? Colors.grey[300] : Colors.grey[200],
//           borderRadius: BorderRadius.circular(10)),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             RawKeyboardListener(
//               focusNode: rawfoc,
//               onKey: (event) {
//                 if (event is RawKeyDownEvent) {
//                   if (textempty &&
//                       event.logicalKey.keyLabel ==
//                           LogicalKeyboardKey.backspace.keyLabel) {
//                     print('he is deleting >>>>>');
//                     widget.deletefun!();
//                   }
//                 }
//               },
//               child: TextFormField(
//                   controller: widget.controller,
//                   // maxLines: 4,
//                   // minLines: 1,
//                   focusNode: widget.focusnode,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.all(10.0),
//                     filled: true,
//                     fillColor: foricon ? Colors.grey[300] : Colors.grey[200],
//                     hintText: widget.labeltext,
//                     hintStyle: inputTextStyle,
//                     suffixIcon: !foricon
//                         ? null
//                         : IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 showstack = !showstack;
//                               });
//                             },
//                             splashRadius: 2,
//                             icon: Icon(
//                               showstack
//                                   ? Icons.remove_circle_outline_outlined
//                                   : Icons.add_circle_outline,
//                               color: darkmain,
//                             )),
//                     // IconButton(
//                     //   onPressed: foricon
//                     //       ? () {
//                     //           showstack = !showstack;
//                     //         }
//                     //       : widget.deletefun,
//                     //   icon: Icon(
//                     //     foricon
//                     //         ? Icons.add_circle_outline_outlined
//                     //         : Icons.remove_circle_outline_outlined,
//                     //     color: foricon ? Color.fromARGB(255, 41, 53, 59) : darkmain,
//                     //     size: 20,
//                     // ),
//                     // ),
//                     border: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(10.0),
//                       ),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                   style: inputTextStyle,
//                   cursorColor: seccolor,
//                   onEditingComplete: widget.editingcomp),
//             ),
//             Row(
//               // mainAxisAlignment: MainAxisAlignment.start,/\
//               crossAxisAlignment: CrossAxisAlignment.start,
//               // mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                     onPressed: () {},
//                     icon: Icon(
//                       Icons.photo,
//                       color: darkmain,
//                     ))
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class blogpostCompo extends StatelessWidget {
  String title;
  String firstcontext;
  String? imagepath;
  String createdate;
  blogpostCompo(
      {super.key,
      required this.firstcontext,
      required this.title,
      this.imagepath,
      required this.createdate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$createdate. ',
                        style: secondTextstyle(Colors.grey[600]),
                      ),
                      Icon(
                        Icons.star_rounded,
                        color: paledarkmain,
                      ),
                      Text(
                        'All',
                        style: secondTextstyle(Colors.grey[600]),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.more_horiz_rounded,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: imagepath == null
                      ? MediaQuery.of(context).size.width * 0.85
                      : MediaQuery.of(context).size.width * 0.65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(16),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        firstcontext.length > 100
                            ? '${firstcontext.substring(0, 100)} . . . . .'
                            : firstcontext,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(12),
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                imagepath == null
                    ? Container()
                    : CachedNetworkImage(
                        imageBuilder: (context, imageProvider) => Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: darkmain,
                            image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    trandarkmain, BlendMode.colorBurn)),
                          ),
                        ),
                        imageUrl: '$miniohttp/coc/post_images/$imagepath',
                        placeholder: (context, url) => SpinKitCubeGrid(
                          size: 5,
                          color: paledarkmain,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}

String postsdatechange(DateTime time) {
  DateTime now = DateTime.now();
  var result = now.difference(time).inMinutes;
  if (result < 1) {
    return 'Just now';
  } else if (result >= 1 && result <= 60) {
    return '$result minute ago';
  } else if (result > 60 && result <= 1440) {
    return '${now.difference(time).inHours.toString()} hours ago';
  } else if (result > 1440 && result <= 2880) {
    return 'Yesterday';
  } else {
    var resultday = now.difference(time).inDays;
    if (resultday < 6) {
      return '$resultday days ago';
    } else {
      return DateFormat('d/M/y').format(time);
    }
  }
}
