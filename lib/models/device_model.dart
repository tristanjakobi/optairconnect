class Device {
  final int id;
  final int userId;
  final String title;
  final int degrees;
  final int status;
  final int humidity;
  final int airQuality;

  Device(this.id, this.userId, this.title, this.degrees, this.status,
      this.humidity, this.airQuality);

  Device.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        userId = data['userId'],
        title = data['title'],
        degrees = data['degrees'],
        humidity = data['humidity'],
        airQuality = data['airQuality'],
        status = data['status'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'degrees': degrees,
      'humidity': humidity,
      'air_quality': airQuality,
      'status': status
    };
  }
}
