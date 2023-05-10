import 'package:optairconnect/repositories/device_interface.dart';

import '../db/mock_db.dart';
import '../models/device_model.dart';

class DeviceRepository implements IDeviceRepository {
  final VirtualDB _db;

  DeviceRepository(this._db);

  @override
  Future<List<Device>> getAll() async {
    var items = await _db.list();
    return items.map((item) => Device.fromMap(item)).toList();
  }

  @override
  Future<Device?> getOne(int id) async {
    var item = await _db.findOne(id);
    return item != null ? Device.fromMap(item) : null;
  }

  @override
  Future<void> insert(Device device) async {
    await _db.insert(device.toMap());
  }

  @override
  Future<void> update(Device device) async {
    await _db.update(device.toMap());
  }

  @override
  Future<void> delete(int id) async {
    await _db.remove(id);
  }
}
