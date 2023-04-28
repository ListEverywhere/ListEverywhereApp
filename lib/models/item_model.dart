/// A single item object containing shared fields between item types
class ItemModel {
  /// ID of the item from third party API
  int itemId;

  /// Name of the item
  String itemName;

  /// Is item checked
  bool checked;

  /// Position of the item
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

/// A single list item object, in which the item information is supplied using [itemId]
class ListItemModel extends ItemModel {
  /// ID number of the list item entry
  int listItemId;

  /// ID number of the shopping list
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
    // first get the fields from ItemModel
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

/// A single custom list item object, in which the user supplies the item name
class CustomListItemModel extends ItemModel {
  /// ID number of the custom item entry
  int customItemId;

  /// ID number of the list item
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
    // first get the fields from ItemModel
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

/// A single recipe item object, in which the item information is supplied using [itemId]
class RecipeItemModel extends ItemModel {
  /// ID number of the recipe item entry
  int recipeItemId;

  /// ID number of the recipe
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
    // first get the fields from ItemModel
    ItemModel item = ItemModel.fromJson(json);

    return RecipeItemModel(
      itemId: item.itemId,
      itemName: item.itemName,
      recipeItemId: json['recipeItemId'],
      recipeId: json['recipeId'],
    );
  }
}

/// Holds required parameters for matching list items to recipes
class MatchListItemModel {
  /// ID number of the list item entry
  int listItemId;

  /// Item ID
  int itemId;

  MatchListItemModel({
    required this.listItemId,
    required this.itemId,
  });

  @override
  bool operator ==(Object other) =>
      other is MatchListItemModel && other.itemId == itemId;

  @override
  int get hashCode => itemId;
}
