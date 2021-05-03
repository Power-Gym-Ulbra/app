import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:power_gym/data/student_data.dart';
import 'package:scoped_model/scoped_model.dart';

class StudentModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String id;
  User currentUser;

  //adm
  String nowId;
  String nowEmail;
  String nowPass;

  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  List<StudentData> students = [];

  StudentModel() {
    _loadStudents();
  }

  static StudentModel of(BuildContext context) =>
      ScopedModel.of<StudentModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    notifyListeners();
  }

  void createStudentFinal(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail,
      @required StudentData studentData}) {
    isLoading = true;
    notifyListeners();

    nowId = currentUser.uid;
    nowEmail = currentUser.email;
    nowPass = '123456789';

    _auth
        .createUserWithEmailAndPassword(
      email: userData['email'],
      password: pass,
    )
        .then((user) async {
      id = user.user.uid;

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

  void _loadStudents() async {
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
