import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/data/categories_data.dart';
import 'package:power_gym/model/categories_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({Key key}) : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  bool select = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ScopedModelDescendant<CategoriesModel>(
      builder: (context, child, instructorModel) {
        instructorModel.loadCategories();

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

            return GestureDetector(
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(12.0),
                      title: Text('Excluir categoria?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('CANCELAR'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text('EXCLUIR'),
                          onPressed: () {
                            categoriesModel.deleteCategorie(
                              categorie.id,
                              _onSuccess,
                              _onFail,
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _listTile(categorie, context, size),
              ),
            );
          },
        ),
      );
    }
  }

  Card _listTile(
    CategoriesData categorie,
    BuildContext context,
    Size size,
  ) {
    return Card(
      color: yellow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Container(
                  width: 70,
                  child: ListView.builder(
                    itemCount: categorie.timeTable.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Text(
                            categorie.timeTable[index]['hour'],
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: gray,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            height: 2,
                            width: 25,
                            color: gray,
                          )
                        ],
                      );
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 25,
                      width: 180,
                      child: Text(
                        categorie.categorieName.replaceFirst(
                          categorie.categorieName[0],
                          categorie.categorieName[0].toUpperCase(),
                        ),
                        overflow: TextOverflow.ellipsis,
                              softWrap: false,
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
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    gray,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.all(12.0),
                        content: Container(
                          height: size.height * .8,
                          width: size.width,
                          child: ListView(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: categorie.timeTable.length,
                                itemBuilder: (context, index1) {
                                  return Column(
                                    children: [
                                      _mycard(size, categorie, index1),
                                      SizedBox(height: 10),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  'Alunos',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stack _mycard(Size size, CategoriesData categorie, int index1) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: yellow,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          height: 110,
          width: size.width - 50,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              categorie.timeTable[index1]['hour'],
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: gray,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: gray,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          height: 90,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: categorie.timeTable[index1]['students'].length,
              itemBuilder: (context, index) {
                return Text(
                  categorie.timeTable[index1]['students'][index]['name'],
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: white,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Categoria excluida com sucesso!',
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
