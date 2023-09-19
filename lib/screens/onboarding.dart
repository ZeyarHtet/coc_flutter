import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/screens/Sign/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController pageController = PageController();

  int pageindex = 0;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      pageindex = index;
                    });
                  },
                  itemCount: pagelist.length,
                  itemBuilder: (context, index) => Onboard(
                    image: pagelist[index].image,
                    header: pagelist[index].header,
                    aim: pagelist[index].aim,
                  ),
                ),
              ),
              Container(
                // color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    pageindex == 2
                        ? const SizedBox(
                            width: 50,
                            height: 40,
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupScreen()),
                              );
                            },
                            child: SizedBox(
                              width: 50,
                              height: 40,
                              child: Center(
                                child: Text(
                                  'Skip',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: darkmain,
                                      fontSize: ScreenUtil().setSp(15),
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                    Row(
                      children: [
                        ...List.generate(
                            pagelist.length,
                            (index) => Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Dotindicator(
                                      selected: index == pageindex),
                                )),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        pageindex == 2
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupScreen()),
                              )
                            : pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease);
                      },
                      child: CircleAvatar(
                        backgroundColor: darkmain,
                        radius: 30,
                        child: Text(
                          pageindex == 2 ? 'Start' : 'Next',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(15),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Dotindicator extends StatelessWidget {
  const Dotindicator({Key? key, required this.selected}) : super(key: key);
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 8,
      width: selected ? 20 : 8,
      decoration: BoxDecoration(
          color: selected ? darkmain : Colors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }
}

List<Onboard> pagelist = [
  const Onboard(
    image: 'images/class.png',
    header: "Learning",
    aim: "A vision of providing life-transforming learning experiences",
  ),
  const Onboard(
    image: 'images/class.png',
    header: "Teaching",
    aim: "Comfort virtual teaching tools",
  ),
  const Onboard(
    image: 'images/class.png',
    header: "Parenting",
    aim: "Instant providing status results of your children",
  ),
];

class Onboard extends StatelessWidget {
  const Onboard(
      {Key? key, required this.image, required this.aim, required this.header})
      : super(key: key);

  final String image, header, aim;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: 250,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          header,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          aim,
          textAlign: TextAlign.center,
          style: inputTextStyle,
        )
      ],
    );
  }
}
