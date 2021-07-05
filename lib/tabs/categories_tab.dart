import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/data/categories_data.dart';
import 'package:power_gym/model/categories_model.dart';
import 'package:power_gym/model/instructor_model.dart';
import 'package:power_gym/widget/categories_list.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({Key key}) : super(key: key);

  @override
  _CategoriesTabState createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  List selectedTime = [];
  String selectedIntructorName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: yellow,
          child: Icon(
            Icons.add,
            color: gray,
            size: 30,
          ),
          onPressed: () {
            nameController.text = '';
            selectedTime = [];
            showDialog(
              context: context,
              builder: (_) {
                return ScopedModelDescendant<CategoriesModel>(
                  builder: (context, child, categoriesModel) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(12.0),
                      content: Container(
                        height: size.height * .4,
                        width: 300,
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            children: [
                              Center(
                                child: Text(
                                  'Cadastrar Categoria',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: gray,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              _selectHours(categoriesModel),
                              SizedBox(height: 5),
                              Container(
                                height: selectedTime.isEmpty ? 0 : 20,
                                width: size.width,
                                child: selectedTime.isNotEmpty
                                    ? _listHours()
                                    : null,
                              ),
                              TextFormField(
                                controller: nameController,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: gray,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Nome da categoria',
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: yellow,
                                  )),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: gray,
                                    ),
                                  ),
                                  hintStyle:
                                      TextStyle(color: gray, fontSize: 12),
                                  prefixIcon: Icon(
                                    Icons.fitness_center,
                                    color: gray,
                                    size: 18,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nome inválido ou vazio';
                                  }
                                  return null;
                                },
                              ),
                              _selectInstructor(categoriesModel),
                            ],
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('CANCELAR'),
                          onPressed: () {
                            Navigator.pop(context);
                            nameController.text = '';
                            selectedIntructorName = '';

                            selectedTime = [];
                          },
                        ),
                        TextButton(
                          child: Text('SALVAR'),
                          onPressed: () {
                            if (selectedTime.isNotEmpty &&
                                selectedIntructorName != null &&
                                _formKey.currentState.validate()) {
                              CategoriesData categoriesData = CategoriesData();
                              categoriesData.categorieName =
                                  nameController.text;
                              categoriesData.instructor = selectedIntructorName;
                              categoriesData.timeTable = selectedTime;

                              categoriesModel.saveCategorie(
                                categoriesData,
                                _onSuccess,
                                _onFail,
                              );
                              selectedIntructorName = null;
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return (AlertDialog(
                                    title:
                                        Text('Você está esquecendo algum dado'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      )
                                    ],
                                  ));
                                },
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
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

  ListView _listHours() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: selectedTime.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blueAccent,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  selectedTime[index]['hour'],
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 2,
            )
          ],
        );
      },
    );
  }

  Container _selectHours(CategoriesModel model) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: gray,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 16),
              Container(
                child: Icon(
                  Icons.schedule,
                  color: gray,
                  size: 18,
                ),
              ),
              SizedBox(width: 16),
              Container(
                child: Text(
                  'Horários',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: gray,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              ).then(
                (pickedTime) {
                  if (pickedTime == null) {
                    return;
                  }

                  selectedTime.add({
                    'hour': pickedTime.format(context).toString(),
                    'students': []
                  });
                  model.pickTime(pickedTime.format(context).toString());
                },
              );
            },
            child: Text(
              selectedTime.isEmpty ? 'Novo Horário' : '+1 Horário',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: selectedTime == null ? facebook : yellow,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _selectInstructor(CategoriesModel categoriesModel) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: gray,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 16),
              Container(
                child: Icon(
                  Icons.school,
                  color: gray,
                  size: 18,
                ),
              ),
              SizedBox(width: 16),
              Container(
                child: Text(
                  'Instrutor',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: gray,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return ScopedModelDescendant<InstructorModel>(
                    builder: (context, child, model) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.all(12.0),
                        content: Container(
                          height: 300,
                          width: 300,
                          child: ListView.builder(
                            itemCount: model.instructors.length,
                            itemBuilder: (context, index) {
                              final instructor = model.instructors[index];
                              return ListTile(
                                onTap: () {
                                  selectedIntructorName = instructor.name;

                                  categoriesModel.pickIntructor(
                                    instructor.name,
                                  );
                                  Navigator.pop(context);
                                },
                                title: Text(
                                  instructor.name.replaceFirst(
                                    instructor.name[0],
                                    instructor.name[0].toUpperCase(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: Text(
              selectedIntructorName != null
                  ? selectedIntructorName
                  : 'Novo Instrutor',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: selectedTime == null ? facebook : yellow,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Categoria criada com sucesso!',
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
          'Algo deu errado!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
