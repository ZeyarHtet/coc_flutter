import 'package:cached_network_image/cached_network_image.dart';
import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:class_on_cloud/screens/School/school.dart';
import 'package:class_on_cloud/screens/Sign/signup.dart';
import 'package:class_on_cloud/screens/Classes/class.dart';
import 'package:class_on_cloud/screens/home.dart';
import 'package:class_on_cloud/screens/massage.dart';
import 'package:class_on_cloud/screens/Progress/progress.dart';
import 'package:class_on_cloud/screens/student.dart';
import 'package:class_on_cloud/screens/teacherprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

String trimstring(String str) {
  if (str.length >= 25) {
    return '${str.characters.take(20)}';
  }
  return str;
}

class DrawerScreen extends StatefulWidget {
  String pagename;
  DrawerScreen({super.key, required this.pagename});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  static const _kFontFam = 'Outline_Drawer';
  static const String? _kFontPkg = null;

  static const IconData cog_outline =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData logout =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData help =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData building =
      IconData(0xf0f7, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData folder_open_empty =
      IconData(0xf115, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  // static const IconData school =
  //     IconData(0xf549, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  static const kFontFam = 'Outline_Icon';
  static const String? kFontPkg = null;

  static const IconData home_outline =
      IconData(0xe800, fontFamily: kFontFam, fontPackage: kFontPkg);

  classlistmodel? selectedclass;
  bool isready = false;

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mineclass = prefs.getString('selectedClass');
    mineclass == null
        ? selectedclass = null
        : selectedclass = classlistmodel.singledecode(mineclass);
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
    return SafeArea(
      child: isready
          ? Drawer(
              child: Container(
                color: Colors.white,
                // padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: const TeacherDetailScreen()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [darkmain, paledarkmain],
                                  stops: const [0.2, 1],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight,
                                  tileMode: TileMode.mirror)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 30, 0, 20),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  child: profileUrl.isEmpty
                                      ? Text(
                                          name[0].toUpperCase(),
                                          style: buttonTextStyle,
                                        )
                                      : CachedNetworkImage(
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                  colorFilter: ColorFilter.mode(
                                                      trandarkmain,
                                                      BlendMode.colorBurn)),
                                            ),
                                          ),
                                          imageUrl:
                                              '$miniohttp/coc/user_profile/$profileUrl',
                                          placeholder: (context, url) =>
                                              SpinKitCubeGrid(
                                            size: 5,
                                            color: paledarkmain,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                ),
                                // CircleAvatar(
                                //   backgroundColor: darkmain,
                                //   radius: 25,
                                //   child: profileUrl == ''
                                //       ? Text(
                                //           name[0].toUpperCase(),
                                //           style: buttonTextStyle,
                                //         )
                                //       : CachedNetworkImage(
                                //           imageBuilder: (context, imageProvider) =>
                                //               Container(
                                //             decoration: BoxDecoration(
                                //               shape: BoxShape.circle,
                                //               image: DecorationImage(
                                //                 image: imageProvider,
                                //                 fit: BoxFit.cover,
                                //               ),
                                //             ),
                                //           ),
                                //           imageUrl:
                                //               "https://static.vecteezy.com/system/resources/thumbnails/009/901/419/small_2x/illustration-graphic-of-template-logo-design-wolf-head-silver-color-free-vector.jpg",
                                //           placeholder: (context, url) =>
                                //               SpinKitCubeGrid(
                                //             size: 5,
                                //             color: paledarkmain,
                                //           ),
                                //           errorWidget: (context, url, error) =>
                                //               const Icon(Icons.error),
                                //         ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(name, style: profileTextstyle),
                                      Text(
                                        trimstring(email),
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                200, 255, 255, 255),
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      MenuStyle(
                          icon: home_outline,
                          label: selectedclass == null
                              ? "Home"
                              : selectedclass!.title,
                          pagename: widget.pagename,
                          context: context,
                          choseclass: selectedclass,
                          destination: NavbarScreen(
                            screenindex: 0,
                          )),

                      // MenuStyle(
                      //     icon: comment_alt,
                      //     label: "Message",
                      //     pagename: widget.pagename,
                      //     context: context,
                      //     destination: const MessageScreen()),
                      // MenuStyle(
                      //     icon: Icons.person,
                      //     label: "Students",
                      //     pagename: widget.pagename,
                      //     context: context,
                      //     destination: const StudentScreen()),
                      // MenuStyle(
                      //     icon: chart_pie,
                      //     label: "Progress",
                      //     pagename: widget.pagename,
                      //     context: context,
                      //     destination: const ProgressScreen()),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                        child: Row(
                          children: [
                            Text(
                              ' Manage',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: ScreenUtil().setSp(15),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MenuStyle(
                          icon: folder_open_empty,
                          label: "Classes",
                          pagename: widget.pagename,
                          context: context,
                          destination: const ClassesScreen()),
                      MenuStyle(
                          icon: building,
                          label: "School",
                          pagename: widget.pagename,
                          context: context,
                          destination: const SchoolScreen()
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                        child: Row(
                          children: [
                            Text(
                              ' Options',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: ScreenUtil().setSp(15),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MenuStyle(
                          icon: cog_outline,
                          label: "Settings",
                          pagename: widget.pagename,
                          context: context,
                          destination: NavbarScreen(
                            screenindex: 0,
                          )),
                      MenuStyle(
                          icon: logout,
                          label: "Logout",
                          pagename: widget.pagename,
                          context: context,
                          destination: NavbarScreen(
                            screenindex: 0,
                          )),
                      MenuStyle(
                          icon: help,
                          label: "Help and Feedback",
                          pagename: widget.pagename,
                          context: context,
                          destination: NavbarScreen(
                            screenindex: 0,
                          )),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: SpinKitFoldingCube(
                color: paledarkmain,
                size: 50,
              ),
            ),
    );
  }
}

class MenuStyle extends StatelessWidget {
  BuildContext context;
  IconData icon;
  String label;
  String pagename;
  Widget destination;
  classlistmodel? choseclass;
  MenuStyle(
      {super.key,
      required this.icon,
      required this.label,
      required this.pagename,
      required this.context,
      required this.destination,
      this.choseclass});

  logoutfun() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    final success = await prefs.setBool('Signedin', false);
    print(">>>>>>>logout - $success");
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pagename == label
            ? Navigator.pop(context)
            : label == 'Logout'
                ? logoutdialog(context, "Are you sure to log out?", logoutfun)
                : Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => destination,
                    ));
      },
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 5.0,
          right: 15,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              color: pagename == label ? trandarkmain : Colors.white,
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(30))),
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                choseclass != null
                    ? CircleAvatar(
                        backgroundColor: paledarkmain,
                        radius: 15,
                        child: Text(
                          choseclass!.title[0].toUpperCase(),
                          style: TextStyle(
                              color: darkmain,
                              fontSize: ScreenUtil().setSp(14),
                              fontWeight: FontWeight.w400),
                        ))
                    : Icon(
                        icon,
                        color: pagename == label ? darkmain : seccolor,
                        size: 20,
                      ),
              ],
            ),
            title: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                trimstring(label),
                style: TextStyle(
                  color: pagename == label ? darkmain : seccolor,
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
