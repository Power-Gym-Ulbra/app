import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:power_gym/data/student_data.dart';
import 'package:power_gym/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StudentModel extends Model {

  UserModel user;

  bool isLoading = false;

  List<StudentData> _students = [];

  List<StudentData> get students => _students.toList();

  set _listStudents(List<StudentData> value) {
    _students = value;
    notifyListeners();
  }

  DateTime _date;

  DateTime get date => _date;

  set _newDate(DateTime value) {
    _date = value;
    notifyListeners();
  }

  bool _selected;
  String _gender;

  bool get selected => _selected;
  String get gender => _gender;

  set _newGender(String value) {
    _gender = value;
    notifyListeners();
  }

  set _newSelected(bool value) {
    _selected = value;
    notifyListeners();
  }

  bool _obscure = true;

  bool get obscure => _obscure;

  set _newObscure(bool value) {
    _obscure = value;
    notifyListeners();
  }

  void setObscure(bool obscure) {
    _newObscure = obscure;
    notifyListeners();
  }

  static StudentModel of(BuildContext context) =>
      ScopedModel.of<StudentModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    if (user.isLoaggedIn()) {
      loadStudents();
    }
  }

  StudentModel(this.user) {
    if (user.isLoaggedIn()) {
      loadStudents();
    }
  }

  Future<UserCredential> registerStudentFinal(
    String email,
    String password,
    StudentData studentData,
    Map<String, dynamic> userData,
    VoidCallback onSuccess,
    VoidCallback onFail,
  ) async {
    UserCredential userCredential;

    try {
      isLoading = true;
      notifyListeners();

      FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary',
        options: Firebase.app().options,
      );
      try {
        userCredential = await FirebaseAuth.instanceFor(app: app)
            .createUserWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        print('ERROR' + e.toString());
      }

      await app.delete();

      await Firebase.initializeApp();

      studentData.uid = userCredential.user.uid;

      await _saveStudent(studentData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      onFail();
      isLoading = false;
      print('erro');
      notifyListeners();
    }

    return Future.sync(
      () => userCredential,
    );
  }

  Future<void> _saveStudent(StudentData studentData) async {
    await Future.wait([
      FirebaseFirestore.instance
          .collection('users')
          .doc(studentData.uid)
          .set(studentData.toMap()),
      FirebaseFirestore.instance
          .collection('students')
          .doc(studentData.uid)
          .set(studentData.toMap()),
    ]).whenComplete(() {
      loadStudents();
    });
  }

  void updateStudent(
    StudentData student,
    StudentData newStudent,
    VoidCallback onSuccess,
    VoidCallback onFail,
  ) async {
    UserCredential userCredential;

    try {
      isLoading = true;
      notifyListeners();

      FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary',
        options: Firebase.app().options,
      );
      try {
        userCredential =
            await FirebaseAuth.instanceFor(app: app).signInWithEmailAndPassword(
          email: student.email,
          password: student.pass,
        );

        userCredential.user.updateEmail(newStudent.email);
        userCredential.user.updatePassword(newStudent.pass);
      } on FirebaseAuthException catch (e) {
        print('ERROR' + e.toString());
      }

      await app.delete();

      await Firebase.initializeApp();

      Future.wait([
        FirebaseFirestore.instance
            .collection('users')
            .doc(student.uid)
            .update(newStudent.toMap()),
        FirebaseFirestore.instance
            .collection('students')
            .doc(student.uid)
            .update(newStudent.toMap()),
      ]).whenComplete(() {
        loadStudents();
        onSuccess();
        isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      onFail();
      isLoading = false;
      print('erro');
      notifyListeners();
    }

    return Future.sync(
      () => userCredential,
    );
  }

  Future<void> deleteStudent(
      StudentData student, VoidCallback onSuccess, VoidCallback onFail) async {
    AuthCredential authCredential;
    UserCredential userCredential;

    try {
      isLoading = true;
      notifyListeners();

      FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary',
        options: Firebase.app().options,
      );
      try {
        authCredential = EmailAuthProvider.credential(
          email: student.email,
          password: student.pass,
        );
        userCredential = await FirebaseAuth.instanceFor(app: app)
            .currentUser
            .reauthenticateWithCredential(
              authCredential,
            );

        userCredential.user.delete();
      } on FirebaseAuthException catch (e) {
        print('ERROR' + e.toString());
      }

      await app.delete();

      await Firebase.initializeApp();

      Future.wait([
        FirebaseFirestore.instance
            .collection('users')
            .doc(student.uid)
            .delete(),
        FirebaseFirestore.instance
            .collection('students')
            .doc(student.uid)
            .delete(),
      ]).whenComplete(() {
        loadStudents();
        isLoading = false;
        notifyListeners();
      });

      onSuccess();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      onFail();
      isLoading = false;
      print('erro');
      notifyListeners();
    }

    return Future.sync(
      () => userCredential,
    );
  }

  void uploadFile(File _image, String uid) async {
    isLoading = true;
    notifyListeners();

    FirebaseStorage storageReference = FirebaseStorage.instance;
    Reference ref = storageReference
        .ref()
        .child('users')
        .child('$uid')
        .child('${_image.path}');
    UploadTask uploadTask = ref.putFile(_image);
    await uploadTask;

    return;
  }

  void loadStudents() async {
    QuerySnapshot query =
        await FirebaseFirestore.instance.collection('students').get();

    _listStudents =
        query.docs.map((doc) => StudentData.fromDocument(doc)).toList();
    notifyListeners();
  }

  void pickDate(DateTime date) {
    _newDate = date;
    notifyListeners();
  }

  void newGender(bool selected, String gender) {
    _newGender = gender;
    _newSelected = selected;
    notifyListeners();
  }
}
