import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_app/models/entries.dart';
import 'package:flutter_app/models/categories.dart';
import 'package:flutter_app/databases/db.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() {
    return _ReportsPageState();
  }
}

class _ReportsPageState extends State<ReportsPage> {

  Map<String, double> dataMap = new Map();
  List<Entries> _entries = [];
  List<Categories> _categories = [];
  List<DataRow> entryData = [];

  void initState()  {
    refresh();
    super.initState();
  }

  void refresh() async {
    List<Map<String, dynamic>> _results = await DB.query(Categories.table);
    List<Map<String, dynamic>> _entryResults = await DB.query(Entries.table);
    _categories = _results.map((item) => Categories.fromMap(item)).toList();
    _entries = _entryResults.map((item) => Entries.fromMap(item)).toList();
    await setDataMap();
    await setEntryData();
    setState(() { });
  }
  
  setEntryData() {
    double totalBudget = 0;
    double totalSpent = 0;

    for(Categories c in _categories) {
      totalBudget+=c.monthlyBudget;
    }

    for(Entries e in _entries) {
      totalSpent+=e.amount;
    }

    for(Categories c in _categories) {
      double categorySum = 0;
      for(Entries e in _entries) {
        if(c.name.contains(e.category))
          categorySum+=e.amount;
      }
      List<DataCell> cellList = [];
      cellList.add(DataCell(Text(c.name)));
      cellList.add(DataCell(Text(((categorySum/totalSpent) * 100).round().toString() + "%")));
      cellList.add(DataCell(Text(((c.monthlyBudget/totalBudget) * 100).round().toString() + "%")));
      entryData.add(DataRow(cells: cellList));
    }
  }
  
  setDataMap() {
    for(Categories c in _categories) {
      double categorySum = 0;
      for(Entries e in _entries) {
        if(c.name.contains(e.category))
          categorySum+=e.amount;
      }
      dataMap.putIfAbsent(c.name, () => categorySum);
    }
  }

  @override
  Widget build(BuildContext context) {
    while(dataMap.isEmpty){
      Map<String, double> placeholder = new Map();
      placeholder.putIfAbsent("empty", ()=> 0);
      return PieChart(
        dataMap: placeholder,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PieChart(
          dataMap: dataMap,
        ),
        DataTable(
          columns: [
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Current')),
            DataColumn(label: Text('Goal'))
          ],
          rows: entryData,
        )
      ],
    );
  }

}