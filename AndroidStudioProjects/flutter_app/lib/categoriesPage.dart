import 'package:flutter/material.dart';
import 'package:flutter_app/models/categories.dart';
import 'package:flutter_app/databases/db.dart';
import 'package:flutter_app/models/entries.dart';

class CategoriesPage extends StatefulWidget {

  CategoriesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  String _category;
  String _description;
  double _monthlyBudget;

  final catController = TextEditingController();
  final descController = TextEditingController();
  final budgetController = TextEditingController();

  List<Categories> _categories = [];
  List<Entries> _entries = [];

  TextStyle _style = TextStyle(color: Colors.black, fontSize: 24);

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
                  Text(getTotalEntriesAmount(item.name) + " / " + item.monthlyBudget.toString(), style: _style,)
                ]
            ),
            onPressed: () => _edit(context, item),
          )
      ),
      onDismissed: (DismissDirection direction) => _delete(item),
    );
  }

  String getTotalEntriesAmount(String categoryName) {
    double totalAmount = 0;
    for(Entries e in _entries) {
      if(e.category.contains(categoryName)) {
        totalAmount += e.amount;
      }
    }
    return totalAmount.toString();
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
                  onChanged: (value) { _monthlyBudget = double.parse(value); },
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
                  controller: catController..text = item.name,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: 'Category Name',
                      hintText: 'e.g. Rent',
                  ),
                ),
                TextFormField(
                  controller: descController..text = item.description,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextFormField(
                  controller: budgetController..text = item.monthlyBudget.toString(),
                  decoration: InputDecoration(
                    labelText: 'Monthly Budget',
                    hintText: 'Enter a number'
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  void _save() async {
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
    _category = catController.text;
    _description = descController.text;
    _monthlyBudget = double.parse(budgetController.text);
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
    List<Map<String, dynamic>> _entryResults = await DB.query(Entries.table);
    _categories = _results.map((item) => Categories.fromMap(item)).toList();
    _entries = _entryResults.map((item) => Entries.fromMap(item)).toList();
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: Center(
          child: ListView( children: _items ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { _create(context); },
        tooltip: 'New Category',
        child: Icon(Icons.library_add),
      ),
    );
  }
}