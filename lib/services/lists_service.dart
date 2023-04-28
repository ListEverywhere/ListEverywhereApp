import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:listeverywhere_app/constants.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/services/user_service.dart';

/// Provides various actions related to Shopping Lists, such as getting lists or adding items
class ListsService {
  /// Instance of [UserService]
  final userService = UserService();

  /// API url
  final String _url = '$apiUrl/lists';

  /// Returns a list of shopping lists from a given [userId] <br>
  /// If [noItems] is true, lists will have no items <br>
  /// If [noCustomItems] is true, lists will have no custom items
  Future<List<ListModel>> getUserLists(int userId,
      {noItems = true, noCustomItems = false}) async {
    // get user token
    String token = await userService.getTokenIfSet();

    print('starting request');

    // perform HTTP request to get lists
    var response = await http.get(
      Uri.parse(
          '$_url/user/$userId?noItems=$noItems&noCustomItems=$noCustomItems'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 404) {
      // No lists were found, return empty list
      return [];
    }

    // cast data as a list
    List<dynamic> data = initialData as List<dynamic>;

    // map list items to ListModel objects
    List<ListModel> lists = data
        .map(
          (e) => ListModel.fromJson(e),
        )
        .toList();

    return lists;
  }

  /// Creates a new shopping list tied to [userId] including the [listName]
  Future createList(String listName, int userId) async {
    // get user token
    String token = await userService.getTokenIfSet();

    // create new list object
    ListModel list = ListModel(
        creationDate: DateTime.now(),
        lastModified: DateTime.now(),
        listId: -1,
        userId: userId,
        listName: listName);

    // send HTTP post with list data in body
    var response = await http.post(
      Uri.parse('$_url/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(list),
    );

    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // list created successfully
      return Future.value(1);
    } else {
      // error has occurred, return message from response
      return Future.error(Exception(initialData['message'][0]));
    }
  }

  /// Returns a shopping list with the given [listId]
  Future<ListModel> getListById(int listId) async {
    // get user token
    String token = await userService.getTokenIfSet();

    // send HTTP get with list id
    var response = await http.get(
      Uri.parse('$_url/$listId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // return the list
      return ListModel.fromJson(initialData);
    }
    return Future.error(Exception('Error getting list'));
  }

  /// Updates a given [list]
  Future updateList(ListModel list) async {
    // get user token
    String token = await userService.getTokenIfSet();

    // send HTTP put with list in body
    var response = await http.put(
      Uri.parse('$_url/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(list),
    );

    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // update was successful
      return Future.value(1);
    }

    // error has occurred, return message from response
    return Future.error(Exception(initialData['message'][0]));
  }

  /// Delete a list with the given [list_id]
  Future deleteList(int list_id) async {
    // get user token
    String token = await userService.getTokenIfSet();

    // send HTTP delete with list id
    var response = await http.delete(
      Uri.parse('$_url/$list_id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // delete was successful
      return Future.value(1);
    }

    return Future.error(Exception('Failed to delete list.'));
  }

  /// Returns a list of items matching the given [search]
  Future<List<ItemModel>> searchItemsByName(String search) async {
    // encode search string to json
    var searchData = jsonEncode({'search': search});

    // get user token
    String token = await userService.getTokenIfSet();

    dynamic response;

    try {
      // send HTTP post with search data
      response = await http.post(
        Uri.parse(
          '$apiUrl/items/search/',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: searchData,
      );
    } catch (e) {
      print(e);
      return Future.error(Exception("Failed to find items."));
    }

    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // search was successful
      // map data to list of item objects
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

  /// Adds a given [item] to a list
  Future addItem(ItemModel item) async {
    // get user token
    String token = await userService.getTokenIfSet();
    String url = '$_url/items';
    dynamic response;

    // check the type of item so that correct endpoint is used
    if (item is CustomListItemModel) {
      // send HTTP post with custom list item
      response = await http.post(
        Uri.parse('$url/custom'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(item),
      );
    } else if (item is ListItemModel) {
      // send HTTP post with list item
      response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(item),
      );
    }

    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // item was added
      return Future.value(1);
    }

    // error has occurred, return message from response
    return Future.error(Exception(initialData['message'][0]));
  }

  // Updates an [item] in the server. If [updatePosition] is enabled, the position will be updated instead
  Future updateItem(ItemModel item, bool updatePosition) async {
    // get user token
    String token = await userService.getTokenIfSet();
    String url = '$_url/items';
    dynamic response;

    // check type of item so that appropriate endpoint is used
    if (item is CustomListItemModel) {
      response = await http.put(
        // if updatePosition is true, add /position to url
        Uri.parse('$url/custom${updatePosition ? '/position' : ''}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(item),
      );
    } else {
      response = await http.put(
        // if updatePosition is true, add /position to url
        Uri.parse('$url${updatePosition ? '/position' : ''}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(item as ListItemModel),
      );
    }

    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // item updated successfully
      return Future.value(1);
    }

    // error has occurred, return message from response
    return Future.error(Exception(initialData['message'][0]));
  }

  // Deletes an [item] from the server
  Future deleteItem(ItemModel item) async {
    // get user token
    String token = await userService.getTokenIfSet();
    String url = '$_url/items';
    dynamic response;

    // check type of item so that appropriate endpoint is used
    if (item is CustomListItemModel) {
      response = await http
          .delete(Uri.parse('$url/custom/${item.customItemId}'), headers: {
        'Authorization': 'Bearer $token',
      });
    } else {
      ListItemModel tempItem = item as ListItemModel;
      response = await http.delete(
        Uri.parse('$url/${tempItem.listItemId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    }

    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // item deleted successfully
      return Future.value(1);
    }
    // error has occurred, return message from response
    return Future.error(Exception(initialData['message'][0]));
  }

  /// Merges items from a recipe given the [recipeId] into a list given the [listId]
  Future mergeListWithRecipe(int listId, int recipeId) async {
    // get user token
    var token = await userService.getTokenIfSet();

    // send post request
    var response = await http.post(
      Uri.parse('$_url/$listId/merge-recipe/$recipeId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // successfully merged
      return Future.value(1);
    }
    // failed to merge
    return Future.error(initialData['message'][0]);
  }
}
