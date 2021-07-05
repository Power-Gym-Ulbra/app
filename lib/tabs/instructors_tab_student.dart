import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/widget/instructors_tab_students.dart';

class InstructorsTabStudent extends StatefulWidget {
  const InstructorsTabStudent({Key key}) : super(key: key);

  @override
  _InstructorsTabStudentState createState() => _InstructorsTabStudentState();
}

class _InstructorsTabStudentState extends State<InstructorsTabStudent> {
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
                child: InstructorsListStudent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
