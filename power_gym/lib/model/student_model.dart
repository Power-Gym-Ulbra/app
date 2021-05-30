import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:power_gym/data/student_data.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StudentModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  User currentUser;

  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  List<StudentData> _students = [];

  List<StudentData> get students => _students.toList();

  set _listStudents(List<StudentData> value) {
    _students = value;
    notifyListeners();
  }

  static StudentModel of(BuildContext context) =>
      ScopedModel.of<StudentModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    // update data for every subscriber, especially for the first one
    loadStudents();
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
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('students')
          .doc(studentData.uid)
          .set(studentData.toMap()),
    ]).whenComplete(() {
      loadStudents();
    });
  }

  void updateStudentWithPicture(
    StudentData student,
    VoidCallback onSuccess,
    VoidCallback onFail,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(student.uid)
          .update(student.toMap());

      await FirebaseFirestore.instance
          .collection('students')
          .doc(student.uid)
          .update(student.toMap());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('students')
          .doc(student.uid)
          .update(student.toMap());

      onSuccess();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      onFail();
      isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  void updateStudentWithoutPicture(
    StudentData student,
    VoidCallback onSuccess,
    VoidCallback onFail,
  ) {
    try {
      isLoading = true;
      notifyListeners();

      FirebaseFirestore.instance
          .collection('users')
          .doc(student.uid)
          .update(student.toMap());

      FirebaseFirestore.instance
          .collection('students')
          .doc(student.uid)
          .update(student.toMap());

      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('students')
          .doc(student.uid)
          .update(student.toMap());
      onSuccess();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      onFail();
      isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  void deleteStudent(
    String uid,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      Future.wait([
        FirebaseFirestore.instance.collection('users').doc(uid).delete(),
        FirebaseFirestore.instance.collection('students').doc(uid).delete(),
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('students')
            .doc(uid)
            .delete(),
      ]).whenComplete(() {
        loadStudents();
      });

      print('deleted');
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
    notifyListeners();
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
    currentUser = _auth.currentUser;
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('students')
        .get();

    _listStudents =
        query.docs.map((doc) => StudentData.fromDocument(doc)).toList();
  }
}
