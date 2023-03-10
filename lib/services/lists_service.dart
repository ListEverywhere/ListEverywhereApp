import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:listeverywhere_app/constants.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/services/user_service.dart';

class ListsService {
  final userService = UserService();
  final String _url = '$apiUrl/lists';

  Future<List<ListModel>> getUserLists(int userId) async {
    String token = await userService.getTokenIfSet();

    print('starting request');

    var response = await http.get(
      Uri.parse('$_url/user/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    //print(response.body);

    var initialData = jsonDecode(response.body);

    if (response.statusCode == 404) {
      print('No lists found.');
      return [];
    }

    List<dynamic> data = initialData as List<dynamic>;

    // print(data);

    List<ListModel> lists = data
        .map(
          (e) => ListModel.fromJson(e),
        )
        .toList();

    return lists;
  }

  Future createList(String listName, int userId) async {
    String token = await userService.getTokenIfSet();

    ListModel list = ListModel(
        creationDate: DateTime.now(),
        lastModified: DateTime.now(),
        listId: -1,
        userId: userId,
        listName: listName);

    var response = await http.post(
      Uri.parse('$_url/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(list),
    );

    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Future.value(1);
    } else {
      return Future.error(Exception(initialData['message'][0]));
    }
  }

  Future<ListModel> getListById(int listId) async {
    String token = await userService.getTokenIfSet();

    var response = await http.get(
      Uri.parse('$_url/$listId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ListModel.fromJson(initialData);
    }
    return Future.error(Exception('Error getting list'));
  }

  Future<List<ItemModel>> searchItemsByName(String search) async {
    var searchData = jsonEncode({'search': search});

    String token = await userService.getTokenIfSet();

    var response = await http.post(
      Uri.parse(
        '$apiUrl/items/search/',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: searchData,
    );

    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<ItemModel> items = (initialData as List<dynamic>).map(
        (e) {
          return ItemModel(
            itemId: e['food_id'],
            itemName: e['food_name'],
          );
        },
      ).toList();

      return items;
    }

    return Future.error(Exception('Error getting items'));
  }

  Future addItem(ListItemModel listItem) async {
    String token = await userService.getTokenIfSet();

    var response = await http.post(
      Uri.parse('$_url/items'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(listItem),
    );

    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Future.value(1);
    }

    return Future.error(Exception(initialData['message'][0]));
  }

  Future updateItem(ItemModel item) async {
    String token = await userService.getTokenIfSet();
    String url = '$_url/items';
    dynamic response;

    if (item is CustomListItemModel) {
      response = await http.put(
        Uri.parse('$_url/items/custom'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(item),
      );
    } else {
      response = await http.put(
        Uri.parse('$_url/items'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(item as ListItemModel),
      );
    }

    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Future.value(1);
    }

    return Future.error(Exception(initialData['message'][0]));
  }

  Future deleteItem(ItemModel item) async {
    String token = await userService.getTokenIfSet();
    String url = '$_url/items';
    dynamic response;

    if (item is CustomListItemModel) {
      response = await http.delete(
          Uri.parse('$_url/items/custom/${item.customItemId}'),
          headers: {
            'Authorization': 'Bearer $token',
          });
    } else {
      ListItemModel tempItem = item as ListItemModel;
      response = await http.delete(
        Uri.parse('$_url/items/${tempItem.listItemId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    }

    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Future.value(1);
    }

    return Future.error(Exception(initialData['message'][0]));
  }
}
