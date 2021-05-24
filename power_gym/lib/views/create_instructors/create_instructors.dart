import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/data/instructor_data.dart';
import 'package:power_gym/model/instructor_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'dart:io';

class CreateInstructors extends StatefulWidget {
  @override
  _CreateInstructorsState createState() => _CreateInstructorsState();
}

class _CreateInstructorsState extends State<CreateInstructors> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  String gender = 'masculino';
  bool selected = true;
  DateTime selectedDate;
  File _image;
  ImagePicker picker = ImagePicker();
  PickedFile pickedFile;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: gray,
      appBar: AppBar(
        backgroundColor: yellow,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Cadastrar',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: gray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: ScopedModel<InstructorModel>(
        model: InstructorModel(),
        child: ScopedModelDescendant<InstructorModel>(
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
                                maxRadius: size.height * .04,
                                backgroundImage: pickedFile != null
                                    ? FileImage(_image)
                                    : NetworkImage(
                                        'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
                                      ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * .01),
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
                              hintText: 'Nome',
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
                          _genderSelect(),
                          SizedBox(height: size.height * .09),
                          buttonSubmit(model),
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

  Container buttonSubmit(InstructorModel model) {
    return Container(
      height: 48,
      width: 277,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState.validate() && selectedDate != null) {
            InstructorData instructorData = InstructorData();
            instructorData.name = nameController.text;
            instructorData.gender = gender;
            instructorData.image = '';
            instructorData.birthday =
                '${DateFormat('dd/MM/y').format(selectedDate)}';

            if (_image != null) {
              model.uploadFile(_image, instructorData.name);

              Future.delayed(Duration(seconds: 5)).then((value) {
                FirebaseStorage storageReference = FirebaseStorage.instance;
                Reference ref = storageReference
                    .ref()
                    .child('instructors')
                    .child(nameController.text)
                    .child('${_image.path}');

                ref.getDownloadURL().then((value) {
                  instructorData.image = value;
                });
              });

              Future.delayed(Duration(seconds: 10)).then((value) {
                model.saveInstructor(instructorData, _onSuccess, _onFail);
              });
            }
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
          'Cadastrar',
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

  Row _genderSelect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 34,
          width: 137,
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                gender = 'masculino';
                selected = true;
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                selected ? yellow : gray,
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
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
          ),
        ),
        Container(
          height: 34,
          width: 137,
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                gender = 'feminino';
                selected = false;
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                selected ? gray : yellow,
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
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
          ),
        ),
      ],
    );
  }

  Column birthday(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'Data de Nascimento',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: yellow,
                fontSize: 24,
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
                ? 'Selecione uma Data!'
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
