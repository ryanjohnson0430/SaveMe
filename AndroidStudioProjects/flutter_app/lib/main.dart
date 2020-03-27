import 'package:flutter/material.dart';
import 'package:flutter_app/models/categories.dart';
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
      home: MyHomePage(title: 'SaveMe'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _currentIndex = 0;
  final List<Widget> _children = [];

  String _category;

  List<Categories> _categories = [];

  TextStyle _style = TextStyle(color: Colors.white, fontSize: 24);

  List<Widget> get _items => _categories.map((item) => format(item)).toList();

  Widget format(Categories item) {

    return Dismissible(
      key: Key(item.id.toString()),
      child: Padding(
          padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
          child: FlatButton(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(item.name, style: _style),
//                  Icon(item.complete == true ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: Colors.white)
                ]
            ),
            onPressed: () => _showDescription(item),
          )
      ),
      onDismissed: (DismissDirection direction) => _delete(item),
    );
  }

//  void _toggle(TodoItem item) async {
//
//    item.complete = !item.complete;
//    dynamic result = await DB.update(TodoItem.table, item);
//    print(result);
//    refresh();
//  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showDescription(Categories item) async {
    print(item.description);
  }

  void _delete(Categories item) async {

    DB.delete(Categories.table, item);
    refresh();
  }

  void _save() async {

    Navigator.of(context).pop();
    Categories item = Categories(
        name: _category,
        description: "placeholder description",
        monthlyBudget: 500
    );

    await DB.insert(Categories.table, item);
    setState(() => _category = '' );
    refresh();
  }

  void _create(BuildContext context) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Create New Category"),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop()
              ),
              FlatButton(
                  child: Text('Save'),
                  onPressed: () => _save()
              )
            ],
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(labelText: 'Category Name', hintText: 'e.g. Rent'),
              onChanged: (value) { _category = value; },
            ),
          );
        }
    );
  }

  @override
  void initState() {

    refresh();
    super.initState();
  }

  void refresh() async {

    List<Map<String, dynamic>> _results = await DB.query(Categories.table);
    _categories = _results.map((item) => Categories.fromMap(item)).toList();
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar( title: Text(widget.title) ),
        body: Center(
            child: ListView( children: _items )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () { _create(context); },
          tooltip: 'New Category',
          child: Icon(Icons.library_add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
        currentIndex: _currentIndex, // this will be set when a new tab is tapped
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