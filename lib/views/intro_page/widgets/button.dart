import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';

Widget myButton(Size size, String textButton, Function navigation) {
  return Container(
    height: size.height * .062,
    width: size.width * .357,
    child: ElevatedButton(
      onPressed: navigation,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          yellow,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
      child: Text(
        textButton,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: size.height * .01793,
            fontWeight: FontWeight.bold,
            color: gray,
          ),
        ),
      ),
    ),
  );
}
