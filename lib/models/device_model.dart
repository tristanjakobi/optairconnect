class Device {
  bool active;
  int airQuality;
  int degrees;
  int humidity;
  int status;
  String title;
  String userId;
  int id;

  Device(this.id, this.title, this.degrees, this.status, this.humidity,
      this.airQuality, this.active, this.userId);

  Device.fromMap(Map<String, dynamic> data)
      : userId = data['userId'],
        id = data['id'],
        title = data['title'],
        degrees = data['degrees'],
        humidity = data['humidity'],
        airQuality = data['airQuality'],
        status = data['status'],
        active = data['active'];

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'degrees': degrees,
      'humidity': humidity,
      'airQuality': airQuality,
      'status': status,
      'active': active,
      'id': id
    };
  }
}
