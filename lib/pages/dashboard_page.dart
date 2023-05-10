import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optairconnect/controllers/dashboard_controller.dart';
import 'package:optairconnect/shared/optair_wrapper.dart';

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

  @override
  Widget build(BuildContext context) {
    return OptAirWrapper(
        title: 'Dashboard',
        body: Expanded(child: _DeviceTable(widget._dashboardController)));
  }
}

class _DeviceTable extends StatelessWidget {
  final DashboardController _dashboardController;

  const _DeviceTable(this._dashboardController);

  @override
  Widget build(BuildContext context) {
    _dashboardController.addDevice(Device(1, 'Wohnzimmer', 20, false, true));
    _dashboardController.addDevice(Device(2, 'Schlafzimmer', 18, false, true));
    _dashboardController.addDevice(Device(3, 'Schlafzimmer', 26, true, true));
    return FutureBuilder<List<Device>>(
        future: _dashboardController.getAllDevices(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading..'));
          } else {
            final devices = snapshot.data!;
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: devices
                    .map((device) => DataTable(
                        columnSpacing: 20,
                        columns: _createDeviceTableColumn(context),
                        rows: _createDeviceTableRow(context, device)))
                    .toList());
          }
        });
  }

  List<DataColumn> _createDeviceTableColumn(context) {
    return [
      DataColumn(
          label: Text('Gerät', style: Theme.of(context).textTheme.bodyMedium)),
      DataColumn(
          label: Text('°C', style: Theme.of(context).textTheme.bodyMedium)),
      DataColumn(
          label: Text('Brand', style: Theme.of(context).textTheme.bodyMedium)),
      DataColumn(
          label: Text('Verbindung',
              style: Theme.of(context).textTheme.bodyMedium)),
    ];
  }

  List<DataRow> _createDeviceTableRow(context, device) {
    return [
      DataRow(cells: [
        DataCell(Text(device.title.toString(),
            style: Theme.of(context).textTheme.bodySmall)),
        DataCell(Text(device.degrees.toString(),
            style: Theme.of(context).textTheme.bodySmall)),
        DataCell(
          IconButton(
            icon: Image.asset(() {
              if (device.burning) {
                return 'assets/fire.png';
              } else {
                return 'assets/circle.png';
              }
            }()),
            onPressed: () {},
          ),
        ),
        DataCell(
          IconButton(
            icon: Image.asset(() {
              if (device.connection) {
                return 'assets/circle.png';
              } else {
                return 'assets/circle.png';
              }
            }()),
            onPressed: () {},
          ),
        ),
      ])
    ];
  }
}
