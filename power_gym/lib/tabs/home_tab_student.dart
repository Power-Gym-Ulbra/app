import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeTabStudent extends StatefulWidget {
  @override
  _HomeTabStudentState createState() => _HomeTabStudentState();
}

class _HomeTabStudentState extends State<HomeTabStudent> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        SvgPicture.asset(
          'assets/svg/wave.svg',
          width: size.width,
        ),
        Text('Home Aluno'),
      ],
    );
  }
}