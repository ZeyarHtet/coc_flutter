import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:class_on_cloud/screens/addfamilymember.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FamilyaddingErrorScreen extends StatefulWidget {
  var result;
  FamilyaddingErrorScreen({super.key, required this.result});

  @override
  State<FamilyaddingErrorScreen> createState() =>
      _FamilyaddingErrorScreenState();
}

class _FamilyaddingErrorScreenState extends State<FamilyaddingErrorScreen> {
  List<Studentparenterror> errorresult = [];
  bool ready = false;
  bool allblank = false;
//   [{Email: student1@gmail.com, Data: {NotFound: [nem@io.com, studi@io.dom], NotParent: []}}, {Email: student2@gmail.com, Data: {NotFound:
// [name@io.com], NotParent: []}}]
  static const _kFontFam = 'Student_error';
  static const String? _kFontPkg = null;

  static const IconData ok_circled =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData info_circled =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData attention =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData help_circled =
      IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  getData() async {
    // var result = Studentparenterror.fromJson(widget.result["Data"]);
    for (var element in widget.result) {
      var eacheleme = Studentparenterror.fromJson(element["Data"]);
      print('ehchlelemeng>>> ${eacheleme.notParent.runtimeType}');
      errorresult.add(eacheleme);
    }
    // errorresult =
    //     Studentparenterror.fromJson(widget.result) as List<Studentparenterror>;
    // print('>>>listdata $errorresult');
    setState(() {
      ready = true;
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
      // backgroundColor: Backcolor,
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: backcolor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddFamilymemberScreen()),
            ),
          ),
          title: Text("Errors in addin Family Members",
              style: TextStyle(
                color: seccolor,
                fontSize: ScreenUtil().setSp(15),
                fontWeight: FontWeight.w500,
              ))),
      body: !ready
          ? const Center(
              child: Text("loading"),
            )
          : Container(
              color: backcolor,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: errorresult.length,
                  itemBuilder: (context, i) {
                    if (errorresult[i].notFound.isEmpty &&
                        errorresult[i].notParent.isEmpty) {
                      allblank = true;
                    }
                    return allblank
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.result[i]['Email'],
                                style: labelTextStyle,
                              ),
                              errorresult[i].notFound.isEmpty
                                  ? Container()
                                  : ErrorCard(
                                      leftborder: Colors.orange,
                                      bgcolor: const Color(0xffFDEEDC),
                                      leadingicon: help_circled,
                                      emaillist:
                                          errorresult[i].notFound.toString(),
                                      title: 'Emails Not Registered'),
                              errorresult[i].notParent.isEmpty
                                  ? Container()
                                  : ErrorCard(
                                      leftborder: Colors.blue,
                                      bgcolor: const Color(0xffDAEAF1),
                                      leadingicon: info_circled,
                                      emaillist:
                                          errorresult[i].notParent.toString(),
                                      title: 'Not Parents'),
                              const Padding(
                                padding: EdgeInsets.only(top: 10.0, bottom: 10),
                                child: MySeparator(),
                              ),
                            ],
                          );
                  }),
            ),
    );
  }
}
