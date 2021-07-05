import 'package:cloud_firestore/cloud_firestore.dart';

class GymData {

  String email;
  String name;
  String image;
  String acad;
  String pass;

  GymData();

  GymData.fromDocument(DocumentSnapshot document) {    
    email = document.get('email');
    name = document.get('name');
    pass = document.get('pass');
    image = document.get('image');
    acad = document.get('acad');
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'pass': pass,
      'image': image,
      'acad': acad
    };
  }
}