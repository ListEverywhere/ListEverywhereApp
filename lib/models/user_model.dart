class UserModel {
  int? id;
  String firstName;
  String lastName;
  String email;
  DateTime dateOfBirth;
  String username;
  String password;

  UserModel(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.dateOfBirth,
      required this.username,
      required this.password});

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        dateOfBirth = DateTime.parse(json['dateOfBirth']),
        username = json['username'],
        password = json['password'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'username': username,
      'password': password
    };
  }

  @override
  String toString() {
    return "UserModel object: $firstName | $lastName | $email | $dateOfBirth | $username | $password";
  }
}
