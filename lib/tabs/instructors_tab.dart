import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/data/instructor_data.dart';
import 'package:power_gym/model/instructor_model.dart';
import 'package:power_gym/widget/instructors_list.dart';
import 'package:scoped_model/scoped_model.dart';

import 'dart:io';

class InstructorsTab extends StatefulWidget {
  @override
  _InstructorsTabState createState() => _InstructorsTabState();
}

class _InstructorsTabState extends State<InstructorsTab> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  DateTime selectedDate;
  bool selected = true;
  String gender = 'Masculino';
  ImagePicker picker = ImagePicker();
  PickedFile pickedFile;
  File _image;

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
            showDialog(
              context: context,
              builder: (context) {
                return ScopedModelDescendant<InstructorModel>(
                  builder: (context, child, instructorModel) {
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
                                  'Cadastrar Instrutor',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: gray,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Column(
                                children: [
                                  CircleAvatar(
                                    child: Stack(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            getImage(true, instructorModel);
                                          },
                                          icon: Icon(Icons.add_a_photo),
                                          color: gray,
                                        ),
                                      ],
                                    ),
                                    maxRadius: size.height * .04,
                                    backgroundImage: _image != null
                                        ? FileImage(_image)
                                        : NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
                                          ),
                                  ),
                                ],
                              ),
                              _birthday(instructorModel),
                              TextFormField(
                                controller: nameController,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: gray,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Nome',
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
                                    Icons.person,
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
                              _genderSelect(instructorModel),
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
                            selectedDate = null;
                            selected = true;
                            gender = 'Masculino';
                            _image = null;
                          },
                        ),
                        TextButton(
                          child: Text('SALVAR'),
                          onPressed: () {
                            if (instructorModel.date == null) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                    title: Text(
                                      'Escolha uma data de nascimento',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (_formKey.currentState.validate()) {
                              InstructorData instructorData = InstructorData();
                              instructorData.name = nameController.text;
                              instructorData.gender = gender;
                              instructorData.image = '';
                              instructorData.birthday =
                                  '${DateFormat('dd/MM/y').format(selectedDate)}';

                              if (_image != null) {
                                instructorModel.uploadFile(
                                    _image, instructorData.name);

                                Future.delayed(Duration(seconds: 10)).then(
                                  (value) {
                                    FirebaseStorage storageReference =
                                        FirebaseStorage.instance;
                                    Reference ref = storageReference
                                        .ref()
                                        .child('instructors')
                                        .child(nameController.text)
                                        .child('${_image.path}');

                                    ref.getDownloadURL().then((value) {
                                      print(value);
                                      instructorData.image = value;
                                    });
                                  },
                                );

                                Future.delayed(Duration(seconds: 12)).then(
                                  (value) {
                                    instructorModel
                                        .saveInstructor(
                                      instructorData,
                                      _onSuccess,
                                      _onFail,
                                    )
                                        .whenComplete(() {
                                      nameController.text = '';
                                      selectedDate = null;
                                      selected = true;
                                      gender = 'Masculino';
                                      _image = null;
                                    });
                                  },
                                );
                                Navigator.pop(context);
                              } else {
                                instructorModel
                                    .saveInstructor(
                                  instructorData,
                                  _onSuccess,
                                  _onFail,
                                )
                                    .whenComplete(() {
                                  nameController.text = '';
                                  selectedDate = null;
                                  selected = true;
                                  gender = 'Masculino';
                                  _image = null;
                                });
                                Navigator.pop(context);
                              }
                            }
                          },
                        )
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
                child: InstructorsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _genderSelect(InstructorModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Row(
            children: [
              Checkbox(
                value: selected ? true : false,
                shape: CircleBorder(),
                onChanged: (value) {
                  model.newGender(true, 'Masculino');

                  gender = model.gender;
                  selected = model.selected;
                },
              ),
              Text(
                'Masculino',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: gray,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              Checkbox(
                value: selected ? false : true,
                shape: CircleBorder(),
                onChanged: (value) {
                  model.newGender(false, 'Feminino');

                  gender = model.gender;
                  selected = model.selected;
                },
              ),
              Text(
                'Feminino',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: gray,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _birthday(InstructorModel model) {
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              Container(
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: gray,
                  size: 18,
                ),
              ),
              SizedBox(width: 12),
              Container(
                child: Text(
                  'Data de nascimento',
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
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                locale: Locale('pt', 'BR'),
              ).then((pickedDate) {
                if (pickedDate == null) {
                  return;
                }

                model.pickDate(pickedDate);
                selectedDate = model.date;
              });
            },
            child: Text(
              selectedDate == null
                  ? '${DateFormat('dd/MM/y').format(DateTime.now())}'
                  : '${DateFormat('dd/MM/y').format(selectedDate)}',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: selectedDate == null ? facebook : yellow,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getImage(bool gallery, InstructorModel model) async {
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }

    if (pickedFile != null) {
      model.newImage(File(pickedFile.path));
      _image = model.image;
    }
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Instrutor criado com sucesso!',
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
