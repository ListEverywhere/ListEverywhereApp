import 'dart:convert';

import 'package:listeverywhere_app/constants.dart';
import 'package:listeverywhere_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Provides various actions for Users, such as user registration and login
class UserService {
  /// API url
  final String _url = '$apiUrl/users';

  /// Storage instance for storing user token
  final storage = const FlutterSecureStorage();

  /// Name of the key where token is stored
  static const storageKey = 'ListEverywhereToken';

  /// Registers a new account using the user data from [user]
  Future sendRegisterData(UserModel user) async {
    // encode user as JSON
    var userJson = jsonEncode(user.toJson());

    // send HTTP post request to create user
    var response = await http
        .post(
          Uri.parse('$_url/'),
          headers: {'Content-Type': 'application/json'},
          body: userJson,
        )
        .timeout(const Duration(seconds: 2));

    if (response.statusCode == 403) {
      // access forbidden, should likely not occur with register endpoint
      return Future.error(Exception('Forbidden!'));
    }

    // decode response
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // user successfully registered
      return data['message'];
    } else {
      // failed to register user
      return Future.error(Exception(data['message']));
    }
  }

  /// Logs in a user using [username] and [password] and stores the token in the secure storage for the device
  Future login(String username, String password) async {
    // encode login parameters as JSON
    var loginData = jsonEncode({'username': username, 'password': password});

    // send HTTP post with user credentials
    var response = await http
        .post(
          Uri.parse('$_url/login/'),
          headers: {'Content-Type': 'application/json'},
          body: loginData,
        )
        .timeout(const Duration(seconds: 4));

    if (response.statusCode == 200) {
      // user successfully logged in
      // decode response with token
      var data = jsonDecode(response.body);

      // get token from data
      String token = data['message'][0];

      // write the token to the secure storage
      await storage.write(key: storageKey, value: token);

      return Future.value(1);
    } else if (response.statusCode == 400) {
      // login failed, likely bad credentials
      return Future.error(
          Exception('Your username and/or password is incorrect.'));
    } else {
      // login failed for other reason
      return Future.error(Exception('Failed to log in.'));
    }
  }

  /// Returns the user token string if it is found in the secure storage
  Future getTokenIfSet() async {
    try {
      // read the key and get token
      String? token = await storage.read(key: storageKey);
      return token;
    } catch (e) {
      // token not found
      return Future.error(Exception('Error getting token from storage'));
    }
  }

  /// Logs the user out and deletes the token key
  Future logoff() async {
    try {
      // remove token key
      await storage.delete(key: storageKey);
      return Future.value(1);
    } catch (e) {
      // failed to remove the key
      return Future.error(Exception('Failed to log out.'));
    }
  }

  /// Gets user information from the stored token
  Future<UserModel> getUserFromToken() async {
    // get user token
    String token = await getTokenIfSet();

    dynamic response;

    try {
      // send HTTP get to get user data
      response = await http.get(
        Uri.parse('$_url/user/'),
        headers: {'Authorization': 'Bearer $token'},
      );
    } catch (e) {
      // failed to get user data
      return Future.error("Failed to connect to the server.");
    }

    if (response.statusCode == 403) {
      // likely the token is expired, user must log in again
      await logoff();
      return Future.error(Exception('Session expired, please log in again.'));
    }

    // decode user data from JSON
    var user = UserModel.fromJson(jsonDecode(response.body));

    return user;
  }
}
