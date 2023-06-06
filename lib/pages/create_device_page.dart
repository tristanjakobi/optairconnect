import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'dart:convert';
import 'package:flutter_blue/flutter_blue.dart';

class CreateDevicePage extends StatefulWidget {
  @override
  _CreateDevicePageState createState() => _CreateDevicePageState();
}

class _CreateDevicePageState extends State<CreateDevicePage> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  final _database = FirebaseDatabase.instance.reference();
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? _selectedDevice;

  String generateToken({int length = 16}) {
    const _allowedChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final _rand = Random();
    return List.generate(length,
        (index) => _allowedChars[_rand.nextInt(_allowedChars.length)]).join();
  }

  void scanForDevices() async {
    await flutterBlue.startScan(timeout: Duration(seconds: 4));

    // Handle results as they come
    var subscription = flutterBlue.scanResults.listen((results) async {
      // Show dialog to select device
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select a device'),
            content: Container(
              width: double.maxFinite,
              child: ListView(
                children: results
                    .map((r) => ListTile(
                          title: Text(r.device.name),
                          onTap: () {
                            Navigator.pop(context, r.device);
                          },
                        ))
                    .toList(),
              ),
            ),
          );
        },
      ).then((device) {
        if (device != null) {
          setState(() {
            _selectedDevice = device as BluetoothDevice;
          });
        }
      });
    });

    flutterBlue.stopScan();
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    List<BluetoothService> services = await device.discoverServices();
    BluetoothService service = services.firstWhere(
        (s) => s.uuid == Guid('4fafc201-1fb5-459e-8fcc-c5c9c331914b'),
        orElse: () => throw Exception('Service not found'));
    BluetoothCharacteristic characteristic = service.characteristics.firstWhere(
        (c) => c.uuid == Guid('beb5483e-36e1-4688-b7f5-ea07361b26a8'),
        orElse: () => throw Exception('Characteristic not found'));
    await characteristic.write(utf8.encode(_ssidController.text +
        "," +
        _passwordController.text +
        "," +
        _titleController.text +
        "," +
        generateToken()));
    await device.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configure Device'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _ssidController,
              decoration: InputDecoration(labelText: 'SSID'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: scanForDevices,
              child: Text('Select Device'),
            ),
            Text('Selected Device: ${_selectedDevice?.name ?? 'None'}'),
            ElevatedButton(
              onPressed: _selectedDevice != null
                  ? () {
                      connectToDevice(_selectedDevice!);
                    }
                  : null,
              child: Text('Connect and Send Data'),
            ),
          ],
        ),
      ),
    );
  }
}
