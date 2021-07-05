import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:power_gym/constants.dart';

Widget myAppBar(Size size) {
  return Container(
    child: Stack(
      children: [
        topAppBar(size),
        Padding(
          padding: const EdgeInsets.only(top: 140),
          child: bottomAppBar(size),
        ),
      ],
    ),
  );
}

Widget topAppBar(Size size) {
  return Container(
    height: size.height * .18,
    width: double.infinity,
    color: yellow,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 115,
          child: Image.asset('assets/images/logo.png'),
        ),
      ],
    ),
  );
}

Widget bottomAppBar(Size size) {
  return SvgPicture.asset(
    'assets/svg/wave.svg',
    width: size.width,
  );
}
