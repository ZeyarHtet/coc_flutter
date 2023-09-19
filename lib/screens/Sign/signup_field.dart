import 'dart:convert';
import 'dart:io';
// import 'dart:ffi';
import 'package:class_on_cloud/main.dart';
import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/api.dart';
import 'package:class_on_cloud/screens/Sign/signin.dart';
import 'package:class_on_cloud/screens/Sign/signin_teacher.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:class_on_cloud/model/component.dart';

class SingUpFieldScreen extends StatefulWidget {
  int usertype;
  SingUpFieldScreen({super.key, required this.usertype});

  @override
  State<SingUpFieldScreen> createState() => _SingUpFieldScreenState();
}

class _SingUpFieldScreenState extends State<SingUpFieldScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String usertype = '';
  int usertypenum = 2;
  String url = "";
  bool showloading = false;
  bool submitted = false;
  bool pass = true;
  bool confirmpass = true;
  String password = '';
  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address'),
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(6, errorText: 'Password must be at least 6 digits long'),
  ]);

  getUsertype() {
    widget.usertype == 2
        ? usertype = 'Teacher'
        : widget.usertype == 3
            ? usertype = 'Student'
            : usertype = "Family Member";
  }

  signingUp() async {
    var url = '$domain/api/auth/signup';
    try {
      // print(
      //     ' body >>>>> ${emailcontroller.text} >>>>> ${widget.usertype.toInt()}');
      // await http.post(
      //   Uri.parse(url),
      //   headers: {"Content-Type": "application/x-www-form-urlencoded"},
      //   body: {
      //     "email": emailcontroller.text,
      //     "password": passwordcontroller.text,
      //     "usertype": usertypenum.toString(),
      //     "username": usernamecontroller.text
      //   },
      // )
      var params = {
        "email": emailcontroller.text.trim(),
        "password": passwordcontroller.text,
        "usertype": usertypenum.toString(),
        "username": usernamecontroller.text.trim()
      };
      await dio
          .post(
        url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        }),
        data: jsonEncode(params),
      )
          .then((res) {
        var result = res.data;
        // print(">>>><<<<< ${result['returncode']}");
        if (res.statusCode == 200) {
          if (result['returncode'] == '200') {
            emailcontroller.clear();
            passwordcontroller.clear();
            usernamecontroller.clear();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInFieldScreen()),
            );
          } else {
            showToast(result['message'], 'red');
          }
        } else {
          showToast(res.statusCode, "red");
        }
      });
    } catch (e) {
      showToast("Error >>>>> $e", "red");
    }

    setState(() {
      showloading = false;
    });
  }

  @override
  void initState() {
    getUsertype();
    usertypenum = widget.usertype;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: _formKey,
        child: Scaffold(
            backgroundColor: Colors.grey[200],
            body: SafeArea(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(children: [
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
                          Text('Class On Cloud', style: titleTextStyle),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Register As ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(18),
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            usertype,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(18),
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 5),
                            child: Text(
                              "Username",
                              style: labelTextStyle,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: TextFormField(
                          controller: usernamecontroller,
                          autofocus: false,
                          autovalidateMode: submitted
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                          validator: RequiredValidator(
                              errorText: "Username cannot be blank"),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            filled: true,
                            fillColor: Colors.white,
                            // hintText: 'Enter your email address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.blue),
                            ),
                          ),
                          style: labelTextStyle,
                          cursorColor: seccolor,
                          // decoration: const InputDecoration(
                          //   contentPadding: EdgeInsets.all(20.0),
                          //   filled: true,
                          //   fillColor: Colors.white,
                          //   // hintText: 'Enter your email address',
                          //   border: OutlineInputBorder(
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(10.0),
                          //     ),
                          //     borderSide: BorderSide.none,
                          //   ),
                          //   focusedBorder: OutlineInputBorder(
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(10.0),
                          //     ),
                          //     borderSide:
                          //         BorderSide(width: 1, color: Colors.blue),
                          //   ),
                          // ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 5),
                            child: Text(
                              "Email Address",
                              style: labelTextStyle,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: TextFormField(
                          controller: emailcontroller,
                          autofocus: false,
                          autovalidateMode: submitted
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                          validator: emailValidator,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            filled: true,
                            fillColor: Colors.white,
                            // hintText: 'Enter your email address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.blue),
                            ),
                          ),
                          style: inputTextStyle,
                          cursorColor: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 5),
                            child: Text(
                              "Password",
                              style: labelTextStyle,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: TextFormField(
                          controller: passwordcontroller,
                          obscureText: pass,
                          autofocus: false,
                          autovalidateMode: submitted
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                          // validator: passwordValidator,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    pass = !pass;
                                  });
                                },
                                splashRadius: 2,
                                icon: pass
                                    ? Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.grey[800],
                                      )
                                    : Icon(
                                        Icons.visibility_off,
                                        color: Colors.grey[800],
                                      )),
                            contentPadding: const EdgeInsets.all(15.0),
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.blue),
                            ),
                          ),
                          // onChanged: (val) {
                          //   setState(() {
                          //     password = val;
                          //   });
                          // },
                          style: inputTextStyle,
                          cursorColor: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 5),
                            child: Text(
                              "Confirm Password",
                              style: labelTextStyle,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: TextFormField(
                          controller: confirmpasswordcontroller,
                          obscureText: confirmpass,
                          autofocus: false,
                          autovalidateMode: submitted
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                          validator: (value) => MatchValidator(
                                  errorText: 'passwords do not match')
                              .validateMatch(value!, passwordcontroller.text),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    confirmpass = !confirmpass;
                                  });
                                },
                                splashRadius: 2,
                                icon: confirmpass
                                    ? Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.grey[800],
                                      )
                                    : Icon(
                                        Icons.visibility_off,
                                        color: Colors.grey[800],
                                      )),
                            contentPadding: const EdgeInsets.all(15.0),
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.blue),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          style: inputTextStyle,
                          cursorColor: Colors.black,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: MaterialButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            color: darkmain,
                            // textColor: Colors.white,
                            onPressed: () async {
                              setState(() {
                                submitted = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  showloading = true;
                                });
                                signingUp();
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  showloading = false;
                                });
                              }
                            },
                            child: showloading
                                ? const SpinKitWave(
                                    color: Colors.white,
                                    size: 15.0,
                                  )
                                : Text(
                                    'Create',
                                    style: buttonTextStyle,
                                  ),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12),
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
                                    color:
                                        const Color.fromARGB(255, 0, 134, 244),
                                    fontSize: ScreenUtil().setSp(14),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                        child: Divider(
                          color: darkmain,
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: MaterialButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            // padding: const EdgeInsets.all(5),
                            color: Color.fromARGB(51, 104, 158, 244),
                            // textColor: Colors.white,
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: Image(
                                      image:
                                          AssetImage('images/google_logo.png')),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text('Create with Google',
                                    style: darkmainbuttonTextStyle),
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 30,
                      )
                    ]),
                  )),
            )),
      ),
    );
  }
}
