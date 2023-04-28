import 'package:listeverywhere_app/models/item_model.dart';

// A single Recipe object. [recipeItems] and [recipeSteps] may be optional.
class RecipeModel {
  /// ID number of the recipe
  int recipeId;

  /// ID number of the category
  int category;

  /// Recipe name
  String recipeName;

  /// Description of the recipe
  String recipeDescription;

  /// Recipe items
  List<RecipeItemModel>? recipeItems;

  /// Recipe steps
  List<RecipeStepModel>? recipeSteps;

  /// Is the recipe published
  bool published;

  /// Id number of the user
  int userId;

  // Total cooking time for the recipe
  int cookTime;

  RecipeModel({
    required this.recipeId,
    required this.category,
    required this.recipeName,
    required this.recipeDescription,
    this.recipeItems,
    this.recipeSteps,
    required this.published,
    required this.userId,
    required this.cookTime,
  });

  RecipeModel.fromJson(Map<String, dynamic> json)
      : recipeId = json['recipeId'],
        category = json['category'],
        recipeName = json['recipeName'],
        recipeDescription = json['recipeDescription'],
        published = json['published'],
        userId = json['userId'],
        cookTime = json['cookTime'],
        // check if recipeItems is null
        recipeItems = json['recipeItems'] != null
            // cast recipeItems as list and map to list of RecipeItemModel
            ? (json['recipeItems'] as List<dynamic>)
                .map(
                  (e) => RecipeItemModel.fromJson(e),
                )
                .toList()
            : null,
        // check if recipeSteps is null
        recipeSteps = json['recipeSteps'] != null
            // cast recipeSteps as list and map to list of RecipeStepModel
            ? (json['recipeSteps'] as List<dynamic>)
                .map((e) => RecipeStepModel.fromJson(e))
                .toList()
            : null;

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'category': category,
      'recipeName': recipeName,
      'recipeDescription': recipeDescription,
      'userId': userId,
      'cookTime': cookTime,
    };
  }
}

/// A single recipe step
class RecipeStepModel {
  /// ID number of the recipe step entry
  int recipeStepId;

  /// Step details
  String stepDescription;

  /// ID number of the recipe
  int recipeId;

  RecipeStepModel(
      {required this.recipeStepId,
      required this.stepDescription,
      required this.recipeId});

  RecipeStepModel.fromJson(Map<String, dynamic> json)
      : recipeStepId = json['recipeStepId'],
        stepDescription = json['stepDescription'],
        recipeId = json['recipeId'];

  Map<String, dynamic> toJson() {
    return {
      'recipeStepId': recipeStepId,
      'stepDescription': stepDescription,
      'recipeId': recipeId,
    };
  }
}

/// Holds necessary parameters for single recipe view
class RecipeViewModel {
  /// ID number of the recipe
  int recipeId;

  /// Turns on edit mode
  bool edit;

  /// List ID of the list to match the recipe with (optional)
  int? listId;

  /// If editing is allowed
  bool canEdit;

  RecipeViewModel(
      {required this.recipeId,
      this.edit = true,
      this.listId,
      required this.canEdit});
}

/// Holds required parameters for matching list to recipe
class RecipeMatchModel {
  List<int> listItemIds;
  int listId;

  RecipeMatchModel({required this.listItemIds, required this.listId});
}
