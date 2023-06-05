import 'package:firebase_auth/firebase_auth.dart';
import 'package:optairconnect/repositories/device_interface.dart';
import 'package:firebase_database/firebase_database.dart';
import '../db/mock_db.dart';
import '../models/device_model.dart';

class DeviceRepository implements IDeviceRepository {
  @override
  Future<List<Device>> getAll() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('device/').get();
    if (snapshot.exists) {
      List<Device> devices = [];
      List<dynamic> values = snapshot.value as List<dynamic>;
      values.forEach((element) {
        try {
          devices.add(Device.fromMap(Map<String, dynamic>.from(element)));
        } catch (e) {
          print(e);
        }
      });

      return devices;
    } else {
      return [];
    }
  }

  @override
  Future<Device?> getOne(int id) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('device/$id').get();

    if (snapshot.exists) {
      final values = Map<String, dynamic>.from(snapshot.value
          as Map<dynamic, dynamic>); // Convert to Map<String, dynamic>

      return Device.fromMap(values);
    } else {
      print('No data available.');
      return null;
    }
  }

  @override
  Future<void> insert(Device device) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('device/${device.id}');
    await ref.set(device.toMap());
  }

  @override
  Future<void> update(Device device) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('device/${device.id}');
    await ref.update(device.toMap());
  }

  @override
  Future<void> delete(int id) async {}
}
