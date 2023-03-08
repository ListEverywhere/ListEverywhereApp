class ItemModel {
  int itemId;
  String itemName;
  bool checked;

  ItemModel({this.itemId = -1, this.itemName = "", this.checked = false});

  ItemModel.fromJson(Map<String, dynamic> json)
      : itemId = json['itemId'],
        itemName = json['itemName'],
        checked = json['checked'];

  @override
  String toString() {
    return 'ItemModel - ID: $itemId - Name: $itemName';
  }
}

class ListItemModel extends ItemModel {
  int listItemId;
  int listId;

  ListItemModel(
      {required super.itemId,
      super.itemName,
      required super.checked,
      required this.listItemId,
      required this.listId});

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'checked': checked,
      'listItemId': listItemId,
      'listId': listId
    };
  }

  factory ListItemModel.fromJson(Map<String, dynamic> json) {
    ItemModel item = ItemModel.fromJson(json);

    return ListItemModel(
      itemId: item.itemId,
      itemName: item.itemName,
      checked: item.checked,
      listItemId: json['listItemId'],
      listId: json['listId'],
    );
  }
}

class CustomListItemModel extends ItemModel {
  int customItemId;
  int listId;

  CustomListItemModel({
    required super.itemName,
    required super.checked,
    required this.listId,
    required this.customItemId,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'checked': checked,
      'listId': listId,
      'customItemId': customItemId
    };
  }

  factory CustomListItemModel.fromJson(Map<String, dynamic> json) {
    ItemModel item = ItemModel.fromJson(json);

    return CustomListItemModel(
      itemName: item.itemName,
      checked: item.checked,
      listId: json['listId'],
      customItemId: json['customItemId'],
    );
  }
}
