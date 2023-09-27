import 'package:class_on_cloud/main.dart';
import 'package:class_on_cloud/model/api.dart';
import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:class_on_cloud/screens/blogdetail.dart';
import 'package:class_on_cloud/screens/createpost.dart';
import 'package:class_on_cloud/screens/drawer.dart';
import 'package:class_on_cloud/screens/newposting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournelScreen extends StatefulWidget {
  const JournelScreen({super.key});

  @override
  State<JournelScreen> createState() => _JournelScreenState();
}

class _JournelScreenState extends State<JournelScreen> {
  bool isready = false;
  bool searchBoolean = false;

  classlistmodel? selectedclass;
  List<EachGetpost> allpost = [];
  List<blogpostCompo> blogss = [];

  String? getimage(List<PostDetail> detail) {
    for (var i = 0; i < detail.length; i++) {
      if (detail[i].type == '2') {
        return detail[i].content;
      }
    }
    return null;
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mineclass = prefs.getString('selectedClass');
    mineclass == null
        ? selectedclass = null
        : selectedclass = classlistmodel.singledecode(mineclass);
    print('<<<<SElectedone>>>${selectedclass?.title}');
    if (selectedclass != null) {
      var result = await getPostApi(selectedclass!.classId);
      print('${result['posts']}');
      List posts = result["posts"];
    }
    print(">>>>>>>>>>>>> typesadof");

    setState(() {
      isready = true;
    });
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
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
        automaticallyImplyLeading: searchBoolean ? false : true,
        title: searchBoolean
            ? searchTextField()
            : selectedclass == null
                ? Text("Home", style: appbarTextStyle(maincolor))
                : Text(
                    selectedclass!.title,
                    style: appbarTextStyle(maincolor),
                  ),
        actions: searchBoolean
            ? [
                IconButton(
                    splashRadius: 3,
                    icon: const Icon(
                      Icons.clear,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        searchBoolean = false;
                      });
                    })
              ]
            : [
                IconButton(
                    splashRadius: 3,
                    icon: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        searchBoolean = true;
                      });
                    })
              ],
      ),
      drawer: searchBoolean
          ? null
          : SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: DrawerScreen(
                pagename: selectedclass == null ? 'Home' : selectedclass!.title,
              )),
      body: isready
          ? selectedclass == null
              ? Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('images/dashboard.png'),
                        Text(
                          "You've not selected any class yet!",
                          style: inputTextStyle,
                        ),
                      ],
                    ),
                  ),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: blogss.length,
                            itemBuilder: (_, i) {
                              return GestureDetector(
                                onTap: () {
                                  {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: BlogDetailScreen(
                                              thepost: allpost[i],
                                            )));
                                  }
                                },
                                child: blogss[i],
                              );
                            }),
                      )
                    ],
                  ),
                )
          : Center(
              child: SpinKitFoldingCube(
                color: darkmain,
                size: 50,
              ),
            ),
      floatingActionButton: !isready || selectedclass == null
          ? Container()
          : FloatingActionButton(
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
