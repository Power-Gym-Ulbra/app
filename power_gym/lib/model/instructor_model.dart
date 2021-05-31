import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:power_gym/data/instructor_data.dart';
import 'package:scoped_model/scoped_model.dart';

class InstructorModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  List<InstructorData> _instructors = [];

  List<InstructorData> get instructors => _instructors.toList();

  set _listInstructors(List<InstructorData> value) {
    _instructors = value;
    notifyListeners();
  }

  static InstructorModel of(BuildContext context) =>
      ScopedModel.of<InstructorModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    loadInstructors();
  }

  InstructorModel() {
    loadInstructors();
  }

  bool isLoading = false;

  Future<void> saveInstructor(InstructorData instructorData,
      VoidCallback onSuccess, VoidCallback onFail) async {
    try {
      isLoading = true;
      notifyListeners();

      Future.wait([
        FirebaseFirestore.instance
            .collection('instructors')
            .add(instructorData.toMap())
            .then((value) {
          instructorData.uid = value.id;
        }),
        FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser.uid)
            .collection('instructors')
            .add(instructorData.toMap())
            .then((value) {
          instructorData.uid = value.id;
        }),
      ]).then((value) {
        loadInstructors();
      });

      onSuccess();
      isLoading = false;
      notifyListeners();
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
    UploadTask uploadTask = ref.putFile(_image);
    await uploadTask;

    return;
  }

  void loadInstructors() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .collection('instructors')
        .get();

    _listInstructors =
        query.docs.map((doc) => InstructorData.fromDocument(doc)).toList();
    notifyListeners();
  }
}
