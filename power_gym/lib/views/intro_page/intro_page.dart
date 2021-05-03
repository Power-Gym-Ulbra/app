import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/views/intro_page/widgets/app_bar.dart';
import 'package:power_gym/views/intro_page/widgets/button.dart';
import 'package:power_gym/views/intro_page/widgets/button_social_m%C3%ADdia.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: gray,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              myAppBar(size),
              SizedBox(height: size.height * .13),
              SingleChildScrollView(
                child: Column(
                  children: [
                    myButton(
                      size,
                      'Cadastrar',
                      () {
                        Navigator.pushNamed(context, '/signup');
                      },
                    ),
                    SizedBox(height: size.height * .0423),
                    Text(
                      'Ja é membro?',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: yellow,
                          fontSize: size.height * .0231,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * .0423),
                    myButton(
                      size,
                      'Entrar',
                      () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                    SizedBox(height: size.height * .0723),
                    buttonSocialMedia(
                      size,
                      Colors.white,
                      'assets/svg/google.svg',
                      () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
