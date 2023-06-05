import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:optairconnect/controllers/device_controller.dart';
import 'package:optairconnect/shared/optair_wrapper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../controllers/dashboard_controller.dart';
import '../models/device_model.dart';

Future<List<Map<String, dynamic>>> fetchHistoricData(
    String deviceId, int range) async {
  final ref = FirebaseDatabase.instance.ref().child('historic_data/$deviceId');
  final DataSnapshot snapshot = await ref.get();
  if (snapshot.value is Map<dynamic, dynamic>) {
    List<Map<String, dynamic>> data = [];
    Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
    values.forEach((key, value) {
      Map<String, dynamic> entry = Map<String, dynamic>.from(value);
      entry['id'] = key;
      // Convert the Unix timestamp to a DateTime
      entry['timestamp'] =
          DateTime.fromMillisecondsSinceEpoch(entry['timestamp'] * 1000);
      data.add(entry);
    });
    // Sort the data based on timestamp
    data.sort((a, b) =>
        (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));

    // Filter the data based on the range
    DateTime now = DateTime.now();
    data = data
        .where((datum) => now.difference(datum['timestamp']).inDays <= range)
        .toList();

    return data;
  } else {
    return [];
  }
}

class DevicePage extends StatefulWidget {
  DevicePage({super.key, required this.id});
  final String id;
  final DeviceController _deviceController = DeviceController();

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  String _deviceTitle = '';

  @override
  void initState() {
    super.initState();
    fetchDeviceTitle();
  }

  Future<void> fetchDeviceTitle() async {
    final deviceRef = FirebaseDatabase.instance
        .ref()
        .child('device')
        .child(widget.id)
        .child('title');
    final deviceSnapshot = await deviceRef.once();
    final deviceTitle = deviceSnapshot.snapshot.value as String?;
    if (deviceTitle != null) {
      setState(() {
        _deviceTitle = deviceTitle;
      });
    }
  }

  int _selectedRange = 30;

  @override
  Widget build(BuildContext context) {
    return OptAirWrapper(
      title: _deviceTitle,
      body: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButton<int>(
              value: _selectedRange,
              items: <DropdownMenuItem<int>>[
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('Letzen 24 Stunden',
                      style: Theme.of(context).textTheme.bodySmall),
                ),
                DropdownMenuItem<int>(
                  value: 7,
                  child: Text('Letzen 7 Tage',
                      style: Theme.of(context).textTheme.bodySmall),
                ),
                DropdownMenuItem<int>(
                  value: 30,
                  child: Text('Letzen 30 Tage',
                      style: Theme.of(context).textTheme.bodySmall),
                ),
              ],
              onChanged: (int? newValue) {
                setState(() {
                  _selectedRange = newValue!;
                });
              },
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchHistoricData(widget.id, _selectedRange),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final data = snapshot.data!;
                  return Column(
                    children: [
                      SfCartesianChart(
                        title: ChartTitle(text: 'Temperatur'),
                        primaryYAxis: NumericAxis(),
                        primaryXAxis: DateTimeAxis(
                          minimum: DateTime.now()
                              .subtract(Duration(days: _selectedRange)),
                          maximum: DateTime.now(),
                        ),
                        series: <LineSeries<Map<String, dynamic>, DateTime>>[
                          LineSeries<Map<String, dynamic>, DateTime>(
                            dataSource: data,
                            xValueMapper: (datum, _) => datum['timestamp'],
                            yValueMapper: (datum, _) => datum['degrees'],
                            name: 'Temperatur in °C',
                          ),
                        ],
                      ),
                      SfCartesianChart(
                        primaryYAxis: NumericAxis(
                          minimum: 0,
                          maximum: 100,
                          interval: 10,
                        ),
                        title: ChartTitle(text: 'Luftfeuchtigkeit'),
                        primaryXAxis: DateTimeAxis(
                          minimum: DateTime.now()
                              .subtract(Duration(days: _selectedRange)),
                          maximum: DateTime.now(),
                        ),
                        series: <LineSeries<Map<String, dynamic>, DateTime>>[
                          LineSeries<Map<String, dynamic>, DateTime>(
                            dataSource: data,
                            xValueMapper: (datum, _) => datum['timestamp'],
                            yValueMapper: (datum, _) => datum['humidity'],
                            name: 'Luftfeuchtigkeit in %',
                          ),
                        ],
                      ),
                      SfCartesianChart(
                        title: ChartTitle(text: 'Luftqualität'),
                        primaryXAxis: DateTimeAxis(
                          minimum: DateTime.now()
                              .subtract(Duration(days: _selectedRange)),
                          maximum: DateTime.now(),
                        ),
                        series: <LineSeries<Map<String, dynamic>, DateTime>>[
                          LineSeries<Map<String, dynamic>, DateTime>(
                            dataSource: data,
                            xValueMapper: (datum, _) => datum['timestamp'],
                            yValueMapper: (datum, _) => datum['airQuality'],
                            name: 'Luftqualität',
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
