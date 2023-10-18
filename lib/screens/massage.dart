import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:class_on_cloud/screens/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../model/api.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );
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
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: darkmain,
        iconTheme: IconThemeData(
          color: maincolor,
          size: 30,
        ),
        title: Text("Chat", style: appbarTextStyle(maincolor)),
      ),
      drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: DrawerScreen(
            pagename: 'Chat',
          )),
      body: Chat(
          messages: _messages, onSendPressed: _handleSendPressed, user: _user),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: 'id',
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }
}
