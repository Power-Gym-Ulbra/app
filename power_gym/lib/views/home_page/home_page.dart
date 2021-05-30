import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/data/student_data.dart';
import 'package:power_gym/model/student_model.dart';
import 'package:power_gym/model/user_model.dart';
import 'package:power_gym/tabs/home_tab.dart';
import 'package:power_gym/tabs/home_tab_student.dart';
import 'package:power_gym/tabs/instructors_tab.dart';
import 'package:power_gym/tabs/students_tab.dart';
import 'package:power_gym/widget/drawer.dart';
import 'package:power_gym/widget/drawer_student.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageController = PageController();
  DateTime selectedDate;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String gender = 'masculino';
  bool selected = true;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (model.userData['acad'] == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (model.userData['acad'] == '1') {
              return ScopedModel(
                model: StudentModel(),
                child: ScopedModelDescendant<StudentModel>(
                  builder: (context, child, model) {
                    return PageView(
                      controller: pageController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Scaffold(
                          backgroundColor: gray,
                          appBar: AppBar(
                            centerTitle: true,
                            title: Text(
                              'Home',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: gray,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            elevation: 0,
                            backgroundColor: yellow,
                          ),
                          body: HomeTabGym(),
                          drawer: MyDrawerGym(pageController),
                        ),
                        Scaffold(
                          backgroundColor: gray,
                          appBar: AppBar(
                            centerTitle: true,
                            title: Text(
                              'Alunos',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: gray,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            elevation: 0,
                            backgroundColor: yellow,
                          ),
                          body: ScopedModelDescendant<StudentModel>(
                            builder: (context, child, model) {
                              return StudentsTabGym();
                            },
                          ),
                          drawer: MyDrawerGym(pageController),
                        ),
                        Scaffold(
                          backgroundColor: gray,
                          appBar: AppBar(
                            centerTitle: true,
                            title: Text(
                              'Instrutores',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: gray,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            elevation: 0,
                            backgroundColor: yellow,
                          ),
                          floatingActionButton: FloatingActionButton(
                            backgroundColor: yellow,
                            child: Icon(
                              Icons.add,
                              color: gray,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/createInstructor');
                            },
                          ),
                          body: InstructorsTab(),
                          drawer: MyDrawerGym(pageController),
                        ),
                      ],
                    );
                  },
                ),
              );
            } else {
              return PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Scaffold(
                    backgroundColor: gray,
                    appBar: AppBar(
                      centerTitle: true,
                      title: Text(
                        'Student',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: gray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      elevation: 0,
                      backgroundColor: yellow,
                    ),
                    body: HomeTabStudent(),
                    drawer: MyDrawerStudent(pageController),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
