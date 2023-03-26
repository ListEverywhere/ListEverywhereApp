import 'package:listeverywhere_app/models/item_model.dart';

class RecipeModel {
  int recipeId;
  int category;
  String recipeName;
  String recipeDescription;
  List<RecipeItemModel>? recipeItems;
  List<RecipeStepModel>? recipeSteps;
  bool published;
  int userId;

  RecipeModel({
    required this.recipeId,
    required this.category,
    required this.recipeName,
    required this.recipeDescription,
    this.recipeItems,
    this.recipeSteps,
    required this.published,
    required this.userId,
  });

  RecipeModel.fromJson(Map<String, dynamic> json)
      : recipeId = json['recipeId'],
        category = json['category'],
        recipeName = json['recipeName'],
        recipeDescription = json['recipeDescription'],
        published = json['published'],
        userId = json['userId'],
        recipeItems = json['recipeItems'] != null
            ? (json['recipeItems'] as List<dynamic>)
                .map(
                  (e) => RecipeItemModel.fromJson(e),
                )
                .toList()
            : null,
        recipeSteps = json['recipeSteps'] != null
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
    };
  }
}

class RecipeStepModel {
  int recipeStepId;
  String stepDescription;
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
