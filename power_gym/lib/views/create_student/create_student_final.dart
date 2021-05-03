import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/data/student_data.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:power_gym/constants.dart';
import 'package:power_gym/model/student_model.dart';
import 'package:intl/intl.dart';

class CreateStudentFinal extends StatefulWidget {
  final String email;
  final String pass;
  final String name;

  const CreateStudentFinal({Key key, this.email, this.pass, this.name})
      : super(key: key);

  @override
  _CreateStudentFinalState createState() => _CreateStudentFinalState();
}

class _CreateStudentFinalState extends State<CreateStudentFinal> {
  String gender = 'masculino';
  bool selected = true;
  DateTime selectedDate;
  String email;
  String pass;
  String name;

  @override
  void initState() {
    super.initState();
    email = widget.email;
    pass = widget.pass;
    name = widget.name;
  }

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
      body: ScopedModel<StudentModel>(
        model: StudentModel(),
        child: ScopedModelDescendant<StudentModel>(
          builder: (context, child, model) {
            if (model.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Column(
                children: [
                  SvgPicture.asset(
                    'assets/svg/wave.svg',
                    width: size.width,
                  ),
                  SizedBox(height: 80),
                  Expanded(
                    child: ListView(
                      children: [
                        Row(
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
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    selected ? yellow : gray,
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
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
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    selected ? gray : yellow,
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
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
                        ),
                        SizedBox(height: 100),
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
                        SizedBox(height: 100),
                        Container(
                          height: 48,
                          width: 277,
                          child: ElevatedButton(
                            onPressed: () {
                              StudentData studentData = StudentData();
                              studentData.name = widget.name;
                              studentData.email = widget.email;
                              studentData.acad = '0';
                              studentData.gender = gender;
                              studentData.image = '';
                              studentData.birthDate =
                                  '${DateFormat('dd/MM/y').format(selectedDate)}';

                              Map<String, dynamic> userData = {
                                'name': widget.name,
                                'email': widget.email,
                                'acad': '0',
                                'gender': gender,
                                'image': '',
                                'birthDate':
                                    '${DateFormat('dd/MM/y').format(selectedDate)}'
                              };

                              model.createStudentFinal(
                                userData: userData,
                                pass: widget.pass,
                                onSuccess: _onSuccess,
                                onFail: _onFail,
                                studentData: studentData,
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                yellow,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
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
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
          },
        ),
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
