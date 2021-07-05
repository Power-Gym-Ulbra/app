import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/widget/categories_list.dart';

class HomeTabGym extends StatefulWidget {
  @override
  _HomeTabGymState createState() => _HomeTabGymState();
}

class _HomeTabGymState extends State<HomeTabGym> {
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
                child: CategoriesList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
