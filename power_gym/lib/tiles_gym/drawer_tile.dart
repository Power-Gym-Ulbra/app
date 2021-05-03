import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  DrawerTile(this.icon, this.text, this.controller, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32,
                color: controller.page.round() == page ? yellow : white,
              ),
              SizedBox(
                width: 32,
              ),
              Text(
                text,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: controller.page.round() == page ? yellow : white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
