import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget buttonSocialMedia(Size size, Color color, String image, Function navigation) {
  return Container(
    height: size.height * .0423,
    width: size.width * .1886,
    child: ElevatedButton(
      onPressed: navigation,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          color,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          image,
          height: size.width * .0459,
        ),
      ),
    ),
  );
}
