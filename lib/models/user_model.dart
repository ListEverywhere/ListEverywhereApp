import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  DateTime? dateOfBirth;
  String? username;
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
