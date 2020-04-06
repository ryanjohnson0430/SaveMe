import 'package:flutter/material.dart';
import 'package:flutter_app/homeWidget.dart';
import 'package:flutter_app/databases/categories-db.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await DB.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData( primarySwatch: Colors.indigo ),
      home: HomeWidget(title: 'SaveMe'),
    );
  }
}
