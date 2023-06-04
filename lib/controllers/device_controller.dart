import '../db/mock_db.dart';
import '../models/device_model.dart';
import '../repositories/device_repository.dart';

class DeviceController {
  final DeviceRepository _deviceRepository = DeviceRepository();

  Future<Device?> getDevice(int id) {
    return _deviceRepository.getOne(id);
  }

  List getHistoricData(Device device) {
    return [];
  }
}
