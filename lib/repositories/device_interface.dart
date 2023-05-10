import 'package:optairconnect/models/device_model.dart';

abstract class IDeviceRepository {
  Future<List<Device>> getAll();
  Future<Device?> getOne(int id);
  Future<void> insert(Device device);
  Future<void> update(Device device);
  Future<void> delete(int id);
}
