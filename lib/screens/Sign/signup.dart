import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/screens/Sign/signin.dart';
import 'package:class_on_cloud/screens/Sign/signin_teacher.dart';
import 'package:class_on_cloud/screens/Sign/signup_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: SingleChildScrollView(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.flutter_dash_sharp,
                                size: 40,
                                color: darkmain,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Class On Cloud',
                                style: titleTextStyle,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Text(
                              'Sign Up As',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenUtil().setSp(20),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SingUpFieldScreen(
                                          usertype: 1,
                                        )),
                              );
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0, bottom: 8, top: 8),
                                child: ListTile(
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: darkmain,
                                        child: const Image(
                                          height: 25,
                                          width: 25,
                                          image: AssetImage(
                                              'images/schooladmin.jpg'),
                                        ),
                                      )
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: darkmain,
                                      )
                                    ],
                                  ),
                                  title: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      'School Admin',
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(15),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SingUpFieldScreen(
                                          usertype: 2,
                                        )),
                              );
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0, bottom: 8, top: 8),
                                child: ListTile(
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: darkmain,
                                        child: const Image(
                                          height: 25,
                                          width: 25,
                                          image:
                                              AssetImage('images/teacher.png'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: darkmain,
                                      )
                                    ],
                                  ),
                                  title: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      'Teacher',
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(15),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SingUpFieldScreen(
                                          usertype: 3,
                                        )),
                              );
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0, bottom: 8, top: 8),
                                child: ListTile(
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: darkmain,
                                          child: const Image(
                                            height: 25,
                                            width: 25,
                                            image: AssetImage(
                                                'images/student.png'),
                                          ))
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: darkmain,
                                      )
                                    ],
                                  ),
                                  title: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      'Student',
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(15),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SingUpFieldScreen(
                                          usertype: 5,
                                        )),
                              );
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0, bottom: 8, top: 8),
                                child: ListTile(
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: darkmain,
                                          child: const Image(
                                            height: 25,
                                            width: 25,
                                            image:
                                                AssetImage('images/family.png'),
                                          ))
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: darkmain,
                                      )
                                    ],
                                  ),
                                  title: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      'Family Member',
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(15),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: labelTextStyle,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignInFieldScreen()),
                                    );
                                  },
                                  child: Text(
                                    '  Log In',
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 0, 134, 244),
                                        fontSize: ScreenUtil().setSp(14),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                  ))),
        ));
  }
}
