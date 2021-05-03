import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
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
                    'Redefinir\nSenha',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * .0461,
                        color: yellow,
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                  Form(
                    key: _formKey,
                    child: Expanded(
                      child: ListView(
                        children: [
                          TextFormField(
                            controller: _emailController,
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
                          Container(
                            height: 48,
                            width: 277,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  model.recoverPass(_emailController.text);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Confira seu email!',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: gray,
                                          ),
                                        ),
                                      ),
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  Navigator.pop(context);
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
                                'Enviar',
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
