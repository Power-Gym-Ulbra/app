import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/data/student_data.dart';
import 'package:power_gym/model/student_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateStudent extends StatefulWidget {
  @override
  _CreateStudentState createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool _obscure = true;
  String gender = 'masculino';
  bool selected = true;
  DateTime selectedDate;

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
      body: ScopedModel(
        model: StudentModel(),
        child: ScopedModelDescendant<StudentModel>(
          builder: (context, child, model) {
            if (model.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
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
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: white,
                              ),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Email',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: white,
                                ),
                              ),
                              hintStyle: TextStyle(
                                color: white,
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: white,
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
                          SizedBox(height: size.height * .05),
                          TextFormField(
                            controller: passController,
                            obscureText: _obscure,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: white,
                              ),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Senha',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: white,
                                ),
                              ),
                              hintStyle: TextStyle(
                                color: white,
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: white,
                              ),
                              suffixIcon: IconButton(
                                icon: _obscure
                                    ? Icon(Icons.visibility, color: white)
                                    : Icon(Icons.visibility_off, color: white),
                                onPressed: () {
                                  setState(
                                    () {
                                      if (_obscure == true) {
                                        _obscure = false;
                                      } else {
                                        _obscure = true;
                                      }
                                    },
                                  );
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
                          SizedBox(height: size.height * .09),
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

  Container buttonSubmit(StudentModel model) {
    return Container(
      height: 48,
      width: 277,
      child: ElevatedButton(
        onPressed: selectedDate == null
            ? null
            : () async {
                if (_formKey.currentState.validate()) {
                  StudentData studentData = StudentData();
                  studentData.name = nameController.text;
                  studentData.email = emailController.text;
                  studentData.acad = '0';
                  studentData.gender = gender;
                  studentData.image = '';
                  studentData.birthDate =
                      '${DateFormat('dd/MM/y').format(selectedDate)}';

                  Map<String, dynamic> userData = {
                    'name': nameController.text,
                    'email': emailController.text,
                    'acad': '0',
                    'gender': gender,
                    'image': '',
                    'birthDate': '${DateFormat('dd/MM/y').format(selectedDate)}'
                  };

                  model.registerStudentFinal(
                    emailController.text,
                    passController.text,
                    studentData,
                    userData,
                    _onSuccess,
                    _onFail,
                  );
                }
              },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              selectedDate == null ? null : yellow),
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
