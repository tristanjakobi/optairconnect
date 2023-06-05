import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optairconnect/controllers/dashboard_controller.dart';
import 'package:optairconnect/shared/optair_wrapper.dart';
import 'package:go_router/go_router.dart';
import '../models/device_model.dart';
import '../shared/optair_entry.dart';

class DashboardPage extends StatefulWidget {
  final DashboardController _dashboardController = DashboardController();

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
    return OptAirWrapper(
      title: 'Dashboard',
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: _DeviceTable(widget._dashboardController)),
        ],
      ),
    );
  }
}

class _DeviceTable extends StatelessWidget {
  final DashboardController _dashboardController;

  const _DeviceTable(this._dashboardController);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    int items = 3;
    if (width > 600) {
      items = 5;
    }

    return FutureBuilder<List<Device>>(
        future: _dashboardController.getAllDevices(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading..'));
          } else {
            final devices = snapshot.data!;
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DataTable(
                  showCheckboxColumn: false,
                  horizontalMargin: 0,
                  columnSpacing: 50,
                  columns: _createDeviceTableColumn(context, items),
                  rows: _createDeviceTableRows(context, devices, items)),
            );
          }
        });
  }

  List<DataColumn> _createDeviceTableColumn(context, items) {
    if (items == 5) {
      return [
        DataColumn(
            label:
                Text('Gerät', style: Theme.of(context).textTheme.bodyMedium)),
        DataColumn(
            label: Text('Luftqualität',
                style: Theme.of(context).textTheme.bodyMedium)),
        DataColumn(
            label: Text('Temperatur',
                style: Theme.of(context).textTheme.bodyMedium)),
        DataColumn(
            label: Text('Luftfeuchtigkeit',
                style: Theme.of(context).textTheme.bodyMedium)),
        DataColumn(
            label:
                Text('Status', style: Theme.of(context).textTheme.bodyMedium)),
      ];
    }
    return [
      DataColumn(
          label: Text('Gerät', style: Theme.of(context).textTheme.bodyMedium)),
      DataColumn(
          label: Text('Temperatur',
              style: Theme.of(context).textTheme.bodyMedium)),
      DataColumn(
          label: Text('Status', style: Theme.of(context).textTheme.bodyMedium)),
    ];
  }

  List<DataRow> _createDeviceTableRows(context, List<Device> devices, items) {
    if (items == 5) {
      return devices
          .map((device) => DataRow(cells: [
                DataCell(Text(device.title.toString(),
                    style: Theme.of(context).textTheme.bodySmall)),
                DataCell(Text("${device.airQuality}%",
                    style: Theme.of(context).textTheme.bodySmall)),
                DataCell(Text("${device.degrees}°C",
                    style: Theme.of(context).textTheme.bodySmall)),
                DataCell(Text("${device.humidity}%",
                    style: Theme.of(context).textTheme.bodySmall)),
                DataCell(
                  IconButton(
                    icon: Image.asset(() {
                      switch (device.status) {
                        case 1:
                          return 'assets/fire.png';
                        case 2:
                          return 'assets/error.png';
                        default:
                          return 'assets/circle.png';
                      }
                    }()),
                    onPressed: () {},
                  ),
                ),
              ]))
          .toList();
    }
    return devices
        .map((device) => DataRow(cells: [
              DataCell(
                  Text(device.title.toString(),
                      style: Theme.of(context).textTheme.bodySmall), onTap: () {
                GoRouter.of(context).go("/device/${device.id}");
              }),
              DataCell(Text("${device.degrees}°C",
                  style: Theme.of(context).textTheme.bodySmall)),
              DataCell(
                Center(
                  child: IconButton(
                    icon: Image.asset(() {
                      switch (device.status) {
                        case 1:
                          return 'assets/fire.png';
                        case 2:
                          return 'assets/error.png';
                        default:
                          return 'assets/circle.png';
                      }
                    }()),
                    onPressed: () {},
                  ),
                ),
              ),
            ]))
        .toList();
  }
}
