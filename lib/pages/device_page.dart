import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        // Generate 100 widgets that display their index in the List.
        children: [
          SfCartesianChart(),
          SfCircularChart(),
          SfSparkBarChart(),
          SfRadialGauge(),
        ]);
  }
}
