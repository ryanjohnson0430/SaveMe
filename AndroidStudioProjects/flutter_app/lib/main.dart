import 'package:flutter/material.dart';
import 'package:flutter_app/homeWidget.dart';
import 'package:flutter_app/databases/db.dart';
import 'package:flutter_app/reportsPage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pie_chart/pie_chart.dart';

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
      theme: ThemeData( primarySwatch: Colors.grey ),
      home: HomeWidget(title: 'SaveMe'),
    );
  }
}
