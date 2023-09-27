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
      // body: Column(
      //   children: [
      //     TextFormField(
      //       onTap: () {
      //         setState(() {
      //           _pickDateDialog();
      //         });
      //       },
      //       keyboardType: TextInputType.name,
      //       decoration: const InputDecoration(
      //         filled: true,
      //         fillColor: Color.fromARGB(255, 208, 205, 205),
      //         label: Icon(Icons.date_range),
      //       ),
      //       controller: startdateController,
      //     ),
      //     const SizedBox(
      //       height: 20,
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
      //       child: Center(
      //         child: ListView(
      //           shrinkWrap: true,
      //           scrollDirection: Axis.horizontal,
      //           physics: const BouncingScrollPhysics(),
      //           children: [
      //             SingleChildScrollView(
      //               child: Column(
      //                 children: [
      //                   Row(
      //                     children: [
      //                       tableHeaderWidget(context, idWidth, "Id"),
      //                       tableHeaderWidget(
      //                           context, assoneWidth, "Assignment 1"),
      //                       tableHeaderWidget(
      //                           context, assthreeWidth, "Assignment 2"),
      //                       tableHeaderWidget(
      //                           context, assthreeWidth, "Assignment 3"),
      //                     ],
      //                   ),
      //                 ],
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //     )
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        tableHeaderWidget(context, idWidth, "Id"),
                        tableHeaderWidget(context, assoneWidth, "Assignment1"),
                        tableHeaderWidget(
                            context, assthreeWidth, "Assignment2"),
                        tableHeaderWidget(
                            context, assthreeWidth, "Assignment3"),
                      ],
                    ),
                    SizedBox(
                      width:
                          idWidth + assoneWidth + asstwoWidth + assthreeWidth,
                      child: Container(
                        height: (progressList.length * tableHeight),
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: progressList.length,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int i) {
                              return Row(
                                children: [
                                  tableFormWidget(
                                    context,
                                    idWidth,
                                    progressList[i]["id"],
                                    0,
                                  ),
                                  tableFormWidget(
                                    context,
                                    assoneWidth,
                                    progressList[i]["assignment_one"],
                                    1,
                                  ),
                                  tableFormWidget(
                                    context,
                                    asstwoWidth,
                                    progressList[i]["assignment_two"],
                                    2,
                                  ),
                                  tableFormWidget(
                                    context,
                                    assthreeWidth,
                                    progressList[i]["assignment_three"],
                                    3,
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
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
