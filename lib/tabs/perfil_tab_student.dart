import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/data/student_data.dart';
import 'package:power_gym/model/user_model.dart';
import 'package:power_gym/views/intro_page/intro_page.dart';
import 'package:scoped_model/scoped_model.dart';

import 'dart:io';

class PerfilTabStudent extends StatefulWidget {
  const PerfilTabStudent({Key key}) : super(key: key);

  @override
  _PerfilTabState createState() => _PerfilTabState();
}

class _PerfilTabState extends State<PerfilTabStudent> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  ImagePicker picker = ImagePicker();
  PickedFile pickedFile;
  File _image;

  bool isSwitched = false;

  DateTime selectedDate;
  bool selected = true;
  String gender = 'Masculino';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    int nowYear = int.parse(DateTime.now().toString().substring(0, 4));
    int yearStudent = int.parse(UserModel.of(context)
        .userData['birthDate']
        .substring(6, 10)
        .toString());

    String yearsOld = (nowYear - yearStudent).toString();

    return SafeArea(
      child: Scaffold(
        backgroundColor: gray,
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, userModel) {
            userModel.loadCurrentUser();

            if (userModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                SvgPicture.asset(
                  'assets/svg/wave.svg',
                  width: size.width,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      tooltip: 'Editar',
                      icon: Icon(
                        Icons.edit,
                        color: white,
                      ),
                      onPressed: () {
                        nameController.text = userModel.userData['name'];
                        emailController.text = userModel.userData['email'];
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.all(12.0),
                              content: Container(
                                height: size.height * .5,
                                width: 300,
                                child: Form(
                                  key: _formKey,
                                  child: ListView(
                                    children: [
                                      Column(
                                        children: [
                                          Center(
                                            child: Text(
                                              'Editar',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  color: gray,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          CircleAvatar(
                                            child: Stack(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    getImage(true, userModel);
                                                  },
                                                  icon: Icon(
                                                    Icons.add_a_photo,
                                                    color: white,
                                                  ),
                                                  color: gray,
                                                ),
                                              ],
                                            ),
                                            maxRadius: size.height * .04,
                                            backgroundImage: _image != null
                                                ? FileImage(_image)
                                                : userModel.userData['image'] ==
                                                        ''
                                                    ? NetworkImage(
                                                        'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
                                                      )
                                                    : NetworkImage(
                                                        userModel
                                                            .userData['image'],
                                                      ),
                                          ),
                                          SizedBox(height: 15),
                                          TextFormField(
                                            controller: nameController,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: gray,
                                              ),
                                            ),
                                            decoration: InputDecoration(
                                              hintText: 'Nome',
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                color: yellow,
                                              )),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: gray,
                                                ),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: gray, fontSize: 12),
                                              prefixIcon: Icon(
                                                Icons.person,
                                                color: gray,
                                                size: 18,
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Nome inválido ou vazio';
                                              }
                                              return null;
                                            },
                                          ),
                                          _pickDate(
                                            context,
                                            userModel,
                                          ),
                                          _genderSelect(userModel),
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Editar senha'),
                                                  Switch(
                                                    value: userModel.isSwitched,
                                                    onChanged: (value) {
                                                      userModel
                                                          .newIsSwitched(value);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 1,
                                                width: 300,
                                                color: gray,
                                              )
                                            ],
                                          ),
                                          userModel.isSwitched
                                              ? Container(
                                                  child: Column(
                                                    children: [
                                                      TextFormField(
                                                        controller:
                                                            emailController,
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            color: gray,
                                                          ),
                                                        ),
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: 'Email',
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                            color: yellow,
                                                          )),
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: gray,
                                                            ),
                                                          ),
                                                          hintStyle: TextStyle(
                                                              color: gray,
                                                              fontSize: 12),
                                                          prefixIcon: Icon(
                                                            Icons.email,
                                                            color: gray,
                                                            size: 18,
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty ||
                                                              !value.contains(
                                                                  '@')) {
                                                            return 'Email inválido ou incorreto';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            passController,
                                                        obscureText:
                                                            userModel.obscure,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            color: gray,
                                                          ),
                                                        ),
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: 'Senha',
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                            color: yellow,
                                                          )),
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: gray,
                                                            ),
                                                          ),
                                                          hintStyle: TextStyle(
                                                              color: gray,
                                                              fontSize: 12),
                                                          prefixIcon: Icon(
                                                            Icons.lock,
                                                            color: gray,
                                                            size: 18,
                                                          ),
                                                          suffixIcon:
                                                              IconButton(
                                                            icon: userModel
                                                                    .obscure
                                                                ? Icon(
                                                                    Icons
                                                                        .visibility,
                                                                    color: gray)
                                                                : Icon(
                                                                    Icons
                                                                        .visibility_off,
                                                                    color:
                                                                        gray),
                                                            onPressed: () {
                                                              if (userModel
                                                                      .obscure ==
                                                                  true) {
                                                                userModel
                                                                    .setObscure(
                                                                        false);
                                                              } else {
                                                                userModel
                                                                    .setObscure(
                                                                        true);
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty ||
                                                              value.length <
                                                                  8) {
                                                            return 'Senha inválida ou menor que 8 caracteres';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('CANCELAR'),
                                  onPressed: () {
                                    passController.text = '';
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text('SALVAR'),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      StudentData studentData = StudentData();
                                      studentData.name = nameController.text;
                                      studentData.email = emailController.text;
                                      studentData.gender = gender;
                                      studentData.uid =
                                          UserModel.of(context).userData['uid'];
                                      studentData.pass = UserModel.of(context)
                                          .userData['pass'];
                                      studentData.birthDate = selectedDate !=
                                              null
                                          ? '${DateFormat('dd/MM/y').format(selectedDate)}'
                                          : UserModel.of(context)
                                              .userData['birthDate'];
                                      studentData.acad = UserModel.of(context)
                                          .userData['acad'];
                                      studentData.image =
                                          userModel.userData['image'];

                                      userModel.updateUserStudent(
                                        studentData,
                                        passController.text,
                                        _image,
                                        _onSuccess,
                                        _onFail,
                                      );

                                      passController.text = '';
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      tooltip: 'Sair',
                      icon: Icon(
                        Icons.exit_to_app,
                        color: white,
                      ),
                      onPressed: () async {
                        userModel.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IntroScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    )
                  ],
                ),
                CircleAvatar(
                  maxRadius: size.height * .07,
                  backgroundImage: userModel.userData['image'] == ""
                      ? NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
                        )
                      : NetworkImage(
                          "${userModel.userData['image']}",
                        ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${userModel.userData['name']}, $yearsOld',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Icon(
                      userModel.userData['gender'] == 'Masculino' ? Icons.male : Icons.female,
                      color: white,
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Column(
                  children: [
                    Text(
                      'Email',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: yellow,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Text(
                      userModel.userData['email'],
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future getImage(bool gallery, UserModel model) async {
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

  Container _pickDate(
    BuildContext context,
    UserModel user,
  ) {
    return Container(
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
              SizedBox(width: 3),
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
                initialDate: convertDateTime(user.userData['birthDate']),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                locale: Locale('pt', 'BR'),
              ).then((pickedDate) {
                if (pickedDate == null) {
                  return;
                }

                user.pickDate(pickedDate);
                selectedDate = user.date;
              });
            },
            child: Text(
              selectedDate == null
                  ? user.userData['birthDate']
                  : '${DateFormat('dd/MM/y').format(selectedDate)}',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: selectedDate == null ? facebook : yellow,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime convertDateTime(String validade) {
    DateTime parsedDate = DateTime.parse('0001-11-30 00:00:00.000');

    List<String> validadeSplit = validade.split('/');

    if (validadeSplit.length > 1) {
      String day = validadeSplit[0].toString();
      String month = validadeSplit[1].toString();
      String year = validadeSplit[2].toString();

      parsedDate = DateTime.parse('$year-$month-$day 00:00:00.000');
    }

    return parsedDate;
  }

  Row _genderSelect(UserModel userModel) {
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
                  userModel.newGender(true, 'Masculino');

                  gender = userModel.gender;
                  selected = userModel.selected;
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
                  userModel.newGender(false, 'Feminino');

                  gender = userModel.gender;
                  selected = userModel.selected;
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

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Perfil atualizado com sucesso!',
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
