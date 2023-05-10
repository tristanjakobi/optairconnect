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
                  padding: EdgeInsets.only(bottom: 60),
                  child: _DeviceTable(widget._dashboardController))),
          Positioned(
            bottom: 5,
            left: 20,
            right: 20,
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
                child: Text("Hinzufügen")),
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
            return DataTable(
                columnSpacing: 20,
                columns: _createDeviceTableColumn(context),
                rows: _createDeviceTableRows(context, devices));
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

  List<DataRow> _createDeviceTableRows(context, List<Device> devices) {
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
                      if (device.burning) {
                        return 'assets/fire.png';
                      } else {
                        return 'assets/circle.png';
                      }
                    }()),
                    onPressed: () {},
                  ),
                ),
              ),
              DataCell(Center(
                child: IconButton(
                  icon: Image.asset(() {
                    if (device.connection) {
                      return 'assets/circle.png';
                    } else {
                      return 'assets/circle.png';
                    }
                  }()),
                  onPressed: () {},
                ),
              )),
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
                          0, _titleFieldController.text, 0, false, false));
                      _titleFieldController.clear();
                      widget._refreshList();
                    }
                  },
                  child: Text('Add Device'),
                )),
          ],
        ),
      ),
    );
  }
}
