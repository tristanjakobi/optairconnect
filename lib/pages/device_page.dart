import 'dart:async';

import 'package:flutter/material.dart';
import 'package:optairconnect/controllers/device_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../controllers/dashboard_controller.dart';
import '../models/device_model.dart';

class DevicePage extends StatefulWidget {
  DevicePage({super.key, required this.id});
  final String id;
  final DeviceController _deviceController = DeviceController();

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  void _refreshList() {
    setState(() {});
  }

  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(const Duration(seconds: 5), (Timer t) => _refreshList());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Device?>(
        future: widget._deviceController.getDevice(widget.id as int),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading..'));
          } else {
            final device = snapshot.data!;
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
        });
  }
}
