import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:power_gym/data/categories_data.dart';
import 'package:power_gym/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoriesModel extends Model {
  UserModel user;

  bool isLoading = false;

  List<CategoriesData> _categories = [];

  List<CategoriesData> get categories => _categories;

  set _listCategories(List<CategoriesData> value) {
    _categories = value;
    notifyListeners();
  }

  List<String> _time = [];

  List<String> get time => _time;

  set _newTime(String value) {
    _time = [..._time, value];
    notifyListeners();
  }

  void pickTime(String time) {
    _newTime = time;
    notifyListeners();
  }

  String _instructorName;

  String get instructorName => _instructorName;

  set _newInstructorName(String value) {
    _instructorName = value;
    notifyListeners();
  }

  void pickIntructor(String valueName) {
    _newInstructorName = valueName;

    notifyListeners();
  }

  static CategoriesModel of(BuildContext context) =>
      ScopedModel.of<CategoriesModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    if (user.isLoaggedIn()) {
      loadCategories();
    }
  }

  CategoriesModel(this.user) {
    if (user.isLoaggedIn()) {
      loadCategories();
    }
  }

  Future<void> saveCategorie(
    CategoriesData categoriesData,
    VoidCallback onSuccess,
    VoidCallback onFail,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection('categories')
          .add(categoriesData.toMap())
          .then((value) {
        categoriesData.id = value.id;
      });

      loadCategories();

      onSuccess();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      onFail();
      print(e);
      isLoading = false;
      notifyListeners();
    }

    notifyListeners();
  }

  Future<void> deleteCategorie(
    String id,
    VoidCallback onSuccess,
    VoidCallback onFail,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection('categories')
          .doc(id)
          .delete();

      loadCategories();

      onSuccess();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      onFail();
    }

    notifyListeners();
  }

  void loadCategories() async {
    QuerySnapshot query =
        await FirebaseFirestore.instance.collection('categories').get();

    _listCategories =
        query.docs.map((doc) => CategoriesData.fromDocument(doc)).toList();
    notifyListeners();
  }

  Future<void> registerOrUnscheduleInHour(
    CategoriesData categorie,
    VoidCallback onSuccess,
    VoidCallback onFail,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categorie.id)
          .update(categorie.toMap());
          

      loadCategories();

      onSuccess();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      onFail();
    }

    notifyListeners();
  }
}
