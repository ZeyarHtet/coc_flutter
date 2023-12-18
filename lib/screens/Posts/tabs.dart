import 'package:class_on_cloud/screens/Posts/post.dart';
import 'package:class_on_cloud/screens/Assignment/assignment.dart';
import 'package:class_on_cloud/screens/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int selectedIndex = 0;

  _page() {
    if (selectedIndex == 0) {
      return const PostScreen();
    } else if (selectedIndex == 1) {
      return const StudentScreen();
    } else if (selectedIndex == 2) {
      return const AssignmentScreen();
    }
  }

  getinitdata() {
    setState(() {
      selectedIndex = 0;
    });
  }

  @override
  void initState() {
    getinitdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: Scaffold(
          body: _page(),
          bottomNavigationBar: BottomNavigationBar(
            // selectedItemColor: mainColor,
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.post_add),
                label: "Post",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Student",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment),
                label: "Assignment",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
