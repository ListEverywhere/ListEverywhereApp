import 'package:listeverywhere_app/models/item_model.dart';

class ListModel {
  int listId;
  int userId;
  String listName;
  DateTime creationDate;
  DateTime lastModified;
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
        creationDate = DateTime.parse(json['creationDate']),
        lastModified = DateTime.parse(json['lastModified']),
        listItems = json['listItems'] != null
            ? (json['listItems'] as List<dynamic>).map((e) {
                //return ItemModel.fromJson(e);
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
