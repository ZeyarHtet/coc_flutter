import 'package:class_on_cloud/model/constant.dart';
import 'package:class_on_cloud/model/component.dart';
import 'package:class_on_cloud/model/model.dart';
import 'package:class_on_cloud/screens/addstudent.dart';
import 'package:class_on_cloud/screens/drawer.dart';
import 'package:class_on_cloud/screens/studentdetail.dart';
import 'package:class_on_cloud/screens/testscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  bool searchBoolean = false;
  bool ready = false;
  bool submitted = false;
  bool show = false;
  TextEditingController emailcontroller = TextEditingController();
  // TextEditingController classnamecontroller = TextEditingController();

  List<studentlistinClass> studentlist = [];
  // List<classlistmodel> myclass = [];

  classlistmodel? selectedclass;

  final emialValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address'),
  ]);

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var result = getstudentapi();
    setState(() {
      var mineclass = prefs.getString('selectedClass');
      var students = prefs.getString("selectedstudentList");
      students == null
          ? null
          : studentlist = studentlistinClass.decode(students);
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
        automaticallyImplyLeading: searchBoolean ? false : true,
        title: searchBoolean
            ? searchTextField()
            : selectedclass == null
                ? Text("Home", style: appbarTextStyle(maincolor))
                : Text(
                    selectedclass!.title,
                    style: appbarTextStyle(maincolor),
                  ),
        actions: searchBoolean
            ? [
                IconButton(
                    splashRadius: 3,
                    icon: const Icon(
                      Icons.clear,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        searchBoolean = false;
                      });
                    })
              ]
            : [
                IconButton(
                    splashRadius: 3,
                    icon: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        searchBoolean = true;
                      });
                    })
              ],
      ),
      drawer: searchBoolean
          ? null
          : SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: DrawerScreen(
                pagename: selectedclass == null ? 'Home' : selectedclass!.title,
              )),
      body: ready
          ? selectedclass == null
              ? Center(
                  child: Text(
                    "You need to select class to view its students",
                    style: labelTextStyle,
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: studentlist.isEmpty
                      ? Center(
                          child: Text(
                            'There is no student in this class yet.',
                            style: labelTextStyle,
                          ),
                        )
                      : ListView.builder(
                          itemCount: studentlist.length,
                          itemBuilder: ((context, i) {
                            return Studentmodel(
                              studentdata: studentlist[i],
                              selectedclass: selectedclass!,
                            );
                          })),
                )
          : Center(
              child: SpinKitFoldingCube(
                color: paledarkmain,
                size: 50,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkmain,
        onPressed: ready
            ? selectedclass == null
                ? () {
                    showToast("pls select a class to add student!", 'red');
                  }
                : () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddStudentScreen(
                                  selectedclass: selectedclass,
                                )));
                  }
            : null,
        child: const Icon(Icons.add, size: 30),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: ready
      //       ? myclass.isEmpty
      //           ? () {
      //               showToast("You need class to add student! ", 'green');
      //             }
      //           : () {
      //               showDialog(
      //                 context: context,
      //                 builder: (BuildContext context) {
      //                   return StatefulBuilder(builder: (context, setState) {
      //                     return Form(
      //                       key: key,
      //                       child: AlertDialog(
      //                         backgroundColor: backcolor,
      //                         insetPadding:
      //                             const EdgeInsets.symmetric(horizontal: 10),
      //                         contentPadding:
      //                             const EdgeInsets.fromLTRB(8, 0, 8, 8),
      //                         titlePadding:
      //                             const EdgeInsets.fromLTRB(8, 8, 8, 0),
      //                         shape: const RoundedRectangleBorder(
      //                             borderRadius:
      //                                 BorderRadius.all(Radius.circular(10.0))),
      //                         title: Column(
      //                           children: [
      //                             Row(
      //                               mainAxisAlignment:
      //                                   MainAxisAlignment.spaceBetween,
      //                               children: [
      //                                 Text(
      //                                   'Add New Student',
      //                                   style: TextStyle(
      //                                       color: darkmain,
      //                                       fontSize: ScreenUtil().setSp(20),
      //                                       fontWeight: FontWeight.w500),
      //                                 ),
      //                                 GestureDetector(
      //                                   onTap: () {
      //                                     Navigator.pop(context);
      //                                   },
      //                                   child: const Icon(
      //                                     Icons.close,
      //                                     color:
      //                                         Color.fromARGB(255, 28, 28, 28),
      //                                     size: 30,
      //                                   ),
      //                                 ),
      //                               ],
      //                             ),
      //                             const Divider(
      //                               color: Colors.grey,
      //                               thickness: 1,
      //                             ),
      //                           ],
      //                         ),
      //                         content: Column(
      //                           children: [
      //                             SingleChildScrollView(
      //                               child: SizedBox(
      //                                 width: MediaQuery.of(context).size.width,
      //                                 height:
      //                                     MediaQuery.of(context).size.width - 80,
      //                                 child: Column(
      //                                   children: [
      //                                     Row(
      //                                       children: [
      //                                         Text(
      //                                           'Student Email',
      //                                           style: labelTextStyle,
      //                                         ),
      //                                       ],
      //                                     ),
      //                                     Container(
      //                                       padding: const EdgeInsets.only(top: 10),
      //                                       child: TextFormField(
      //                                         controller: emailcontroller,
      //                                         textCapitalization:
      //                                             TextCapitalization.words,
      //                                         autovalidateMode: submitted
      //                                             ? AutovalidateMode.always
      //                                             : AutovalidateMode.disabled,
      //                                         validator: emialValidator,
      //                                         decoration: const InputDecoration(
      //                                           contentPadding:
      //                                               EdgeInsets.all(15.0),
      //                                           filled: true,
      //                                           fillColor: Colors.white,
      //                                           // hintText: 'Enter your email address',
      //                                           border: OutlineInputBorder(
      //                                             borderRadius: BorderRadius.all(
      //                                               Radius.circular(10.0),
      //                                             ),
      //                                             borderSide: BorderSide.none,
      //                                           ),
      //                                         ),
      //                                         style: labelTextStyle,
      //                                         cursorColor: seccolor,
      //                                       ),
      //                                     ),
      //                                     const SizedBox(
      //                                       height: 20,
      //                                     ),
      //                                     Row(
      //                                       children: [
      //                                         Text(
      //                                           'Class name',
      //                                           style: labelTextStyle,
      //                                         ),
      //                                       ],
      //                                     ),
      //                                     Container(
      //                                       padding: const EdgeInsets.only(top: 10),
      //                                       child: DropdownButtonFormField(
      //                                         value: initialtitle,
      //                                         isExpanded: true,
      //                                         items: titlelist
      //                                             .map((item) =>
      //                                                 DropdownMenuItem<String>(
      //                                                   value: item,
      //                                                   child: Text(
      //                                                       '${item.characters.take(36)}'),
      //                                                 ))
      //                                             .toList(),
      //                                         onChanged: (newValue) async {
      //                                           setState(() {
      //                                             for (var i = 0;
      //                                                 i < myclass.length;
      //                                                 i++) {
      //                                               if (myclass[i].title ==
      //                                                   newValue.toString()) {
      //                                                 initialtitleId =
      //                                                     myclass[i].classId;
      //                                                 print(
      //                                                     ">>>>inserted ID >>> $initialtitleId");
      //                                               }
      //                                             }
      //                                             initialtitle =
      //                                                 newValue.toString();
      //                                           });
      //                                         },
      //                                         decoration: const InputDecoration(
      //                                           contentPadding:
      //                                               EdgeInsets.all(15.0),
      //                                           filled: true,
      //                                           fillColor: Colors.white,
      //                                           // hintText: 'Enter your email address',
      //                                           border: OutlineInputBorder(
      //                                             borderRadius: BorderRadius.all(
      //                                               Radius.circular(10.0),
      //                                             ),
      //                                             borderSide: BorderSide.none,
      //                                           ),
      //                                         ),
      //                                         style: labelTextStyle,
      //                                       ),
      //                                     ),
      //                                     Padding(
      //                                       padding:
      //                                           const EdgeInsets.only(top: 20.0),
      //                                       child: SizedBox(
      //                                           width: MediaQuery.of(context)
      //                                                   .size
      //                                                   .width -
      //                                               30,
      //                                           height: MediaQuery.of(context)
      //                                                   .size
      //                                                   .height *
      //                                               0.06,
      //                                           child: MaterialButton(
      //                                             elevation: 0,
      //                                             shape: RoundedRectangleBorder(
      //                                               borderRadius:
      //                                                   BorderRadius.circular(6),
      //                                             ),
      //                                             color: darkmain,
      //                                             onPressed: () async {
      //                                               setState(() {
      //                                                 submitted = true;
      //                                               });
      //                                               if (key.currentState!
      //                                                   .validate()) {
      //                                                 setState(() {
      //                                                   getloading = true;
      //                                                 });
      //                                                 var returncode =
      //                                                     await addstudentapi(
      //                                                         emailcontroller.text,
      //                                                         initialtitleId);
      //                                                 print(
      //                                                     '><><ret><> $returncode');
      //                                                 if (returncode == '200') {
      //                                                   // ignore: use_build_context_synchronously
      //                                                   Navigator.pop(context);
      //                                                   // ignore: use_build_context_synchronously
      //                                                   Navigator.push(
      //                                                     context,
      //                                                     MaterialPageRoute(
      //                                                         builder: (context) =>
      //                                                             const StudentScreen()),
      //                                                   );
      //                                                   emailcontroller.clear();
      //                                                 }
      //                                                 setState(() {
      //                                                   getloading = false;
      //                                                   submitted = false;
      //                                                 });
      //                                               }
      //                                             },
      //                                             child: getloading
      //                                                 ? const SpinKitDoubleBounce(
      //                                                     color: Colors.white,
      //                                                     size: 15.0,
      //                                                   )
      //                                                 : Text(
      //                                                     'Create',
      //                                                     style: TextStyle(
      //                                                         color: maincolor,
      //                                                         fontSize: ScreenUtil()
      //                                                             .setSp(20),
      //                                                         fontWeight:
      //                                                             FontWeight.w500),
      //                                                   ),
      //                                           )),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     );
      //                   });
      //                 },
      //               );
      //             }
      //       : null,
      //
      // ),
    );
  }
}

class Studentmodel extends StatefulWidget {
  studentlistinClass studentdata;
  classlistmodel selectedclass;
  Studentmodel(
      {super.key, required this.studentdata, required this.selectedclass});

  @override
  State<Studentmodel> createState() => _StudentmodelState();
}

class _StudentmodelState extends State<Studentmodel> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentDetailScreen(
                    studentdata: widget.studentdata,
                    selectedclass: widget.selectedclass,
                  )),
        );
      },
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.11,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.all(8),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                    backgroundColor: paledarkmain,
                    radius: 25,
                    child: Text(
                      widget.studentdata.username[0].toUpperCase(),
                      style: buttonTextStyle,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.studentdata.username, style: firstTextstyle),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
            height: 1.1,
          )
        ],
      ),
    );
  }
}
