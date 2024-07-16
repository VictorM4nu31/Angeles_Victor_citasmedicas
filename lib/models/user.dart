class User {
  final int? id;
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String middleName;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.middleName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
    };
  }
}
