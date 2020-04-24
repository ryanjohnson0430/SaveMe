import 'package:flutter_app/models/model.dart';

class Categories extends Model{

  static String table = 'categories';

  int id;
  String name;
  String description;
  double monthlyBudget;

  Categories({this.id, this.name, this.description, this.monthlyBudget});

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      'name': name,
      'description': description,
      'monthlyBudget': monthlyBudget
    };

    if (id != null) { map['id'] = id; }
    return map;
  }

  static Categories fromMap(Map<String, dynamic> map) {

    return Categories(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      monthlyBudget: map['monthlyBudget'].toDouble()
    );

  }

}