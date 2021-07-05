import 'package:flutter/material.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/model/user_model.dart';
import 'package:power_gym/tabs/categories_tab.dart';
import 'package:power_gym/tabs/categories_tab_student.dart';
import 'package:power_gym/tabs/home_tab.dart';
import 'package:power_gym/tabs/instructors_tab.dart';
import 'package:power_gym/tabs/instructors_tab_student.dart';
import 'package:power_gym/tabs/perfil_tab.dart';
import 'package:power_gym/tabs/perfil_tab_student.dart';
import 'package:power_gym/tabs/students_tab.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static List<Widget> _tabsGym = <Widget>[
    HomeTabGym(),
    StudentsTabGym(),
    InstructorsTab(),
    CategoriesTab(),
    PerfilTab(),
  ];

  static List<BottomNavigationBarItem> _itensAcad = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.group),
      label: 'Estudantes',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.school),
      label: 'Instrutores',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.category),
      label: 'Categorias',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  static List<Widget> _tabsStudent = <Widget>[
    InstructorsTabStudent(),
    CategoriesTabStudent(),
    PerfilTabStudent(),
  ];

  static List<BottomNavigationBarItem> _itensStudent = [
    BottomNavigationBarItem(
      icon: Icon(Icons.school),
      label: 'Instrutores',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.category),
      label: 'Categorias',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, userModel) {
        if(userModel.userData['acad'] == null){
          userModel.loadCurrentUser();
        }
        return Scaffold(
          body: Center(
            child: !userModel.isLoaggedIn()
                ? CircularProgressIndicator()
                : userModel.userData['acad'] == null
                    ? CircularProgressIndicator()
                    : userModel.userData['acad'] == '1'
                        ? _tabsGym.elementAt(_selectedIndex)
                        : _tabsStudent.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: white,
            selectedItemColor: gray,
            selectedIconTheme: IconThemeData(
              color: gray,
            ),
            backgroundColor: yellow,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items:
                userModel.userData['acad'] == '1' ? _itensAcad : _itensStudent,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}
