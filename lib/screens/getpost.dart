import 'dart:convert';

import 'package:class_on_cloud/model/api.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:class_on_cloud/screens/classposting.dart';
import 'package:class_on_cloud/screens/newposting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/component.dart';
import '../model/constant.dart';
import 'drawer.dart';
import 'home.dart';

class GetPostScreen extends StatefulWidget {
  const GetPostScreen({super.key});

  @override
  State<GetPostScreen> createState() => _GetPostScreenState();
}

class _GetPostScreenState extends State<GetPostScreen> {
  bool searchBoolean = false;

  List<classpostlistmodel> myclasspost = [];
  classpostlistmodel? selectedclasspost;
  late var result;
  bool ready = false;
  classlistmodel? selectedclass;

  getclasspost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mineclass = prefs.getString('selectedClass');
    mineclass == null
        ? selectedclass = null
        : selectedclass = classlistmodel.singledecode(mineclass);
    result = await getclasspostapi();
    print('>>>>>>>>>>>>>>>>>>>>>>$result');
    if (result['returnCode'] == '300') {
      setState(() {
        myclasspost = [];
      });
    } else if (result['returnCode'] == '200') {
      List classpostList = result['posts'];
      print('>>>>>>>>>>>>>>> classpostlist$classpostList');
      if (classpostList.isNotEmpty) {
        for (var i = 0; i < classpostList.length; i++) {
          myclasspost.add(
            classpostlistmodel(
              postId: classpostList[i]['post_id'] ?? "",
              classId: classpostList[i]['class_id'] ?? "",
              title: classpostList[i]['title'] ?? "",
              type: classpostList[i]['type'].toString(),
              duedate: classpostList[i]['due_date'] ?? "",
            ),
          );
        }
        print(">>>>>>>>>>>>> class length ${myclasspost.length}");

        String encodedclasspost = classpostlistmodel.encode(myclasspost);
        await prefs.setString('classpostList', encodedclasspost);
      }
    }

    var mineclasspost = prefs.getString('selectedclassPost');
    mineclasspost == null
        ? selectedclasspost = null
        : selectedclasspost = classpostlistmodel.singledecode(mineclasspost);
    setState(() {
      ready = true;
    });
  }

  delectedclasspost(String postid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    result = await deleteclasspostapi(postid);

    print('>><><><>< before>>${myclasspost.length}');
    if (postid == selectedclasspost?.postId) {
      var removedData =
          myclasspost.removeWhere((element) => element.postId == postid);

      print('>><><><>< ${myclasspost.length}');
      if (myclasspost.isEmpty) {
        var addinnull = await prefs.remove('selectedClass');
        print('><><>>>>>Nulling $addinnull');
      } else {
        String selectedencode = classpostlistmodel.sigleencode(myclasspost[0]);
        await prefs.setString("selectedclasspost", selectedencode);
      }
    }
    if (result['returnCode'] == '200') {
      Navigator.pop(context);
      showToast('successfully deleted', 'darkmain');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const GetPostScreen()),
          (route) => false);
    } else {
      Navigator.pop(context);
      showToast('${result['returnCode']}', 'red');
    }
    setState(() {});
  }

  @override
  void initState() {
    getclasspost();
    super.initState();
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
        title: Text("Post", style: appbarTextStyle(maincolor)),
      ),

      drawer: searchBoolean
          ? null
          : SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: DrawerScreen(
                pagename: selectedclass == null ? 'Home' : selectedclass!.title,
              )),
      body: ready
          ? myclasspost.isEmpty
              ? Center(
                  child: Text(
                    "You don't have any post yet!",
                    style: inputTextStyle,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          itemCount: myclasspost.length,
                          itemBuilder: (context, i) {
                            return Slidable(
                              endActionPane: ActionPane(
                                extentRatio: 0.26,
                                motion: const DrawerMotion(),
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          print(">>>>> my data");
                                          var mydata = jsonEncode({
                                            "post_id": myclasspost[i].postId,
                                            "class_id": myclasspost[i].classId,
                                            "title": myclasspost[i].title,
                                            "type": myclasspost[i].type,
                                            "due_date": myclasspost[i].duedate,
                                          });
                                          print(">>>>> my data");
                                          print(mydata);
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => EditSchool(
                                          //       editData: mydata,
                                          //     ),
                                          //   ),
                                          // );
                                        });
                                      },
                                      // borderRadius:
                                      //     BorderRadius.circular(16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.09,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2,
                                                      vertical: 0),
                                              alignment: Alignment.center,
                                              // width: 20 *
                                              //     4, // space for actionPan
                                              decoration: BoxDecoration(
                                                  color: paledarkmain,
                                                  shape: BoxShape.circle),
                                              child: const Icon(Icons.edit,
                                                  size: 20,
                                                  color: Colors.white)),
                                          Divider(
                                            color: Colors.grey[300],
                                            thickness: 1,
                                            height: 1.1,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                left: 10,
                                                top: 15,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  myclasspost[i].postId ==
                                                          selectedclasspost
                                                              ?.postId
                                                      ? Text(
                                                          "You have been viewing this post! Do you want to delete?",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          15),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                      : Text(
                                                          "Are You sure to delete this post?",
                                                          style: TextStyle(
                                                              color: seccolor,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          15),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                color: seccolor,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            14),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )),
                                                      TextButton(
                                                        // 1/9
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          showLoadingDialog(
                                                              context,
                                                              "Loading. . .");

                                                          // showLoadingDialog(
                                                          //     context);
                                                          await delectedclasspost(
                                                              myclasspost[i]
                                                                  .postId);
                                                        },
                                                        child: Text(
                                                          'Confirm',
                                                          style: TextStyle(
                                                              color: darkmain,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          14),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.09,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2,
                                                      vertical: 0),
                                              alignment: Alignment.center,
                                              // width: 20 *
                                              //     4, // space for actionPan
                                              decoration: const BoxDecoration(
                                                  color: Colors.redAccent,
                                                  shape: BoxShape.circle),
                                              child: const Icon(Icons.delete,
                                                  size: 20,
                                                  color: Colors.white)),
                                          Divider(
                                            color: Colors.grey[300],
                                            thickness: 1,
                                            height: 1.1,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              child: ClassPostModel(
                                eachclasspost: myclasspost[i],
                              ),
                            );
                          })),
                )
          : Center(
              child: SpinKitFoldingCube(
                color: paledarkmain,
                size: 50,
              ),
            ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: darkmain,
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => PostingScreen()));
      //   },
      //   label: const Text('Add'),
      //   icon: const Icon(Icons.add),
      // ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkmain,
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: PostingScreen(
                    selectedclass: selectedclass!,
                  )));
        },
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ClassPostModel extends StatefulWidget {
  classpostlistmodel eachclasspost;
  // String classname;
  ClassPostModel({super.key, required this.eachclasspost});

  @override
  State<ClassPostModel> createState() => _ClassPostModelState();
}

class _ClassPostModelState extends State<ClassPostModel> {
  // List<studentlistinClass> studentlist = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: backcolor),
          padding: const EdgeInsets.all(8),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                  backgroundColor: paledarkmain,
                  radius: 25,
                  child: Text(
                    widget.eachclasspost.title[0].toUpperCase(),
                    style: buttonTextStyle,
                  )),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${widget.eachclasspost.title.characters.take(36)}',
                      style: firstTextstyle),
                  Text(
                    widget.eachclasspost.duedate,
                    style: secondTextstyle(Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey[300],
          thickness: 1,
          height: 1.1,
        )
      ],
    );
  }
}
