import 'dart:convert';
import 'dart:io';

import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/api.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:class_on_cloud/screens/Sign/signup.dart';
import 'package:class_on_cloud/screens/home.dart';
import 'package:class_on_cloud/screens/testscreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:class_on_cloud/model/component.dart';

class SignInFieldScreen extends StatefulWidget {
  // int usertype;
  SignInFieldScreen({super.key});

  @override
  State<SignInFieldScreen> createState() => _SignInFieldScreenState();
}

class _SignInFieldScreenState extends State<SignInFieldScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool showloading = false;
  bool submitted = false;
  bool pass = true;
  // String usertype = '';
  String url = '';
  String body = '';
  final _formKey = GlobalKey<FormState>();

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address'),
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(6, errorText: 'Password must be at least 6 digits long'),
  ]);

  // getUsertype() {
  //   widget.usertype == 2
  //       ? usertype = 'Teacher'
  //       : widget.usertype == 3
  //           ? usertype = 'Student'
  //           : usertype = "Family Member";
  // }

  validate() async {
    url = "$domain/api/auth/signin";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var params = {
        "email": emailcontroller.text.trim(),
        "password": passwordcontroller.text,
      };
      await dio
          .post(
        url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        }),
        data: jsonEncode(params),
      )
          .then((res) async {
        var result = res.data;
        if (res.statusCode == 200) {
          if (result["returncode"] == "200") {
            setState(() {
              submitted = false;
            });
            await prefs.setBool('Signedin', true);
            await prefs.setString("token", result['token']);
            await prefs.setString('userid', result['data']['userid']);
            await prefs.setInt('usertype', result['data']['usertype']);
            await prefs.setString('username', result['data']['username']);
            await prefs.setString('email', result['data']['email']);
            result['data']['profile_pic'] != null
                ? await prefs.setString(
                    'profile_pic', result['data']['profile_pic'])
                : await prefs.setString('profile_pic', '');
            result['data']['contact'] != null
                ? await prefs.setString('contact', result['data']['contact'])
                : await prefs.setString('contact', '');
            result['data']['phone'] != null
                ? await prefs.setString('phone', result['data']['phone'])
                : await prefs.setString('phone', '');
            result['data']['remark'] != null
                ? await prefs.setString('remark', result['data']['remark'])
                : await prefs.setString('remark', '');

            emailcontroller.clear();
            passwordcontroller.clear();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => NavbarScreen(
                          screenindex: 0,
                        )),
                (route) => false);
          } else {
            showToast(result['message'], 'red');
          }

          setState(() {
            showloading = false;
          });
        } else {
          showToast(res.statusCode, "red");
          setState(() {
            showloading = false;
          });
        }
      });
    } catch (e) {
      print(e);
      showToast("Error >>>>> $e", "red");
      setState(() {
        showloading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
              child: SingleChildScrollView(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Log In',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(20),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 5),
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
                                  autocorrect: false,
                                  autovalidateMode: submitted
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.disabled,
                                  validator: emailValidator,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.text,
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
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.blue),
                                    ),
                                  ),
                                  style: inputTextStyle,
                                  cursorColor: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 5),
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
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.words,
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
                                    // hintText: 'Enter your email address',
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
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.blue),
                                    ),
                                  ),
                                  style: inputTextStyle,
                                  cursorColor: Colors.black,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Navigator.pushReplacement(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           const SignupScreen()),
                                        // );
                                      },
                                      child: Text(
                                        'Forgot password?',
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 134, 244),
                                            fontSize: ScreenUtil().setSp(14),
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  child: MaterialButton(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    color: darkmain,
                                    // textColor: Colors.white,
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        submitted = true;
                                      });
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          showloading = true;
                                        });
                                        validate();
                                      }
                                    },
                                    child: showloading
                                        ? const SpinKitWave(
                                            color: Colors.white,
                                            size: 15.0,
                                          )
                                        : Text(
                                            'Log In',
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
                                      "Don't have an account?",
                                      style: labelTextStyle,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignupScreen()),
                                        );
                                      },
                                      child: Text(
                                        ' Create',
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 134, 244),
                                            fontSize: ScreenUtil().setSp(14),
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 20),
                                child: Divider(
                                  color: darkmain,
                                ),
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: Image(
                                              image: AssetImage(
                                                  'images/google_logo.png')),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Log In with Google',
                                          style: TextStyle(
                                            color: darkmain,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                            ]),
                      ))),
            )),
      ),
    );
  }
}
