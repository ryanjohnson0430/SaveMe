import 'package:flutter_app/models/model.dart';

class Entries extends Model{

  static String table = 'entries';

  int id;
  String category;
  String entry;
  double amount;

  Entries({this.id, this.category, this.entry, this.amount});

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      'category': category,
      'entry': entry,
      'amount': amount
    };

    if (id != null) { map['id'] = id; }
    return map;
  }

  static Entries fromMap(Map<String, dynamic> map) {

    return Entries(
        id: map['id'],
        category: map['category'],
        entry: map['entry'],
        amount: map['amount'].toDouble()
    );

  }

}