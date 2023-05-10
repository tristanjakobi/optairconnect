import '../db/mock_db.dart';
import '../models/device_model.dart';
import '../repositories/device_repository.dart';

class DashboardController {
  final DeviceRepository _deviceRepository = DeviceRepository(VirtualDB());

  Future<List<Device>> getAllDevices() {
    return _deviceRepository.getAll();
  }

  Future<void> addDevice(Device device) {
    return _deviceRepository.insert(device);
  }

  Future<void> removeDevice(int id) {
    return _deviceRepository.delete(id);
  }
}
