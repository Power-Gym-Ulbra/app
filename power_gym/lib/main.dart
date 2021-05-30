import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:power_gym/model/student_model.dart';
import 'package:power_gym/model/user_model.dart';
import 'package:power_gym/tabs/students_tab.dart';
import 'package:power_gym/views/create_instructors/create_instructors.dart';
import 'package:power_gym/views/create_student/create_student.dart';
import 'package:power_gym/views/edit_student/edit_student.dart';
import 'package:power_gym/views/home_page/home_page.dart';
import 'package:power_gym/views/intro_page/intro_page.dart';
import 'package:power_gym/views/login_page/login_page.dart';
import 'package:power_gym/views/reset_password/reset_password.dart';
import 'package:power_gym/views/sign_up_page/sign_up_page.dart';
import 'package:power_gym/views/student_perfil/student_perfil.dart';
import 'package:scoped_model/scoped_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return ScopedModel(
            model: StudentModel(),
            child: ScopedModelDescendant<StudentModel>(
              builder: (context, child, modelStudent) {
                return MaterialApp(
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate
                  ],
                  supportedLocales: [
                    const Locale('pt', 'BR'),
                    const Locale('en'),
                  ],
                  debugShowCheckedModeBanner: false,
                  title: 'Power Gym',
                  theme: ThemeData(
                    primarySwatch: Colors.yellow,
                  ),
                  initialRoute: '/',
                  routes: {
                    '/': (context) => FutureBuilder(
                          future: model.isLoaggedInFuture(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return Center(child: CircularProgressIndicator());

                            if (!model.isLoaggedIn()) {
                              return IntroScreen();
                            } else {
                              return HomePage();
                            }
                          },
                        ),
                    '/login': (context) => LoginPage(),
                    '/signup': (context) => SignUpPage(),
                    '/home': (context) => HomePage(),
                    '/resetPass': (context) => ResetPassword(),
                    '/students': (context) => StudentsTabGym(),
                    '/createStudent': (context) => CreateStudent(),
                    '/perfilStudent': (context) => StudentPerfil(),
                    '/editStudent': (context) => EditStudent(),
                    '/createInstructors': (context) => CreateInstructors()
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
