import 'package:flutter/material.dart';
import 'package:flutter_app/entriesPage.dart';
import 'package:flutter_app/reportsPage.dart';
import 'package:flutter_app/categoriesPage.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeWidgetState createState() => _HomeWidgetState();

}

class _HomeWidgetState extends State<HomeWidget> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    CategoriesPage(),
    EntriesPage(Colors.deepOrange),
    ReportsPage(Colors.green)
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar( title: Text(widget.title) ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.category),
            title: new Text('Categories'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.add_box),
            title: new Text('Make an Entry'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              title: Text('Live Reports')
          )
        ],
      ),
    );
  }
}