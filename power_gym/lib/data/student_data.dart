import 'package:cloud_firestore/cloud_firestore.dart';

class StudentData {

  String cid;
  String email;
  String name;
  String gender;
  String birthDate;
  String image;
  String acad;

  StudentData();

  StudentData.fromDocument(DocumentSnapshot document) {
    email = document.get('email');
    name = document.get('name');
    gender = document.get('gender');
    birthDate = document.get('birthDate');
    image = document.get('image');
    acad = document.get('acad');
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'gender': gender,
      'birthDate': birthDate,
      'image': image,
      'acad': acad
    };
  }
}