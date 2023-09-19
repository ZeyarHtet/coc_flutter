import 'package:class_on_cloud/model/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import 'drawer.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final TextEditingController startdateController = TextEditingController();
  DateTime? picked;
  double tableHeight = 60;
  double assone = 100;
  double asstwo = 200;
  double assthree = 200;

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
        actions: [
          FloatingActionButton.extended(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => AddCategory(
              //       // id: courseList.length,
              //       id: categoryList.isEmpty ? 0 : categoryList.last["id"],
              //     ),
              //   ),
              // );
            },
            backgroundColor: darkmain,
            label: const Text(
              'Add',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            shape: const BeveledRectangleBorder(),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: DrawerScreen(
          pagename: 'Progress',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              onTap: () {
                setState(() {
                  _pickDateDialog();
                });
              },
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 208, 205, 205),
                label: Icon(Icons.date_range),
              ),
              controller: startdateController,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
              child: Center(
                child: ListView(
                   shrinkWrap: false, // all devices, use MediaQuery
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                       SingleChildScrollView(
                        child: Column(
                          children: [
                           Row(
                                children: [
                                  ////id
                                  tableHeaderWidget(context, assone, "Assignment 1"),

                                  //// name
                                  tableHeaderWidget(context, asstwo, "Assignment 2"),
                                  //// No

                                  tableHeaderWidget(context, assthree, "Assignment 3"),

                                  ///actionbutton
                                 
                                ],
                              ),
                          ],
                        ),
                       )
                      ],
                ),
              ),
            )
          ],
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
        startdateController.text = DateFormat('yyyy-MM-dd').format(picked!);
      });
    }
  }
}
