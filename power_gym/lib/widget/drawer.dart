import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/model/user_model.dart';
import 'package:power_gym/tiles_gym/drawer_tile.dart';
import 'package:power_gym/views/intro_page/intro_page.dart';
import 'package:scoped_model/scoped_model.dart';

class MyDrawerGym extends StatefulWidget {
  final PageController pageController;

  MyDrawerGym(this.pageController);

  @override
  _MyDrawerGymState createState() => _MyDrawerGymState();
}

class _MyDrawerGymState extends State<MyDrawerGym> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: gray,
              child: ListView(
                padding: EdgeInsets.only(left: 18, top: 50),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: white,
                          ),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/academia.jpeg',
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gym Master/Nome da academia',
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 30),
                                alignment: Alignment.centerLeft,
                              ),
                              child: Text(
                                'Editar',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: yellow,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Divider(
                      color: white,
                    ),
                  ),
                  DrawerTile(
                    Icons.home,
                    'Home',
                    widget.pageController,
                    0,
                  ),
                  DrawerTile(
                    Icons.group,
                    'Alunos',
                    widget.pageController,
                    1,
                  ),
                  DrawerTile(
                    Icons.school,
                    'Instrutores',
                    widget.pageController,
                    2,
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: gray,
            child: ScopedModel(
              model: UserModel(),
              child: ScopedModelDescendant<UserModel>(
                builder: (context, child, model) {
                  return Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.exit_to_app,
                          color: yellow,
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IntroScreen(),
                            ),
                            (route) => false,
                          );
                          model.signOut();
                        },
                      ),
                      Text(
                        'Sair',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: yellow,
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
