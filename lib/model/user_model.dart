import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:power_gym/data/gym_data.dart';
import 'package:power_gym/data/student_data.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  User firebaseUser;

  Map<String, dynamic> _userData = Map();

  Map<String, dynamic> get userData => _userData;

  set _newUserData(Map<String, dynamic> value) {
    _userData = value;
    notifyListeners();
  }

  File _image;

  File get image => _image;

  void newImage(File image) {
    _newImage = image;
    notifyListeners();
  }

  set _newImage(File value) {
    _image = value;
    notifyListeners();
  }

  bool _isSwitched = false;

  bool get isSwitched => _isSwitched;

  set _newIsSwitched(bool value) {
    _isSwitched = value;
    notifyListeners();
  }

  void newIsSwitched(bool value) {
    _newIsSwitched = value;
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

  void pickDate(DateTime date) {
    _newDate = date;
    notifyListeners();
  }

  void newGender(bool selected, String gender) {
    _newGender = gender;
    _newSelected = selected;
    notifyListeners();
  }

  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    loadCurrentUser();
  }

  UserModel() {
    loadCurrentUser();
  }

  void signUp({
    @required Map<String, dynamic> userData,
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) {
    isLoading = true;
    notifyListeners();
    _auth
        .createUserWithEmailAndPassword(
      email: userData['email'],
      password: pass,
    )
        .then((user) async {
      firebaseUser = user.user;

      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> signIn({
    @required String email,
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();

    _newUserData = Map();

    await _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) {
      firebaseUser = user.user;

      loadCurrentUser().then((value) {
        onSuccess();
        isLoading = false;
        notifyListeners();
      });
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async {
    isLoading = true;
    notifyListeners();

    await _auth.signOut().then((value) {
      _newUserData = Map();
      firebaseUser = null;
    });

    isLoading = false;
    notifyListeners();
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<bool> isLoaggedInFuture() async {
    return firebaseUser != null;
  }

  bool isLoaggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this._newUserData = userData;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .set(userData);
  }

  Future<Null> loadCurrentUser() async {
    if (firebaseUser == null) {
      firebaseUser = _auth.currentUser;
    }
    if (firebaseUser != null) {
      if (userData['acad'] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        _newUserData = docUser.data();
      }
    }
    notifyListeners();
  }

  void updateUserAcad(
    GymData gymData,
    String pass,
    File image,
    VoidCallback onSuccess,
    VoidCallback onFail,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      if (pass != '') {
        final cred = EmailAuthProvider.credential(
            email: userData['email'], password: userData['pass']);

        _auth.currentUser.reauthenticateWithCredential(cred).then((value) {
          _auth.currentUser.updateEmail(gymData.email);
          _auth.currentUser.updatePassword(pass);
        });
      }

      if (image != null) {
        await uploadFile(image, _auth.currentUser.uid);

        FirebaseStorage storageReference = FirebaseStorage.instance;
        Reference ref = storageReference
            .ref()
            .child('gyms')
            .child(_auth.currentUser.uid)
            .child('${image.path}');

        await ref.getDownloadURL().then((value) {
          print(value);
          gymData.image = value;
        });
      }

      Future.wait([
        FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser.uid)
            .update(gymData.toMap()),
      ]).whenComplete(() async {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        _newUserData = docUser.data();

        print(userData);
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
  }

  void updateUserStudent(
    StudentData studentData,
    String pass,
    File image,
    VoidCallback onSuccess,
    VoidCallback onFail,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      if (pass != '') {
        final cred = EmailAuthProvider.credential(
            email: userData['email'], password: userData['pass']);

        _auth.currentUser.reauthenticateWithCredential(cred).then((value) {
          _auth.currentUser.updateEmail(studentData.email);
          _auth.currentUser.updatePassword(pass);
        });

        studentData.pass = pass;
      }

      if (image != null) {
        await uploadFileStudent(image, _auth.currentUser.uid);

        FirebaseStorage storageReference = FirebaseStorage.instance;
        Reference ref = storageReference
            .ref()
            .child('students')
            .child(_auth.currentUser.uid)
            .child('${image.path}');

        await ref.getDownloadURL().then((value) {
          print(value);
          studentData.image = value;
        });
      }

      Future.wait([
        FirebaseFirestore.instance
            .collection('students')
            .doc(_auth.currentUser.uid)
            .update(studentData.toMap()),
        FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser.uid)
            .update(studentData.toMap()),
      ]).whenComplete(() async {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        _newUserData = docUser.data();

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
  }

  Future<void> uploadFile(File _image, String uid) async {
    isLoading = true;
    notifyListeners();

    FirebaseStorage storageReference = FirebaseStorage.instance;
    Reference ref =
        storageReference.ref().child('gyms').child(uid).child('${_image.path}');
    await ref.putFile(_image).whenComplete(() {
      print('Upload completed');
      return;
    });
  }

  Future<void> uploadFileStudent(File _image, String uid) async {
    isLoading = true;
    notifyListeners();

    FirebaseStorage storageReference = FirebaseStorage.instance;
    Reference ref = storageReference
        .ref()
        .child('students')
        .child(uid)
        .child('${_image.path}');
    await ref.putFile(_image).whenComplete(() {
      print('Upload completed');
      return;
    });
  }
}
