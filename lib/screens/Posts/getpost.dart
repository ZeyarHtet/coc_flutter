import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:class_on_cloud/model/api.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:class_on_cloud/screens/Classes/edit_class.dart';
import 'package:class_on_cloud/screens/Posts/edit_post.dart';
import 'package:class_on_cloud/screens/Posts/minioimagetest.dart';
import 'package:class_on_cloud/screens/Posts/postinside.dart';
import 'package:class_on_cloud/screens/classposting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/component.dart';
import '../../model/constant.dart';
import '../drawer.dart';
import '../home.dart';
import 'createpost.dart';

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
              type: classpostList[i]['type'] == null
                  ? ""
                  : classpostList[i]['type'].toString(),
              duedate: classpostList[i]['due_date'],
              postDetails: classpostList[i]["post_details"],
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
    print(">>>>>>> getpost");
    super.initState();
  }

  Future<void> _refresh() {
    return Future.delayed(const Duration(seconds: 2));
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
                      child: RefreshIndicator(
                        onRefresh: _refresh,
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
                                              "class_id":
                                                  myclasspost[i].classId,
                                              "title": myclasspost[i].title,
                                              "type": myclasspost[i].type,
                                              "due_date":
                                                  myclasspost[i].duedate,
                                            });
                                            print(">>>>> my data");
                                            print(mydata);
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType
                                                    .bottomToTop,
                                                child: EditPost(
                                                  editData: mydata,
                                                  selectedclass: selectedclass!,
                                                ),
                                              ),
                                            );
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                                  color:
                                                                      seccolor,
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
                            }),
                      )),
                )
          : Center(
              child: SpinKitFoldingCube(
                color: paledarkmain,
                size: 50,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkmain,
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: PostingScreen(
                selectedclass: selectedclass!,
              ),
              // child: ImageFromMinio(),
            ),
          );
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
  void initState() {
    getImage();
    super.initState();
  }

  List imagesList = [];
  getImage() {
    imagesList = [];
    for (var i = 0; i < widget.eachclasspost.postDetails.length; i++) {
      // if (widget.eachclasspost.postDetails[i]["type"] == 2) {
      print(">>>>>>> $i");
      imagesList.add(
          "$miniohttp/coc/post_images/${widget.eachclasspost.postDetails[i]["content"]}");
      // }
    }
    print(imagesList);
    print(">>>>>>>>>>>>>>>>>> image list");
    // print(widget.eachclasspost.postDetails);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: paledarkmain,
                      radius: 23,
                      child: Text(
                        widget.eachclasspost.title == ""
                            ? ""
                            : widget.eachclasspost.title[0].toUpperCase(),
                        // "",
                        style: buttonTextStyle,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.eachclasspost.title.characters.take(36)}',
                          style: firstTextstyle,
                        ),
                        Text(
                          DateFormat("dd-MM-yyyy").format(
                              DateTime.parse(widget.eachclasspost.duedate)),
                          style: secondTextstyle(Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
                imagesList.isNotEmpty ? _buildListItemPostImage() : Container(),
              ],
            ),
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
            height: 1.1,
          )
        ],
      ),
    );
  }

  Widget _buildListItemPostImage() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostInside()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: (imagesList.length == 1)
            ? forOnePhoto()
            : (imagesList.length < 4)
                ? forTwoAndThreePhoto()
                : forFourAndMorePhoto(),
      ),
    );
  }

  Widget forOnePhoto() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: (MediaQuery.of(context).size.width) / 2,
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      child: CachedNetworkImage(
        imageUrl: imagesList[0],
        placeholder: (context, url) => Container(),
        errorWidget: (context, url, error) => Container(),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget forTwoAndThreePhoto() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: (MediaQuery.of(context).size.width) / 2,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 1.25),
              height: (MediaQuery.of(context).size.width) / 2,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: CachedNetworkImage(
                imageUrl: imagesList[0],
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => Container(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          (imagesList.length == 2)
              ? Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 1.25),
                    height: (MediaQuery.of(context).size.width) / 2,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imagesList[1],
                      placeholder: (context, url) => Container(),
                      errorWidget: (context, url, error) => Container(),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Expanded(
                  child: Container(
                    height: (MediaQuery.of(context).size.width) / 2,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 1.25, left: 1.25),
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                            ),
                            child: CachedNetworkImage(
                              imageUrl: imagesList[2],
                              placeholder: (context, url) => Container(),
                              errorWidget: (context, url, error) => Container(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 1.25, left: 1.25),
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                            ),
                            child: CachedNetworkImage(
                              imageUrl: imagesList[2],
                              placeholder: (context, url) => Container(),
                              errorWidget: (context, url, error) => Container(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget forFourAndMorePhoto() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: (MediaQuery.of(context).size.width) / 2,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: (MediaQuery.of(context).size.width) / 2,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 1.25, right: 1.25),
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: imagesList[0],
                        placeholder: (context, url) => Container(),
                        errorWidget: (context, url, error) => Container(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 1.25, right: 1.25),
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: imagesList[2],
                        placeholder: (context, url) => Container(),
                        errorWidget: (context, url, error) => Container(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: (MediaQuery.of(context).size.width) / 2,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 1.25, left: 1.25),
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: imagesList[1],
                        placeholder: (context, url) => Container(),
                        errorWidget: (context, url, error) => Container(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 1.25, left: 1.25),
                          width: MediaQuery.of(context).size.width / 2,
                          height: (MediaQuery.of(context).size.width) / 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                          ),
                          child: CachedNetworkImage(
                            imageUrl: imagesList[3],
                            placeholder: (context, url) => Container(),
                            errorWidget: (context, url, error) => Container(),
                            fit: BoxFit.cover,
                          ),
                        ),
                        (imagesList.length > 4)
                            ? Positioned(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 1.25, left: 1.25),
                                  width: MediaQuery.of(context).size.width / 2,
                                  height:
                                      (MediaQuery.of(context).size.width * 3) /
                                          8,
                                  decoration: BoxDecoration(
                                    color: Colors.black54.withOpacity(0.5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      imageNumber(imagesList.length),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  imageNumber(images) {
    int number = images - 4;
    return "+${number.toString()}";
  }
}
