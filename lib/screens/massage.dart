import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:class_on_cloud/screens/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/api.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  bool searchBoolean = false;
  bool ready = false;
  classlistmodel? selectedclass;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var mineclass = prefs.getString('selectedClass');
      print(">><mineclass ${mineclass.toString()}");
      mineclass == null
          ? selectedclass = null
          : selectedclass = classlistmodel.singledecode(mineclass);
      setState(() {
        ready = true;
      });
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
      //           ? Text("Message", style: appBarTitleTextStyle)
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
      //           pagename: 'Message',
      //         )),
    );
  }
}
