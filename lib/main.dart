    import 'package:class_on_cloud/screens/home.dart';
import 'package:class_on_cloud/screens/Sign/signup.dart';
import 'package:class_on_cloud/screens/onboarding.dart';
import 'package:class_on_cloud/screens/testscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: "Poppins",
          iconTheme: const IconThemeData(color: Colors.white)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool? signedin;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      signedin = prefs.getBool('Signedin');
    });
    print(">>>><<<<< Signedin $signedin");
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: ((context, child) {
          return signedin == null
              ? const OnboardingScreen()
              : signedin == false
                  ? const SignupScreen()
                  : NavbarScreen(
                      screenindex: 0,
                    );
        }));
  }
}
