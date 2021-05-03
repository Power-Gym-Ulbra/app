import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InstructorsTab extends StatefulWidget {
  @override
  _InstructorsTabState createState() => _InstructorsTabState();
}

class _InstructorsTabState extends State<InstructorsTab> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        SvgPicture.asset(
          'assets/svg/wave.svg',
          width: size.width,
        ),
        Text('Instrutores'),
      ],
    );
  }
}
