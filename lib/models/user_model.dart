/// A single User object.
class UserModel {
  /// ID number of the user
  int? id;

  /// First name
  String? firstName;

  /// Last name
  String? lastName;

  /// Email address
  String? email;

  /// Date of birth
  DateTime? dateOfBirth;

  /// Username
  String? username;

  /// Password
  String? password;

  UserModel(
      {this.firstName,
      this.lastName,
      this.email,
      this.dateOfBirth,
      this.username,
      this.password});

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        // only try to parse date of birth if it is not null
        dateOfBirth = json['dateOfBirth'] != null
            ? DateTime.parse(json['dateOfBirth'])
            : null,
        username = json['username'],
        password = json['password'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      // convert date of birth to a string first
      'dateOfBirth': dateOfBirth!.toIso8601String(),
      'username': username,
      'password': password
    };
  }

  @override
  String toString() {
    return "UserModel object: $firstName | $lastName | $email | $dateOfBirth | $username | $password";
  }
}
