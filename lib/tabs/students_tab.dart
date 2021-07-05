import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/data/student_data.dart';
import 'package:power_gym/model/student_model.dart';
import 'package:power_gym/widget/students_list.dart';
import 'package:scoped_model/scoped_model.dart';

class StudentsTabGym extends StatefulWidget {
  @override
  _StudentsTabGymState createState() => _StudentsTabGymState();
}

class _StudentsTabGymState extends State<StudentsTabGym> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  DateTime selectedDate;
  bool selected = true;
  String gender = 'Masculino';

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
                return ScopedModelDescendant<StudentModel>(
                  builder: (context, child, studentModel) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(12.0),
                      content: Container(
                        height: size.height * .4,
                        width: 300,
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            children: [
                              Center(
                                child: Text(
                                  'Cadastrar Aluno',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: gray,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              _pickDate(context, studentModel),
                              SizedBox(height: 10),
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
                                  hintStyle: TextStyle(color: gray, fontSize: 12),
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
                              _genderSelect(studentModel),
                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: gray,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: yellow,
                                  )),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: gray,
                                    ),
                                  ),
                                  hintStyle: TextStyle(color: gray, fontSize: 12),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: gray,
                                    size: 18,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      !value.contains('@')) {
                                    return 'Email inválido ou incorreto';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: passController,
                                obscureText: studentModel.obscure,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: gray,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Senha',
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: yellow,
                                  )),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: gray,
                                    ),
                                  ),
                                  hintStyle: TextStyle(color: gray, fontSize: 12),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: gray,
                                    size: 18,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: studentModel.obscure
                                        ? Icon(Icons.visibility, color: gray)
                                        : Icon(Icons.visibility_off, color: gray),
                                    onPressed: () {
                                      if (studentModel.obscure == true) {
                                        studentModel.setObscure(false);
                                      } else {
                                        studentModel.setObscure(true);
                                      }
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 8) {
                                    return 'Senha inválida ou menor que 8 caracteres';
                                  }
                                  return null;
                                },
                              ),
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
                            emailController.text = '';
                            passController.text = '';
                            selectedDate = null;
                            selected = true;
                            gender = 'Masculino';
                          },
                        ),
                        TextButton(
                          child: Text('SALVAR'),
                          onPressed: () {
                            if (studentModel.date == null) {
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
                              StudentData studentData = StudentData();
                              studentData.name = nameController.text;
                              studentData.email = emailController.text;
                              studentData.pass = passController.text;
                              studentData.acad = '0';
                              studentData.gender = gender;
                              studentData.image = '';
                              studentData.birthDate =
                                  '${DateFormat('dd/MM/y').format(selectedDate)}';

                              Map<String, dynamic> userData = {
                                'name': nameController.text,
                                'email': emailController.text,
                                'pass': passController.text,
                                'acad': '0',
                                'gender': gender,
                                'image': '',
                                'birthDate':
                                    '${DateFormat('dd/MM/y').format(selectedDate)}',
                              };

                              studentModel
                                  .registerStudentFinal(
                                emailController.text,
                                passController.text,
                                studentData,
                                userData,
                                _onSuccess,
                                _onFail,
                              )
                                  .whenComplete(() {
                                nameController.text = '';
                                emailController.text = '';
                                passController.text = '';
                                selectedDate = null;
                                selected = true;
                                gender = 'Masculino';
                              });

                              Navigator.pop(context);
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
                child: StudentsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _genderSelect(StudentModel studentModel) {
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
                  studentModel.newGender(true, 'Masculino');

                  gender = studentModel.gender;
                  selected = studentModel.selected;
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
                  studentModel.newGender(false, 'Feminino');

                  gender = studentModel.gender;
                  selected = studentModel.selected;
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

  Container _pickDate(BuildContext context, StudentModel studentModel) {
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

                studentModel.pickDate(pickedDate);
                selectedDate = studentModel.date;
              });
            },
            child: Text(
              selectedDate == null
                  ? '${DateFormat('dd/MM/y').format(DateTime.now())}'
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
}
