import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/data/student_data.dart';
import 'package:power_gym/model/student_model.dart';
import 'package:scoped_model/scoped_model.dart';

class StudentsList extends StatefulWidget {
  const StudentsList({Key key}) : super(key: key);

  @override
  _StudentsListState createState() => _StudentsListState();
}

final _formKey = GlobalKey<FormState>();
TextEditingController emailController = TextEditingController();
TextEditingController passController = TextEditingController();
TextEditingController nameController = TextEditingController();
DateTime selectedDate;
bool selected = true;
String gender = 'Masculino';

class _StudentsListState extends State<StudentsList> {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StudentModel>(
      builder: (context, child, model) {
        model.loadStudents();

        return Center(
          child:
              model.isLoading ? CircularProgressIndicator() : _buildList(model),
        );
      },
    );
  }

  Container _buildList(StudentModel studentModel) {
    Size size = MediaQuery.of(context).size;
    final students = studentModel.students;
    if (students.length == 0) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.network(
                'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/out.svg?alt=media&token=83d7ecf2-32c4-49c8-a8ad-24a4798dc110'),
            SizedBox(height: 10),
            Text(
              'Nenhum aluno(a) cadastrado(a)',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];

            return GestureDetector(
              onTap: () {
                emailController.text = student.email;
                passController.text = student.pass;
                nameController.text = student.name;
                gender = student.gender;
                if (student.gender == 'Masculino') {
                  selected = true;
                } else {
                  selected = false;
                }
                showDialog(
                  context: context,
                  builder: (_) {
                    return _editStudent(student, size);
                  },
                );
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: size.height * .3,
                      child: AlertDialog(
                        title: Text('Excluir aluno?'),
                        actions: [
                          TextButton(
                            child: Text('Cancelar'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text('Excluir'),
                            onPressed: () {
                              studentModel.deleteStudent(
                                student,
                                _onSuccessDelete,
                                _onFail,
                              );
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: _listTile(student, index, context),
            );
          },
        ),
      );
    }
  }

  ScopedModelDescendant<StudentModel> _editStudent(
    StudentData student,
    Size size,
  ) {
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
                      'Editar Aluno',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: gray,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  _pickDate(context, studentModel, student),
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
                        ),
                      ),
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
                      if (value == null || value.isEmpty || value.length < 8) {
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
                if (_formKey.currentState.validate()) {
                  StudentData studentData = StudentData();
                  studentData.uid = student.uid;
                  studentData.name = nameController.text;
                  studentData.email = emailController.text;
                  studentData.pass = passController.text;
                  studentData.acad = '0';
                  studentData.gender = gender;
                  studentData.image = student.image;
                  studentData.birthDate = selectedDate == null
                      ? student.birthDate
                      : '${DateFormat('dd/MM/y').format(selectedDate)}';

                  studentModel.updateStudent(
                    student,
                    studentData,
                    _onSuccessEdit,
                    _onFail,
                  );

                  nameController.text = '';
                  emailController.text = '';
                  passController.text = '';
                  selectedDate = null;
                  selected = true;
                  gender = 'Masculino';

                  Navigator.pop(context);
                }
              },
            )
          ],
        );
      },
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

  Container _pickDate(
    BuildContext context,
    StudentModel studentModel,
    StudentData student,
  ) {
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
                initialDate: convertDateTime(student.birthDate),
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
                  ? student.birthDate
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

  ListTile _listTile(StudentData student, int index, BuildContext context) {
    int nowYear = int.parse(DateTime.now().toString().substring(0, 4));
    int yearStudent = int.parse(student.birthDate.substring(6, 10).toString());

    String yearsOld = (nowYear - yearStudent).toString();

    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${student.name}, $yearsOld',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: white,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            student.email,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: white,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
      leading: CircleAvatar(
        backgroundImage: student.image == ""
            ? NetworkImage(
                'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
              )
            : NetworkImage(
                "${student.image}",
              ),
      ),
      trailing: Icon(
        student.gender == 'Masculino' ? Icons.male : Icons.female,
        color: white,
      ),
    );
  }

  void _onSuccessDelete() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Aluno deletado com sucesso!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onSuccessEdit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Aluno atualizado com sucesso!',
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
