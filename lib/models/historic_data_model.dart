class Device {
  final int id;
  final int deviceId;

  Device(this.id, this.deviceId);

  Device.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        deviceId = data['deviceId'];

  Map<String, dynamic> toMap() {
    return {'id': id, 'deviceId': deviceId};
  }
}
