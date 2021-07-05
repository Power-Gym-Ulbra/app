import 'package:cloud_firestore/cloud_firestore.dart';

class StudentData {

  String uid;
  String email;
  String name;
  String gender;
  String birthDate;
  String image;
  String acad;
  String pass;

  StudentData();

  StudentData.fromDocument(DocumentSnapshot document) {
    uid = document.get('uid');
    email = document.get('email');
    name = document.get('name');
    gender = document.get('gender');
    birthDate = document.get('birthDate');
    image = document.get('image');
    acad = document.get('acad');
    pass = document.get('pass');
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'gender': gender,
      'birthDate': birthDate,
      'image': image,
      'acad': acad,
      'pass': pass
    };
  }
}