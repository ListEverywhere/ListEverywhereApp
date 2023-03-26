class ItemModel {
  int itemId;
  String itemName;
  bool checked;
  int position;

  ItemModel(
      {this.itemId = -1,
      this.itemName = "",
      this.checked = false,
      this.position = -1});

  ItemModel.fromJson(Map<String, dynamic> json)
      : itemId = json['itemId'],
        itemName = json['itemName'],
        checked = json['checked'],
        position = json['position'];

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
      required super.position,
      required this.listItemId,
      required this.listId});

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'checked': checked,
      'listItemId': listItemId,
      'listId': listId,
      'position': position
    };
  }

  factory ListItemModel.fromJson(Map<String, dynamic> json) {
    ItemModel item = ItemModel.fromJson(json);

    return ListItemModel(
      itemId: item.itemId,
      itemName: item.itemName,
      checked: item.checked,
      position: item.position,
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
    required super.position,
    required this.listId,
    required this.customItemId,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'checked': checked,
      'listId': listId,
      'customItemId': customItemId,
      'position': position,
    };
  }

  factory CustomListItemModel.fromJson(Map<String, dynamic> json) {
    ItemModel item = ItemModel.fromJson(json);

    return CustomListItemModel(
      itemName: item.itemName,
      checked: item.checked,
      position: item.position,
      listId: json['listId'],
      customItemId: json['customItemId'],
    );
  }
}

class RecipeItemModel extends ItemModel {
  int recipeItemId;
  int recipeId;

  RecipeItemModel({
    required super.itemId,
    super.itemName,
    required this.recipeItemId,
    required this.recipeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'recipeItemId': recipeItemId,
      'recipeId': recipeId,
    };
  }

  factory RecipeItemModel.fromJson(Map<String, dynamic> json) {
    ItemModel item = ItemModel.fromJson(json);

    return RecipeItemModel(
      itemId: item.itemId,
      itemName: item.itemName,
      recipeItemId: json['recipeItemId'],
      recipeId: json['recipeId'],
    );
  }
}
