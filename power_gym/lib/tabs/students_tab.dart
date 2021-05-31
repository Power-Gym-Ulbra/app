import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/data/student_data.dart';
import 'package:power_gym/model/student_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';

import 'dart:io';

class StudentsTabGym extends StatefulWidget {
  @override
  _StudentsTabGymState createState() => _StudentsTabGymState();
}

class _StudentsTabGymState extends State<StudentsTabGym> {
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
  void initState() {
    setState(() {
      nameController.text = '';
      passController.text = '';
      emailController.text = '';
      genderController.text = '';
      dateController.text = '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ScopedModel(
      model: StudentModel(),
      child: ScopedModelDescendant<StudentModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/svg/wave.svg',
                  width: size.width,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: model.students.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () {
                          _deleteStudent(context, model, index).show();
                        },
                        onTap: () {
                          nameController.text = model.students[index].name;
                          genderController.text = model.students[index].gender;
                          dateController.text = model.students[index].birthDate;

                          _editStudent(context, model, index, size).show();
                        },
                        child: _listTile(model, index),
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
                        _newStudent(context, model, size).show();
                      },
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  Alert _editStudent(
      BuildContext context, StudentModel model, int index, Size size) {
    return Alert(
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
        title: "Editar Estudante",
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
                            getImage(true, model, index);
                          },
                          icon: Icon(Icons.add_a_photo),
                          color: gray,
                        ),
                      ],
                    ),
                    maxRadius: size.height * .05,
                    backgroundImage: pickedFile != null
                        ? FileImage(_image)
                        : model.students[index].image == ""
                            ? NetworkImage(
                                'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
                              )
                            : NetworkImage(
                                "${model.students[index].image}",
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
                StudentData studentData = StudentData();
                studentData.uid = model.students[index].uid;
                studentData.name = nameController.text == ''
                    ? model.students[index].name
                    : nameController.text;
                studentData.email = model.students[index].email;
                studentData.acad = model.students[index].acad;
                studentData.gender = genderController.text == ''
                    ? model.students[index].gender
                    : genderController.text;
                studentData.image = model.students[index].image;
                studentData.birthDate = dateController.text == ''
                    ? model.students[index].birthDate
                    : dateController.text;
                if (_image != null) {
                  model.uploadFile(
                    _image,
                    model.students[index].uid,
                  );

                  Future.delayed(Duration(seconds: 5)).then((value) {
                    FirebaseStorage storageReference = FirebaseStorage.instance;
                    Reference ref = storageReference
                        .ref()
                        .child('users')
                        .child(model.students[index].uid)
                        .child('${_image.path}');

                    ref.getDownloadURL().then((value) {
                      studentData.image = value;
                    });
                  });

                  Future.delayed(Duration(seconds: 8)).then((value) {
                    model.updateStudentWithPicture(
                      studentData,
                      _onSuccessEdit,
                      _onFail,
                    );
                  });
                } else {
                  model.updateStudentWithoutPicture(
                    studentData,
                    _onSuccessEdit,
                    _onFail,
                  );
                }

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
        ]);
  }

  Alert _newStudent(BuildContext context, StudentModel model, Size size) {
    return Alert(
        context: context,
        title: "Novo Estudante",
        content: Form(
          key: _formKey,
          child: Column(
            children: [
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
                controller: emailController,
                decoration: InputDecoration(
                  icon: Icon(Icons.mail),
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Email inválido ou incorreto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Senha',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 8) {
                    return 'Senha inválida ou menor que 8 caracteres';
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
                StudentData studentData = StudentData();
                studentData.name = nameController.text;
                studentData.email = emailController.text;
                studentData.acad = '0';
                studentData.gender = genderController.text;
                studentData.image = '';
                studentData.birthDate = dateController.text;

                Map<String, dynamic> userData = {
                  'name': nameController.text,
                  'email': emailController.text,
                  'acad': '0',
                  'gender': genderController.text,
                  'image': '',
                  'birthDate': dateController.text
                };

                model.registerStudentFinal(
                  emailController.text,
                  passController.text,
                  studentData,
                  userData,
                  _onSuccess,
                  _onFail,
                );

                nameController.text = '';
                passController.text = '';
                emailController.text = '';
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
        ]);
  }

  ListTile _listTile(StudentModel model, int index) {
    return ListTile(
      title: Text(
        model.students[index].name,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: white,
          ),
        ),
      ),
      leading: CircleAvatar(
        backgroundImage: model.students[index].image == ""
            ? NetworkImage(
                'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
              )
            : NetworkImage(
                "${model.students[index].image}",
              ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: white,
      ),
    );
  }

  Alert _deleteStudent(BuildContext context, StudentModel model, int index) {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "CUIDADO",
      desc: "Você tem certeza que quer excluir este aluno?",
      buttons: [
        DialogButton(
          child: Text(
            'Sim',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: white,
              ),
            ),
          ),
          onPressed: () {
            model.deleteStudent(
              model.students[index].uid,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Aluno excluido com sucesso!',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.greenAccent,
                duration: Duration(seconds: 2),
              ),
            );
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
          color: Colors.redAccent,
        )
      ],
    );
  }

  Future getImage(bool gallery, StudentModel model, int index) async {
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
        model.students[index].image == ""
            ? NetworkImage(
                'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
              )
            : NetworkImage(
                "${model.students[index].image}",
              );
      }
    });
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Aluno criado com sucesso!',
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

  void _onSuccessEdit() {
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
  }
}
