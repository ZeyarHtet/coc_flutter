// import 'dart:convert';

// import 'package:flutter/material.dart';

// import '../../model/constant.dart';
// import '../../model/model.dart';

// class ClassDetails extends StatefulWidget {
//   String eachclassdetails;
//   classlistmodel eachclass;

//   ClassDetails(
//       {super.key, required this.eachclassdetails, required this.eachclass});

//   @override
//   State<ClassDetails> createState() => _ClassDetailsState();
// }

// class _ClassDetailsState extends State<ClassDetails> {
//   TextEditingController classnamecontroller = TextEditingController();
//   TextEditingController customgradecontroller = TextEditingController();
//   TextEditingController descriptioncontroller = TextEditingController();
//   TextEditingController schoolcontroller = TextEditingController();
//   var eachclassdetails;

//   initData() {
//     print(">>>>>> eachclassdetail");
//     eachclassdetails = jsonDecode(widget.eachclassdetails);
//     print(">>>>>>>>>>>> eachclassdetail $eachclassdetails");

//     setState(() {
//       if (eachclassdetails != null) {
//         classnamecontroller.text = eachclassdetails["title"] ?? '';
//         descriptioncontroller.text = eachclassdetails["description"] ?? '';
//         schoolcontroller.text = eachclassdetails["schoolId"] ?? '';
//         customgradecontroller.text = eachclassdetails["subtitle"] ?? '';
//       }
//     });
//   }

//   @override
//   void initState() {
//     initData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height * 0.1,
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(color: backcolor),
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               // crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                     backgroundColor: paledarkmain,
//                     radius: 25,
//                     child: Text(
//                       widget.eachclass.title == ""
//                           ? ""
//                           : widget.eachclass.title[0].toUpperCase(),
//                       style: buttonTextStyle,
//                     )),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                         widget.eachclass.title == ""
//                             ? ""
//                             : '${widget.eachclass.title.characters.take(36)}',
//                         style: firstTextstyle),
//                     Text(
//                       '${widget.eachclass.description}',
//                       style: secondTextstyle(Colors.grey[600]),
//                     ),
//                     //  Text(
//                     //   '${widget.eachclass.schoolId}',
//                     //   style: secondTextstyle(Colors.grey[600]),
//                     // ),
//                     Text(
//                       widget.eachclass.subtitle,
//                       style: secondTextstyle(Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Divider(
//             color: Colors.grey[300],
//             thickness: 1,
//             height: 1.1,
//           )
//         ],
//       ),
//     );
//   }
// }
