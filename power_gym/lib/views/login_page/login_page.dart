import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_gym/constants.dart';
import 'package:power_gym/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
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
                    'Entrar',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * .0461,
                        color: yellow,
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                  myForm(size, context, model),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Form myForm(Size size, BuildContext context, UserModel model) {
    return Form(
      key: _formKey,
      child: Expanded(
        child: ListView(
          children: [
            emailTextField(),
            SizedBox(height: size.height * .05),
            passTextField(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/resetPass');
                  },
                  child: Text(
                    'Esqueci minha senha ?',
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
            SizedBox(height: size.height * .12),
            buttonLogin(model),
            SizedBox(height: size.height * .01),
            buttonSignUp(context),
          ],
        ),
      ),
    );
  }

  Row buttonSignUp(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Ainda não tem conta?',
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
            Navigator.pushReplacementNamed(context, '/signup');
          },
          child: Text(
            'Criar',
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
    );
  }

  Container buttonLogin(UserModel model) {
    return Container(
      height: 48,
      width: 277,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {}

          model.signIn(
            email: _emailController.text,
            pass: _passController.text,
            onSuccess: _onSuccess,
            onFail: _onFail,
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            yellow,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
        child: Text(
          'Entrar',
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

  TextFormField passTextField() {
    return TextFormField(
      controller: _passController,
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
              ? Icon(
                  Icons.visibility,
                  color: white,
                )
              : Icon(
                  Icons.visibility_off,
                  color: white,
                ),
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
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
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
        if (value == null || value.isEmpty || !value.contains('@')) {
          return 'Email inválido ou incorreto';
        }
        return null;
      },
    );
  }

  void _onSuccess() {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Email ou senha incorreta!'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
