import 'package:flutter/material.dart';
import 'package:flutter_app/models/categories.dart';
import 'package:flutter_app/databases/categories-db.dart';

class CategoriesPage extends StatefulWidget {

  CategoriesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

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
                ]
            ),
            onPressed: () => _showDescription(item),
          )
      ),
      onDismissed: (DismissDirection direction) => _delete(item),
    );
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
      body: Center(
          child: ListView( children: _items )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { _create(context); },
        tooltip: 'New Category',
        child: Icon(Icons.library_add),
      ),
    );
  }
}