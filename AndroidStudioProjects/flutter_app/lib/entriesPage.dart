import 'package:flutter/material.dart';
import 'package:flutter_app/models/entries.dart';
import 'package:flutter_app/models/categories.dart';
import 'package:flutter_app/databases/db.dart';

class EntriesPage extends StatefulWidget {
  @override
  EntriesPageState createState() {
    return EntriesPageState();
  }
}

class EntriesPageState extends State<EntriesPage> {

  final _formKey = GlobalKey<FormState>();
  List<Categories> _categories = [];
  List<Entries> _entries = [];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCategory;
  TextStyle _style = TextStyle(color: Colors.black, fontSize: 20);

  List<Widget> get _items => _entries.map((item) => format(item)).toList();

  String _currentEntry;
  double _currentAmount;

  @override
  void initState()  {
    refresh();
    super.initState();
  }

  void refresh() async {
    List<Map<String, dynamic>> _entryResults = await DB.query(Entries.table);
    List<Map<String, dynamic>> _results = await DB.query(Categories.table);
    _categories = _results.map((item) => Categories.fromMap(item)).toList();
    _entries = _entryResults.map((item) => Entries.fromMap(item)).toList();
    _dropDownMenuItems = getDropDownMenuItems();
    setState(() { });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (Categories category in _categories) {
      items.add(new DropdownMenuItem(
          value: category.name,
          child: new Text(category.name)
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DropdownButton(
            style: TextStyle(fontSize: 20, color: Colors.black),
            isExpanded: true,
            hint: Text("Select a Category"),
            value: _currentCategory,
            items: _dropDownMenuItems,
            onChanged: changedDropDownItem,
          ),
          TextFormField(
            style: _style,
            onChanged: (value) { _currentEntry = value; },
            decoration: InputDecoration(labelText: 'Entry', hintText: 'e.g. Burrito'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a name for the entry';
              }
              return null;
            },
          ),
          TextFormField(
            style: _style,
              onChanged: (value) { _currentAmount = double.parse(value); },
              decoration: InputDecoration(labelText: 'Amount', hintText: 'enter an amount'),
              validator: (value) {
              if(value.isEmpty) {
                return 'Please enter an amount';
              }
              return null;
            }
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate() && _currentCategory.isNotEmpty) {
                  addEntry();
                }
              },
              child: Text('Submit Entry'),
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Category", style: _style),
                Text("Entry", style: _style),
                Text("Amount", style: _style)
              ]
          ),
          Container(height: 2, width: MediaQuery.of(context).size.width, color: Colors.grey,
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),),
          Expanded(
            child: ListView(
              children: _items
            )
          )
        ],
      ),
    );
  }

  void addEntry() async {
    Entries item = Entries(
        category: _currentCategory,
        entry: _currentEntry,
        amount: _currentAmount,
    );

    await DB.insert(Entries.table, item);
    refresh();
  }

  void changedDropDownItem(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
    });
  }

  Widget format(Entries item) {
    return Dismissible(
      key: Key(item.id.toString()),
      child: Padding(
          padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
          child: FlatButton(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(item.category, style: _style,),
                  Text(item.entry, style: _style),
                  Text(item.amount.toString(), style: _style,)
                ]
            ),
            onPressed: () => enterDialog(item),
          )
      ),
      onDismissed: (DismissDirection direction) => _delete(item),
    );
  }

  void enterDialog(Entries item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Entry Information"),
            content: new Text("Category:  " + item.category + "\n\nEntry:  " +
                item.entry + "\n\nAmount:  " + item.amount.toString()),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                }
              )
            ],
          );
        }
    );
  }

  void _delete(Entries item) async {
    DB.delete(Entries.table, item);
    refresh();
  }

}