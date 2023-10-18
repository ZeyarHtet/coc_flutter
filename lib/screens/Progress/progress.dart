import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/screens/Progress/studentlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import '../drawer.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final TextEditingController startdateController = TextEditingController();
  DateTime? picked;
  List progressList = [
    {
      "id": "1",
      "assignment_one": "blahblah",
      "assignment_two": "test",
      "assignment_three": "assignment_three",
    }
  ];
  double tableHeight = 60;
  double idWidth = 50;
  double assoneWidth = 110;
  double asstwoWidth = 110;
  double assthreeWidth = 110;

  tableHeaderWidget(context, width, name) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: name == "Id"
            ? const Border(
                bottom: BorderSide(color: Colors.black),
                top: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                left: BorderSide(color: Colors.black),
              )
            : const Border(
                bottom: BorderSide(color: Colors.black),
                top: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
              ),
      ),
      width: width,
      height: tableHeight,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$name",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }

  tableFormWidget(
    context,
    width,
    name,
    id,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: id == 0
            ? const Border(
                bottom: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                left: BorderSide(color: Colors.black),
              )
            : const Border(
                bottom: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black)),
      ),
      width: width,
      height: tableHeight,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "$name",
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
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
        title: Text("Progress", style: appbarTextStyle(maincolor)),
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: DrawerScreen(
          pagename: 'Progress',
        ),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StudentList()),
          );
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                color: darkmain,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Assignment 1',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                color: darkmain,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Assignment 2',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                color: darkmain,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Assignment 3',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
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
}
