import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: gray,
      appBar: AppBar(
        backgroundColor: gray,
        elevation: 0,
        iconTheme: IconThemeData(
          color: yellow,
        ),
      ),
      body: ScopedModel<UserModel>(
        model: UserModel(),
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inscreva-se',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * .0461,
                        color: yellow,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Form(
                    key: _formKey,
                    child: Expanded(
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
                              hintText: 'Nome da academia',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: white,
                                ),
                              ),
                              hintStyle: TextStyle(
                                color: white,
                              ),
                              prefixIcon: Icon(
                                Icons.fitness_center,
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
                              if (value == null || value.isEmpty || value.length < 8) {
                                return 'Senha incorreta ou poucos caracteres';
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
                                  Map<String, dynamic> userData = {
                                    'name': nameController.text,
                                    'email': emailController.text,
                                    'acad': '1',
                                    'photo': '',
                                    'pass': passController.text
                                  };

                                  model.signUp(
                                    userData: userData,
                                    pass: passController.text,
                                    onSuccess: _onSuccess,
                                    onFail: _onFail,
                                  );

                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
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
                                'Inscreva-se',
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
                          SizedBox(height: size.height * .01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ja tem uma conta?',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/login');
                                },
                                child: Text(
                                  'Entrar',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onSuccess() {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Email ou senha incorreta!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
