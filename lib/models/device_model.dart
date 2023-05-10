class Device {
  final int id;
  final String title;
  final int degrees;
  final bool burning;
  final bool connection;

  Device(this.id, this.title, this.degrees, this.burning, this.connection);

  Device.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        degrees = data['degrees'],
        burning = data['burning'],
        connection = data['connection'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'degrees': degrees,
      'burning': burning,
      'connection': connection
    };
  }
}
