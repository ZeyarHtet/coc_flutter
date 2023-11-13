import 'package:class_on_cloud/main.dart';
import 'package:class_on_cloud/model/api.dart';
import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:class_on_cloud/screens/Classes/class.dart';
import 'package:class_on_cloud/screens/drawer.dart';
import 'package:class_on_cloud/screens/Posts/getpost.dart';
import 'package:class_on_cloud/screens/journal.dart';
import 'package:class_on_cloud/screens/massage.dart';
import 'package:class_on_cloud/screens/Progress/progress.dart';
import 'package:class_on_cloud/screens/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/constant.dart';

class NavbarScreen extends StatefulWidget {
  int screenindex;
  NavbarScreen({super.key, required this.screenindex});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // var instruder = prefs.getString('UserData');
    // instruder == null?  null :

    name = prefs.getString('username')!;
    email = prefs.getString('email')!;
    token = prefs.getString('token')!;
    userid = prefs.getString('userid')!;
    usertype = prefs.getInt('usertype')!;
    profileUrl = prefs.getString('profile_pic')!;
    contact = prefs.getString('contact')!;
    phone = prefs.getString('phone')!;
    remark = prefs.getString('remark')!;
    // classdata = prefs.getStringList('classdata');
    // var mineclass = prefs.getString('selectedClass');
    // print(">><mineclass ${mineclass.toString()}");
    setState(() {
      // mineclass == null
      //     ? selectedclass = null
      //     : selectedclass = classlistmodel.singledecode(mineclass);
      // // print('<<<<classdata>>>${classdata?.length}');
      // print('<<<<SElectedone>>>${selectedclass?.title}');

      isready = true;
    });
  }

  // TextEditingController classnamecontroller = TextEditingController();

  // TextEditingController customgradecontroller = TextEditingController();
  // final GlobalKey<FormState> key = GlobalKey<FormState>();

  // bool show = false;
  // bool getloading = false;

  static const _kFontFam = 'Outline_Icon';
  static const String? _kFontPkg = null;

  static const IconData home_outline =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData comment =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData people_outline =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData chart_pie_outline =
      IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  bool isready = false;
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  // static const _kFontFam = 'Drawer_new';
  // static const String? _kFontPkg = null;

  // // static const IconData user =
  // //     IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  // static const IconData home =
  //     IconData(0xf015, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  // static const IconData inbox =
  //     IconData(0xf01c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  // static const IconData chart_pie =
  //     IconData(0xf200, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  // static const IconData comment_alt =
  //     IconData(0xf27a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  // static const IconData school =
  //     IconData(0xf549, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // int screenindex = 0;

  bool searchBoolean = false;
  List<Widget> screens = [
    // JournelScreen(),
    ClassesScreen(),
    MessageScreen(),
    StudentScreen(),
    ProgressScreen()
  ];
  List<GButton> tablist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   centerTitle: true,
      //   backgroundColor: darkmain,
      //   iconTheme: IconThemeData(
      //     color: maincolor,
      //     size: 30,
      //   ),
      //   automaticallyImplyLeading: searchBoolean ? false : true,
      //   title: searchBoolean
      //       ? searchTextField()
      //       : selectedclass == null
      //           ? Text("Home", style: appBarTitleTextStyle)
      //           : Text(
      //               selectedclass!.title,
      //               style: appBarTitleTextStyle,
      //             ),
      //   actions: searchBoolean
      //       ? [
      //           IconButton(
      //               splashRadius: 3,
      //               icon: const Icon(
      //                 Icons.clear,
      //                 size: 30,
      //               ),
      //               onPressed: () {
      //                 setState(() {
      //                   searchBoolean = false;
      //                 });
      //               })
      //         ]
      //       : [
      //           IconButton(
      //               splashRadius: 3,
      //               icon: const Icon(
      //                 Icons.search,
      //                 size: 30,
      //               ),
      //               onPressed: () {
      //                 setState(() {
      //                   searchBoolean = true;
      //                 });
      //               })
      //         ],
      // ),
      // drawer: searchBoolean
      //     ? null
      //     : SizedBox(
      //         width: MediaQuery.of(context).size.width * 0.8,
      //         child: DrawerScreen(
      //           pagename: 'Home',
      //         )),
      body: screens[widget.screenindex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: GNav(
            tabBorderRadius: 30,
            onTabChange: (value) {
              setState(() {
                widget.screenindex = value;
              });
            },
            selectedIndex: widget.screenindex,
            // curve: Curves.ease,
            gap: 10,
            color: Colors.black,
            activeColor: darkmain,
            iconSize: 22,
            tabBackgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            tabs: const [
              GButton(
                icon: home_outline,
                text: 'Home',
              ),
              GButton(
                icon: comment,
                text: 'Message',
              ),
              GButton(
                icon: people_outline,
                text: 'Students',
              ),
              GButton(
                icon: chart_pie_outline,
                text: 'Progress',
              )
            ]),
      ),
    );
  }
}

// class CustomSearch extends SearchDelegate {
//   @override
//   Widget? buildLeading(BuildContext context) => Container();

//   @override
//   Widget buildResults(BuildContext context) => Container();

//   @override
//   Widget buildSuggestions(BuildContext context) => Container();

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return null;

//     // ignore: todo
//     // TODO: implement buildActions
//     // throw UnimplementedError();
//   }
// }
