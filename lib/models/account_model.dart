class Account {
  final int id;
  final String name;
  final String email;
  final String password;

  Account(this.id, this.name, this.email, this.password);

  Account.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        email = data['email'],
        password = data['password'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
