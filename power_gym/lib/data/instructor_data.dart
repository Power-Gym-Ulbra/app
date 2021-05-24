import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class InstructorData extends Model {
  String uid;
  String name;
  String image;
  String gender;
  String birthday;

  InstructorData();

  InstructorData.fromDocument(DocumentSnapshot document) {
    uid = document.id;
    name = document.get('name');
    image = document.get('image');
    gender = document.get('gender');
    birthday = document.get('birthday');

  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'gender': gender,
      'birthday': birthday
    };
  }
}
