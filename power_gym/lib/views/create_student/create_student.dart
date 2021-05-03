import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/views/create_student/create_student_final.dart';

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

  @override
  void initState() {
    super.initState();
    emailController.text = '';
    passController.text = '';
    nameController.text = '';
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
      body: Column(
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
                        if (value == null || value.isEmpty) {
                          return 'Senha incorreta';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * .12),
                    Container(
                      height: 48,
                      width: 277,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateStudentFinal(
                                  email: emailController.text,
                                  name: nameController.text,
                                  pass: passController.text,
                                ),
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            yellow,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                        ),
                        child: Text(
                          'Continuar',
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
