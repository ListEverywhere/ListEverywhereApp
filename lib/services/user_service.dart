import 'dart:convert';

import 'package:listeverywhere_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  final String _url = 'http://localhost:8080/users';
  final storage = const FlutterSecureStorage();
  static const storageKey = 'ListEverywhereToken';

  Future sendRegisterData(UserModel user) async {
    var userJson = jsonEncode(user.toJson());
    print(userJson);

    var response = await http
        .post(
          Uri.parse('$_url/'),
          headers: {'Content-Type': 'application/json'},
          body: userJson,
        )
        .timeout(const Duration(seconds: 2));

    print(response);

    if (response.statusCode == 403) {
      return Future.error(Exception('Forbidden!'));
    }

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(data['message']);
      return data['message'];
    } else {
      print("Error: ${data['message']}");
      return Future.error(Exception(data['message']));
    }
  }

  Future login(String username, String password) async {
    var loginData = jsonEncode({'username': username, 'password': password});
    print('Logging in with $loginData');

    var response = await http
        .post(
          Uri.parse('$_url/login/'),
          headers: {'Content-Type': 'application/json'},
          body: loginData,
        )
        .timeout(const Duration(seconds: 2));

    //print('Login response: $response');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);

      String token = data['message'][0];

      await storage.write(key: storageKey, value: token);

      return Future.value(1);
    } else if (response.statusCode == 400) {
      return Future.error(
          Exception('Your username and/or password is incorrect.'));
    } else {
      return Future.error(Exception('Failed to log in.'));
    }
  }

  Future getTokenIfSet() async {
    try {
      String? token = await storage.read(key: storageKey);
      return token;
    } catch (e) {
      return Future.error(Exception('Error getting token from storage'));
    }
  }

  Future logoff() async {
    try {
      await storage.delete(key: storageKey);
      return Future.value(1);
    } catch (e) {
      return Future.error(Exception('Failed to log out.'));
    }
  }

  Future<UserModel> getUserFromToken() async {
    String token = await getTokenIfSet();
    var response = await http.get(
      Uri.parse('$_url/user/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 403) {
      await logoff();
      return Future.error(Exception('Session expired, please log in again.'));
    }

    var user = UserModel.fromJson(jsonDecode(response.body));

    return user;
  }
}
