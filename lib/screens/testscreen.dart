// import 'package:class_on_cloud/model/api.dart';
// import 'package:class_on_cloud/model/constant.dart';
// import 'package:class_on_cloud/model/model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class TEsting extends StatefulWidget {
//   const TEsting({super.key});

//   @override
//   State<TEsting> createState() => _TEstingState();
// }

// class _TEstingState extends State<TEsting> {
//   // late List<UserData> intruder;
//   // List<String> names = [];
//   late Classes clas;
//   bool ready = false;
//   getdata() async {}

//   getclass() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     var result = await getsingleclassapi('928ef97f-d3be-4eb2-ba1e-ed725069f4ba');
//     await prefs.setString('data', result['data']);

//     // Fetch and decode data
//     // String? musicsString = prefs.getString('data');
//     // musicsString == null ? null : clas = Classes.fromRawJson(musicsString);

//     // print('>>>testing ${clas.classId}');
//     // for (var i = 0; i < classlist.length; i++) {
//     //   myclass.add(classlistmodel(
//     //       classId: classlist[i]['class_id'],
//     //       title: classlist[i]['title'],
//     //       subtitle: classlist[i]['subtitle'],
//     //       schoolId: classlist[i]['school_id'],
//     //       privateId: classlist[i]['private_id'],
//     //       description: classlist[i]['description'],
//     //       picUrl: classlist[i]["pic_url"]));
//     // }
//     // // print("...??><><><> $myclass");
//     setState(() {
//       ready = true;
//     });
//   }

//   @override
//   void initState() {
//     getclass();
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//             child: ready
//                 ? Text(
//                     "mina",
//                     style: labelTextStyle,
//                   )
//                 : SpinKitCubeGrid(
//                     color: darkmain,
//                   )));
//   }
// }

import 'package:class_on_cloud/model/constant.dart';
import 'package:flutter/material.dart';

class CustomEmailInput extends StatefulWidget {
  // final Function setList;

  const CustomEmailInput({
    Key? key,
    // this.setList,
  }) : super(key: key);

  @override
  _CustomEmailInputState createState() => _CustomEmailInputState();
}

class _CustomEmailInputState extends State<CustomEmailInput> {
  TextEditingController _emailController = TextEditingController();
  String lastValue = '';
  List<String> emails = [];
  FocusNode focus = FocusNode();
  @override
  void initState() {
    super.initState();

    focus.addListener(() {
      if (!focus.hasFocus) {
        updateEmails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          constraints: BoxConstraints(
              maxHeight: 50, maxWidth: MediaQuery.of(context).size.width),
          color: paledarkmain,
          child: GridView.count(
            padding: EdgeInsets.all(0),
            crossAxisCount: 3,
            children: <Widget>[
              ...emails
                  .map(
                    (email) => Chip(
                      backgroundColor: darkmain,
                      label: Text(
                        email,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      onDeleted: () => {
                        setState(() {
                          emails.removeWhere((element) => email == element);
                        })
                      },
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
        TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration.collapsed(hintText: 'email'),
          controller: _emailController,
          focusNode: focus,
          onChanged: (String val) {
            setState(() {
              if (val != lastValue) {
                lastValue = val;
                if (val.endsWith(' ') && validateEmail(val.trim())) {
                  if (!emails.contains(val.trim())) {
                    emails.add(val.trim());
                    print('>>>>Mails>> $emails.length');
                    // widget.setList(emails);
                  }
                  _emailController.clear();
                } else if (val.endsWith(' ') && !validateEmail(val.trim())) {
                  _emailController.clear();
                }
              }
            });
          },
          onEditingComplete: () {
            updateEmails();
          },
        )
      ],
    );
  }

  updateEmails() {
    setState(() {
      if (validateEmail(_emailController.text)) {
        if (!emails.contains(_emailController.text)) {
          emails.add(_emailController.text.trim());
          // widget.setList(emails);
        }
        _emailController.clear();
      } else if (!validateEmail(_emailController.text)) {
        _emailController.clear();
      }
    });
  }

  setEmails(List<String> emails) {
    this.emails = emails;
  }
}

bool validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(value);
}
