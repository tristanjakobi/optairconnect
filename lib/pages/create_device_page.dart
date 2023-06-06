import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class CreateDevicePage extends StatefulWidget {
  @override
  _CreateDevicePageState createState() => _CreateDevicePageState();
}

class _CreateDevicePageState extends State<CreateDevicePage> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  final _database = FirebaseDatabase.instance.reference();

  String generateToken({int length = 16}) {
    const _allowedChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final _rand = Random();
    return List.generate(length,
        (index) => _allowedChars[_rand.nextInt(_allowedChars.length)]).join();
  }

  Future<Map<String, dynamic>> _saveConfigurationToFirebase() async {
    String title = _titleController.text;
    String token = generateToken();

    // Get current authenticated user
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No user authenticated');
    }

    // Create device in Firebase
    DatabaseReference deviceRef = _database.child('device').push();
    await deviceRef.set({
      'title': title,
      'token': token,
      'userId': user.uid,
    });

    // Save unique ID
    String? deviceId = deviceRef.key;

    // Save SSID and password
    String ssid = _ssidController.text;
    String password = _passwordController.text;

    // Save the configuration in a local variable
    return {
      'ssid': ssid,
      'password': password,
      'deviceId': deviceId,
      'token': token,
      'deviceRef': deviceRef,
    };
  }

  Future<bool> _sendConfigurationToDevice(Map<String, dynamic> config) async {
    String url = "http://192.168.4.1/";

    http.Response response = await http.post(
      Uri.parse(url),
      body: {
        'ssid': config['ssid'],
        'password': config['password'],
        'deviceID': config['deviceId'],
        'token': config['token'],
      },
    );

    return response.statusCode == 200;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure Device'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _ssidController,
              decoration: const InputDecoration(labelText: 'SSID'),
              enabled: true,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              enabled: true,
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              enabled: true,
            ),
            ElevatedButton(
              onPressed: () async {
                final snackBarMessenger = ScaffoldMessenger.of(context);
                Map<String, dynamic> config =
                    await _saveConfigurationToFirebase();
                snackBarMessenger.showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Configuration saved, switch to ESP32 network now.')),
                );

                // Wait for user to confirm that they have switched to ESP32 network
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Did you switch to ESP32 network?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            bool successful =
                                await _sendConfigurationToDevice(config);

                            if (successful) {
                              snackBarMessenger.showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Credentials and device info sent successfully')),
                              );
                              // Close the page after success
                            } else {
                              await config['deviceRef'].remove();
                              snackBarMessenger.showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Error sending credentials and device info')),
                              );
                            }
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Save Configuration'),
            ),
          ],
        ),
      ),
    );
  }
}
