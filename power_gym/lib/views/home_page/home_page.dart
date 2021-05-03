import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/model/user_model.dart';
import 'package:power_gym/tabs/home_tab.dart';
import 'package:power_gym/tabs/home_tab_student.dart';
import 'package:power_gym/tabs/instructors_tab.dart';
import 'package:power_gym/tabs/students_tab.dart';
import 'package:power_gym/widget/drawer.dart';
import 'package:power_gym/widget/drawer_student.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();
  
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (model.userData['acad'] == '1') {
              return PageView(
                controller: _pageController,
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
                    drawer: MyDrawerGym(_pageController),
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
                    body: StudentsTabGym(),
                    floatingActionButton: FloatingActionButton(
                      backgroundColor: yellow,
                      child: Icon(
                        Icons.add,
                        color: gray,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/createStudent');
                      },
                    ),
                    drawer: MyDrawerGym(_pageController),
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
                    body: InstructorsTab(),
                    drawer: MyDrawerGym(_pageController),
                  ),
                ],
              );
            } else {
              return PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Scaffold(
                    backgroundColor: gray,
                    appBar: AppBar(
                      centerTitle: true,
                      title: Text(
                        model.userData['name'],
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
                    drawer: MyDrawerStudent(_pageController),
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
