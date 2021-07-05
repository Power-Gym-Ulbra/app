import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/data/categories_data.dart';
import 'package:power_gym/model/categories_model.dart';
import 'package:power_gym/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoriesListStudent extends StatefulWidget {
  const CategoriesListStudent({Key key}) : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesListStudent> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ScopedModelDescendant<CategoriesModel>(
      builder: (context, child, instructorModel) {
        return Center(
          child: instructorModel.isLoading
              ? CircularProgressIndicator()
              : _buildList(instructorModel, size),
        );
      },
    );
  }

  Container _buildList(CategoriesModel categoriesModel, Size size) {
    final categories = categoriesModel.categories;
    if (categories.length == 0) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.network(
                'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/out.svg?alt=media&token=83d7ecf2-32c4-49c8-a8ad-24a4798dc110'),
            SizedBox(height: 10),
            Text(
              'Nenhuma categoria cadastrada',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final categorie = categories[index];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _listTile(categorie, context, size, categoriesModel),
            );
          },
        ),
      );
    }
  }

  Card _listTile(CategoriesData categorie, BuildContext context, Size size,
      CategoriesModel model) {
    return Card(
      color: yellow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 90,
                  width: 12,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 335,
                      height: 25,
                      child: Text(
                        categorie.categorieName.replaceFirst(
                          categorie.categorieName[0],
                          categorie.categorieName[0].toUpperCase(),
                        ),
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: gray,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      categorie.instructor.replaceFirst(
                        categorie.instructor[0],
                        categorie.instructor[0].toUpperCase(),
                      ),
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: gray,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: size.width - 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categorie.timeTable.length,
                        itemBuilder: (context, index) {
                          bool cadastrado = false;

                          categorie.timeTable[index]['students'].forEach(
                            (element) {
                              if (_auth.currentUser.uid == element['id']) {
                                cadastrado = true;
                              } else {
                                cadastrado = false;
                              }
                            },
                          );

                          return Container(
                            height: 35,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text(categorie.timeTable[index]['hour']),
                                    Container(
                                      height: 20,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            gray,
                                          ),
                                        ),
                                        onPressed: cadastrado
                                            ? () {
                                                CategoriesData newCategorie =
                                                    categorie;
                                                List newStudentsList =
                                                    newCategorie
                                                        .timeTable[index]
                                                            ['students']
                                                        .toList();

                                                newStudentsList.removeWhere(
                                                    (element) =>
                                                        element['id'] ==
                                                        _auth.currentUser.uid);

                                                newCategorie.timeTable[index]
                                                        ['students'] =
                                                    newStudentsList;

                                                model
                                                    .registerOrUnscheduleInHour(
                                                        categorie,
                                                        _onSuccessUnschedule,
                                                        _onFail);
                                              }
                                            : () {
                                                CategoriesData newCategorie =
                                                    categorie;
                                                List newStudentsList =
                                                    newCategorie
                                                        .timeTable[index]
                                                            ['students']
                                                        .toList();
                                                newStudentsList.add({
                                                  'name': UserModel.of(context)
                                                      .userData['name'],
                                                  'id': _auth.currentUser.uid
                                                });

                                                newCategorie.timeTable[index]
                                                        ['students'] =
                                                    newStudentsList;

                                                model
                                                    .registerOrUnscheduleInHour(
                                                        categorie,
                                                        _onSuccessRegister,
                                                        _onFail);
                                              },
                                        child: Text(
                                          cadastrado ? 'Desagendar' : 'Agendar',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              color: white,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSuccessRegister() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Agendado com sucesso',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onSuccessUnschedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Desagendado com sucesso',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Algo deu Errado!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
