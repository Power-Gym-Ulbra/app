import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:power_gym/data/student_data.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StudentModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentReference usersRef =
      FirebaseFirestore.instance.collection('users').doc();

  String id;
  User currentUser;

  //adm
  String nowId;
  String nowEmail;
  String nowPass;

  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  List<StudentData> students = [];

  static StudentModel of(BuildContext context) =>
      ScopedModel.of<StudentModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    notifyListeners();
  }

  StudentModel() {
    loadStudents();
  }
  
  void createStudentFinal({
    @required Map<String, dynamic> userData,
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required StudentData studentData,
    @required String admEmail,
    @required String admPass,
  }) {
    isLoading = true;
    notifyListeners();

    nowId = currentUser.uid;
    nowEmail = admEmail;
    nowPass = admPass;

    _auth
        .createUserWithEmailAndPassword(
      email: userData['email'],
      password: pass,
    )
        .then((user) async {
      id = user.user.uid;

      studentData.uid = id;

      _saveStudent(studentData);
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
    signOut();
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
    VoidCallback onSuccess,
    VoidCallback onFail,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      await FirebaseFirestore.instance.collection('students').doc(uid).delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('students')
          .doc(uid)
          .delete();

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

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    currentUser = null;

    notifyListeners();

    await _auth
        .signInWithEmailAndPassword(
      email: nowEmail,
      password: nowPass,
    )
        .then((user) {
      currentUser = user.user;

      loadCurrentUser();
    });
  }

  Future<void> _saveStudent(StudentData studentData) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(studentData.toMap());

    FirebaseFirestore.instance
        .collection('students')
        .doc(id)
        .set(studentData.toMap());

    FirebaseFirestore.instance
        .collection('users')
        .doc(nowId)
        .collection('students')
        .doc(id)
        .set(studentData.toMap());
  }

  void loadStudents() async {
    currentUser = _auth.currentUser;
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('students')
        .get();

    students = query.docs.map((doc) => StudentData.fromDocument(doc)).toList();
    notifyListeners();
  }

  Future<Null> loadCurrentUser() async {
    if (currentUser == null) {
      currentUser = _auth.currentUser;
    }
    if (currentUser != null) {
      if (userData['name'] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        userData = docUser.data();
      }
    }
    notifyListeners();
  }
}
