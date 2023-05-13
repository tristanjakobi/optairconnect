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
      body: Stack(
        children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: _DeviceTable(widget._dashboardController))),
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.tertiary,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Stack(
                            children: <Widget>[
                              _Form(widget._dashboardController, _refreshList),
                            ],
                          ),
                        );
                      });
                },
                child: const Text("Hinzufügen")),
          )
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
    _dashboardController.addDevice(Device(1, 0, 'Wohnzimmer', 20, 0, 100, 100));
    _dashboardController
        .addDevice(Device(2, 0, 'Schlafzimmer', 18, 0, 100, 100));
    _dashboardController
        .addDevice(Device(3, 0, 'Schlafzimmer', 26, 0, 100, 100));
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
                Text('Brand', style: Theme.of(context).textTheme.bodyMedium)),
      ];
    }
    return [
      DataColumn(
          label: Text('Gerät', style: Theme.of(context).textTheme.bodyMedium)),
      DataColumn(
          label: Text('Temperatur',
              style: Theme.of(context).textTheme.bodyMedium)),
      DataColumn(
          label: Text('Brand', style: Theme.of(context).textTheme.bodyMedium)),
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
              DataCell(Text(device.title.toString(),
                  style: Theme.of(context).textTheme.bodySmall)),
              DataCell(Text(device.degrees.toString(),
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

class _Form extends StatefulWidget {
  final DashboardController _dashboardController;
  final VoidCallback _refreshList;

  _Form(this._dashboardController, this._refreshList);

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleFieldController = TextEditingController();

  @override
  void dispose() {
    _titleFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _titleFieldController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Device title';
                }
                return null;
              },
            ),
            Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget._dashboardController.addDevice(Device(
                          0, 0, _titleFieldController.text, 100, 1, 100, 100));
                      _titleFieldController.clear();
                      widget._refreshList();
                    }
                  },
                  child: const Text('Add Device'),
                )),
          ],
        ),
      ),
    );
  }
}
