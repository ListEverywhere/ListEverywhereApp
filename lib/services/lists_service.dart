import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/services/user_service.dart';

class ListsService {
  final userService = UserService();
  final String _url = 'http://localhost:8080/lists';

  Future<List<ListModel>> getUserLists(int userId) async {
    String token = await userService.getTokenIfSet();

    var response = await http.get(
      Uri.parse('$_url/user/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    //print(response.body);

    List<dynamic> data = jsonDecode(response.body);

    //print(data[0]);

    List<ListModel> lists = data
        .map(
          (e) => ListModel.fromJson(e),
        )
        .toList();

    return lists;
  }
}
