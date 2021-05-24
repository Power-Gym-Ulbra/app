import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/data/student_data.dart';
import 'package:power_gym/model/student_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'dart:io';

class EditStudent extends StatefulWidget {
  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  File _image;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  String gender;
  bool selected = true;
  DateTime selectedDate;
  ImagePicker picker = ImagePicker();
  PickedFile pickedFile;

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: gray,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Editar',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: gray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor: yellow,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: gray),
          onPressed: () {
            if (nameController.text != '' ||
                _image != null ||
                arguments['student'].gender != gender ||
                selectedDate != null) {
              Alert(
                context: context,
                type: AlertType.warning,
                title: "CUIDADO",
                desc: "Você perdera todas as alterações feitas",
                buttons: [
                  DialogButton(
                    child: Text(
                      'Ok',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: white,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    color: Colors.green,
                  ),
                  DialogButton(
                      child: Text(
                        'Cancelar',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.redAccent)
                ],
              ).show();
            }
          },
        ),
      ),
      body: ScopedModel<StudentModel>(
        model: StudentModel(),
        child: ScopedModelDescendant<StudentModel>(
          builder: (context, child, model) {
            if (model.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                SvgPicture.asset(
                  'assets/svg/wave.svg',
                  width: size.width,
                ),
                Form(
                  key: _formKey,
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: ListView(
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
                                maxRadius: size.height * .07,
                                backgroundImage: pickedFile != null
                                    ? FileImage(_image)
                                    : arguments['student'].image == ""
                                        ? NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
                                          )
                                        : NetworkImage(
                                            "${arguments['student'].image}",
                                          ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * .02),
                          birthday(context),
                          SizedBox(height: size.height * .01),
                          TextFormField(
                            controller: nameController,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: white,
                              ),
                            ),
                            decoration: InputDecoration(
                              hintText: arguments['student'].name,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: white,
                                ),
                              ),
                              hintStyle: TextStyle(
                                color: white,
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: white,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nome inválido ou vazio';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: size.height * .05),
                          Container(
                            height: 34,
                            child: ElevatedButton(
                              onPressed: () {
                                _genderSelect();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  facebook,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Alterar sexo',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * .05),
                          buttonSubmit(model, _image),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Column birthday(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;

    return Column(
      children: [
        Center(
          child: Text(
            'Data de Nascimento',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: yellow,
                fontSize: 18,
              ),
            ),
          ),
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

              setState(() {
                selectedDate = pickedDate;
              });
            });
          },
          child: Text(
            selectedDate == null
                ? arguments['student'].birthDate
                : '${DateFormat('dd/MM/y').format(selectedDate)}',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: selectedDate == null ? facebook : yellow,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _genderSelect() {
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    String nowGender = gender == null ? arguments['student'].gender : gender;
    selected = nowGender == 'masculino' ? true : false;
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "Alterar sexo",
      desc: "O sexo atual é $nowGender",
      buttons: [
        DialogButton(
          child: Text(
            'Masculino',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: selected ? gray : yellow,
              ),
            ),
          ),
          onPressed: () {
            setState(() {
              gender = 'masculino';
              selected = true;
            });
            Navigator.pop(context);
          },
          color: selected ? yellow : gray,
        ),
        DialogButton(
          child: Text(
            'Feminino',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: selected ? yellow : gray,
              ),
            ),
          ),
          onPressed: () {
            setState(() {
              gender = 'feminino';
              selected = false;
            });
            Navigator.pop(context);
          },
          color: selected ? gray : yellow,
        )
      ],
    ).show();
  }

  Container buttonSubmit(StudentModel model, File image) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    return Container(
      height: 48,
      width: 277,
      child: ElevatedButton(
        onPressed: () async {
          StudentData studentData = StudentData();
          studentData.uid = arguments['student'].uid;
          studentData.name = nameController.text == ''
              ? arguments['student'].name
              : nameController.text;
          studentData.email = arguments['student'].email;
          studentData.acad = arguments['student'].acad;
          studentData.gender =
              gender == null ? arguments['student'].gender : gender;
          studentData.image = arguments['student'].image;
          studentData.birthDate = selectedDate == null
              ? arguments['student'].birthDate
              : '${DateFormat('dd/MM/y').format(selectedDate)}';
          if (_image != null) {
            model.uploadFile(_image, arguments['student'].uid);

            Future.delayed(Duration(seconds: 5)).then((value) {
              FirebaseStorage storageReference = FirebaseStorage.instance;
              Reference ref = storageReference
                  .ref()
                  .child('users')
                  .child(arguments['student'].uid)
                  .child('${_image.path}');

              ref.getDownloadURL().then((value) {
                studentData.image = value;
              });
            });

            Future.delayed(Duration(seconds: 8)).then((value) {
              model.updateStudentWithPicture(
                studentData,
                _onSuccess,
                _onFail,
              );
            });
          } else {
            model.updateStudentWithoutPicture(studentData, _onSuccess, _onFail);
          }
        },
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
          'Salvar',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: gray,
            ),
          ),
        ),
      ),
    );
  }

  Future getImage(bool gallery) async {
    final arguments = ModalRoute.of(context).settings.arguments as Map;

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
      } else {
        arguments['student'].image == ""
            ? NetworkImage(
                'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
              )
            : NetworkImage(
                "${arguments['student'].image}",
              );
      }
    });
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Aluno editado com sucesso!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 2),
      ),
    );
    StudentModel();
    Navigator.pop(context);
    Navigator.pop(context);
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
