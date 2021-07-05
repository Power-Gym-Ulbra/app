import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/widget/categories_list_student.dart';

class CategoriesTabStudent extends StatefulWidget {
  const CategoriesTabStudent({Key key}) : super(key: key);

  @override
  _CategoriesTabStudentState createState() => _CategoriesTabStudentState();
}

class _CategoriesTabStudentState extends State<CategoriesTabStudent> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: gray,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/svg/wave.svg',
                width: size.width,
              ),
              Expanded(
                child: CategoriesListStudent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
