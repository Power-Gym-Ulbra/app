import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/data/instructor_data.dart';
import 'package:power_gym/model/instructor_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';

import 'dart:io';

class InstructorsTab extends StatefulWidget {
  @override
  _InstructorsTabState createState() => _InstructorsTabState();
}

class _InstructorsTabState extends State<InstructorsTab> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  ImagePicker picker = ImagePicker();
  PickedFile pickedFile;
  File _image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        width: double.infinity,
        height: double.infinity,
        child: ScopedModel(
          model: InstructorModel(),
          child: ScopedModelDescendant<InstructorModel>(
            builder: (context, child, model) {
              return Column(
                children: [
                  SvgPicture.asset(
                    'assets/svg/wave.svg',
                    width: size.width,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: model.instructors.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            model.instructors[index].name,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: white,
                              ),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage:
                                model.instructors[index].image == ""
                                    ? NetworkImage(
                                        'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
                                      )
                                    : NetworkImage(
                                        "${model.instructors[index].image}",
                                      ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: white,
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        backgroundColor: yellow,
                        child: Icon(
                          Icons.add,
                          color: gray,
                          size: 30,
                        ),
                        onPressed: () {
                          Alert(
                              context: context,
                              closeIcon: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  _image = null;
                                  nameController.text = '';
                                  genderController.text = '';
                                  dateController.text = '';
                                  Navigator.pop(context);
                                },
                              ),
                              title: "Cadastrar Instrutor",
                              content: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          child: Stack(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  getImage(true);
                                                },
                                                icon: Icon(Icons.add_a_photo),
                                                color: gray,
                                              ),
                                            ],
                                          ),
                                          maxRadius: size.height * .05,
                                          backgroundImage: pickedFile != null
                                              ? FileImage(_image)
                                              : NetworkImage(
                                                  'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
                                                ),
                                        ),
                                      ],
                                    ),
                                    TextFormField(
                                      controller: dateController,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.calendar_today),
                                        labelText: 'Nascimento ex:01/01/2021',
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty ||
                                            value.length < 10 ||
                                            value[2] != '/' ||
                                            value[5] != '/') {
                                          return 'Digite uma data válida';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.account_circle),
                                        labelText: 'Nome',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Nome inválido ou vazio';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: genderController,
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.accessibility,
                                        ),
                                        labelText: 'Genêro',
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Digite um genero válido';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              buttons: [
                                DialogButton(
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      InstructorData instructorData =
                                          InstructorData();
                                      instructorData.name = nameController.text;
                                      instructorData.gender =
                                          genderController.text;
                                      instructorData.image = '';
                                      instructorData.birthday =
                                          dateController.text;

                                      if (_image != null) {
                                        model.uploadFile(
                                            _image, nameController.text);

                                        Future.delayed(Duration(seconds: 5))
                                            .then((value) {
                                          FirebaseStorage storageReference =
                                              FirebaseStorage.instance;
                                          Reference ref = storageReference
                                              .ref()
                                              .child('instructors')
                                              .child(nameController.text)
                                              .child('${_image.path}');

                                          ref.getDownloadURL().then((value) {
                                            instructorData.image = value;
                                          });
                                        });

                                        Future.delayed(Duration(seconds: 10))
                                            .then((value) {
                                          model.saveInstructor(instructorData,
                                              _onSuccess, _onFail);
                                        });
                                      } else {
                                        model.saveInstructor(
                                          instructorData,
                                          _onSuccess,
                                          _onFail,
                                        );
                                      }

                                      nameController.text = '';
                                      genderController.text = '';
                                      dateController.text = '';

                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    "Cadastrar",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              ]).show();
                        },
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              );
            },
          ),
        ));
  }

  Future getImage(bool gallery) async {
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

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
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
