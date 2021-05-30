import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/model/student_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';

class StudentPerfil extends StatefulWidget {
  @override
  _StudentPerfilState createState() => _StudentPerfilState();
}

class _StudentPerfilState extends State<StudentPerfil> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    int nowYear = int.parse(DateTime.now().toString().substring(0, 4));
    int yearStudent =
        int.parse(arguments['student'].birthDate.substring(6, 10).toString());

    String yearsOld = (nowYear - yearStudent).toString();

    return Scaffold(
      backgroundColor: gray,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Perfil',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: gray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor: yellow,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/editStudent',
                arguments: {
                  'student': arguments['student'],
                },
              );
            },
            icon: Icon(Icons.edit),
          ),
          ScopedModel(
            model: StudentModel(),
            child: ScopedModelDescendant<StudentModel>(
              builder: (context, child, model) => IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  Alert(
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
                            arguments['student'].uid,
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
                          color: Colors.redAccent)
                    ],
                  ).show();
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SvgPicture.asset(
            'assets/svg/wave.svg',
            width: size.width,
          ),
          CircleAvatar(
            maxRadius: size.height * .1,
            backgroundImage: arguments['student'].image == ""
                ? NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/powergym-11fa6.appspot.com/o/user.png?alt=media&token=a7b34968-2285-40ad-8929-713bac8b132c',
                  )
                : NetworkImage(
                    "${arguments['student'].image}",
                  ),
          ),
          SizedBox(height: size.height * .02),
          Text(
            '${arguments['student'].name}, $yearsOld',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: white, fontSize: 24, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: size.height * .12),
          Text(
            'Email',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: yellow, fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            arguments['student'].email,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: white, fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: size.height * .08),
          Text(
            'Gênero',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: yellow, fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            arguments['student'].gender,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: white, fontSize: 18, fontWeight: FontWeight.w400),
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
          'Aluno excluido com sucesso',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 2),
      ),
    );
    StudentModel();
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
