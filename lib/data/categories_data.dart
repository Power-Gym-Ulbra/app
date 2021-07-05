
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesData {
  String id;
  String categorieName;
  String instructor;

  List timeTable;

  CategoriesData();

  CategoriesData.fromDocument(DocumentSnapshot document) {
    id = document.id;
    categorieName = document.get('categorieName');
    timeTable = document.get('timeTable');
    instructor = document.get('instructor');
  }

  Map<String, dynamic> toMap() {
    return {
      'categorieName': categorieName,
      'timeTable': timeTable,
      'instructor': instructor
    };
  }
}

class TimeTable {
  String hour;
  List<String> students;

  TimeTable([map, map2]);

  Map<String, dynamic> toMap() {
    return {
      'hour': hour,
      'students': students,
    };
  }

  TimeTable.fromDocument(DocumentSnapshot document) {
    hour = document.get('hour');
    students = document.get('students');
  }
  
}
