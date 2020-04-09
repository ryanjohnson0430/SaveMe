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
  String _description;
  int _monthlyBudget;

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
            onPressed: () => _edit(context, item),
          )
      ),
      onDismissed: (DismissDirection direction) => _delete(item),
    );
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
                  onPressed: () {
                    _save();
                  }
              )
            ],
            content: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Category Name', hintText: 'e.g. Rent'),
                  onChanged: (value) { _category = value; },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a Name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (value) { _description = value; },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Monthly Budget', hintText: 'Enter a Number'),
                  onChanged: (value) { _monthlyBudget = int.parse(value); },
                )
              ],
            ),
          );
        }
    );
  }

  void _edit(BuildContext context, Categories item) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Edit Category"),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop()
              ),
              FlatButton(
                  child: Text('Save'),
                  onPressed: () {
                    _update(item);
                  }
              )
            ],
            content: Column(
              children: <Widget>[
                TextFormField(
                  controller: TextEditingController()..text = item.name,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: 'Category Name',
                      hintText: 'e.g. Rent',
                  ),
                  onChanged: (value) { _category = value; },
                ),
                TextFormField(
                  controller: TextEditingController()..text = item.description,
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (value) { _description = value; },
                ),
                TextFormField(
                  controller: TextEditingController()..text = item.monthlyBudget.toString(),
                  decoration: InputDecoration(
                    labelText: 'Monthly Budget',
                    hintText: 'Enter a number'
                  ),
                  onChanged: (value) { _monthlyBudget = int.parse(value); },
                )
              ],
            ),
          );
        }
    );
  }

  void _save() async {
    final missingName = SnackBar(content: Text('Please enter a name!'));
    if(_category == '' || _category == ' ' ) {
      Scaffold.of(context).showSnackBar(missingName);
      return;
    }
    Navigator.of(context).pop();
    Categories item = Categories(
        name: _category,
        description: _description,
        monthlyBudget: _monthlyBudget
    );

    await DB.insert(Categories.table, item);
    setState(() => _category = '' );
    setState(() => _description = '' );
    setState(() => _monthlyBudget = 0 );
    refresh();
  }

  void _update(Categories item) async {
    Navigator.of(context).pop();

    if(_category != '')
      item.name = _category;
    if(_description != '')
      item.description = _description;
    if(_monthlyBudget != 0)
      item.monthlyBudget = _monthlyBudget;

    await DB.update(Categories.table, item);
    setState(() => _category = '' );
    setState(() => _description = '' );
    setState(() => _monthlyBudget = 0 );
    refresh();
  }

  void _delete(Categories item) async {

    DB.delete(Categories.table, item);
    refresh();
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