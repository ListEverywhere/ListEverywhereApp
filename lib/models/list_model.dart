import 'package:listeverywhere_app/models/item_model.dart';

/// A single Shopping List object. [listItems] may be optional.
class ListModel {
  /// ID number of the list
  int listId;

  /// ID number of the user
  int userId;

  // List name
  String listName;

  // Date when the list was created
  DateTime creationDate;

  // Date when the list was last modified
  DateTime lastModified;

  // Shopping List items
  List<ItemModel>? listItems;

  ListModel(
      {required this.listId,
      required this.userId,
      required this.listName,
      required this.creationDate,
      required this.lastModified,
      this.listItems});

  ListModel.fromJson(Map<String, dynamic> json)
      : listId = json['listId'],
        userId = json['userId'],
        listName = json['listName'],
        // parse string into DateTime
        creationDate = DateTime.parse(json['creationDate']),
        // parse string into DateTime
        lastModified = DateTime.parse(json['lastModified']),
        // check that listItems is not null
        listItems = json['listItems'] != null
            // cast listItems to List, then map as List of item models
            ? (json['listItems'] as List<dynamic>).map((e) {
                // if itemId is -1, it is a CustomListItemModel
                // otherwise assume it is a ListItemModel
                if (e['itemId'] == -1) {
                  return CustomListItemModel.fromJson(e);
                } else {
                  return ListItemModel.fromJson(e);
                }
              }).toList()
            : null;

  Map<String, dynamic> toJson() {
    return {
      'listId': listId,
      'userId': userId,
      'listName': listName,
      'lastModified': lastModified.toIso8601String()
    };
  }
}

/// Holds required parameters for list to recipe match
class ListMatchModel {
  /// List of List Items
  List<ListItemModel> listItems;

  /// ID number of the shopping list
  int listId;

  ListMatchModel({required this.listItems, required this.listId});
}
