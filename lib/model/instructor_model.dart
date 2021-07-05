import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:power_gym/data/instructor_data.dart';
import 'package:power_gym/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class InstructorModel extends Model {
  UserModel user;

  List<InstructorData> _instructors = [];

  List<InstructorData> get instructors => _instructors.toList();

  set _listInstructors(List<InstructorData> value) {
    _instructors = value;
    notifyListeners();
  }

  void newGender(bool selected, String gender) {
    _newGender = gender;
    _newSelected = selected;
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

  DateTime _date;

  DateTime get date => _date;

  set _newDate(DateTime value) {
    _date = value;
    notifyListeners();
  }

  void pickDate(DateTime date) {
    _newDate = date;
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

  static InstructorModel of(BuildContext context) =>
      ScopedModel.of<InstructorModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    if (user.isLoaggedIn()) {
      loadInstructors();
    }
  }

  InstructorModel(this.user) {
    if (user.isLoaggedIn()) {
      loadInstructors();
    }
  }

  bool isLoading = false;

  Future<void> saveInstructor(
    InstructorData instructorData,
    VoidCallback onSuccess,
    VoidCallback onFail,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection('instructors')
          .add(instructorData.toMap())
          .then((value) {
        instructorData.uid = value.id;
      });
      loadInstructors();

      onSuccess();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      onFail();
    }

    notifyListeners();
  }

  Future<void> deleteInstructor(
    String id,
    VoidCallback onSuccess,
    VoidCallback onFail,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      Future.wait([
        FirebaseFirestore.instance.collection('instructors').doc(id).delete(),
      ]).then((value) {
        loadInstructors();
      });

      onSuccess();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      onFail();
    }
  }

  Future<void> editInstructor(
    InstructorData instructorData,
    String uid,
    VoidCallback onSuccess,
    VoidCallback onFail,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      Future.wait([
        FirebaseFirestore.instance
            .collection('instructors')
            .doc(uid)
            .update(instructorData.toMap()),
      ]).then((value) {
        loadInstructors();
        onSuccess();
        isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      onFail();
    }

    notifyListeners();
  }

  void uploadFile(File _image, String name) async {
    isLoading = true;
    notifyListeners();

    FirebaseStorage storageReference = FirebaseStorage.instance;
    Reference ref = storageReference
        .ref()
        .child('instructors')
        .child(name)
        .child('${_image.path}');
    ref.putFile(_image).whenComplete(() {
      print('Upload completed');
      return;
    });
  }

  void loadInstructors() async {
    QuerySnapshot query =
        await FirebaseFirestore.instance.collection('instructors').get();

    _listInstructors =
        query.docs.map((doc) => InstructorData.fromDocument(doc)).toList();
    notifyListeners();
  }
}
