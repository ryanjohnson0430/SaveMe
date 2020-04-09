import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReportsPageState();
  }
}


//pie chart
class _ReportsPageState extends State<ReportsPage>{

  List<PieChartSectionData> _sections = List<PieChartSectionData>();

  @override
  void initState() {
    super.initState();

    PieChartSectionData item1 = PieChartSectionData(
        color: Colors.blueAccent,
        value: 40,
        title: 'food',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white,fontSize: 24),
    );

    PieChartSectionData item2 = PieChartSectionData(
      color: Colors.orangeAccent,
      value: 20,
      title: 'car',
      radius: 50,
      titleStyle: TextStyle(color: Colors.white,fontSize: 24),
    );

    PieChartSectionData item3 = PieChartSectionData(
      color: Colors.redAccent,
      value: 30,
      title: 'clothes',
      radius: 50,
      titleStyle: TextStyle(color: Colors.white,fontSize: 24),
    );

    PieChartSectionData item4 = PieChartSectionData(
      color: Colors.yellowAccent,
      value: 10,
      title: 'rent',
      radius: 50,
      titleStyle: TextStyle(color: Colors.white,fontSize: 24),
    );

    _sections = [item1, item2, item3, item4];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: AspectRatio(
          aspectRatio: 1,
          child: FlChart(
            chart: PieChart(
              PieChartData(
                  sections: _sections,
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 50,
              sectionsSpace: 0
              ),
            ),
          ),
        ),
    );
  }
}