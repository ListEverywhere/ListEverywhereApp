import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/widgets/recipes/recipe_entry.dart';

/// Creates a list view of recipes
class RecipeListView extends StatelessWidget {
  const RecipeListView({
    super.key,
    required this.recipes,
    this.enableActions = true,
    required this.updateCallback,
    required this.deleteCallback,
    this.listIdForMerge,
  });

  /// List of recipes
  final List<RecipeModel> recipes;

  /// Enable editing
  final bool enableActions;

  /// Callback for updating
  final Function(RecipeModel) updateCallback;

  /// Callback for deleting
  final Function(int) deleteCallback;

  /// If set, user is merging recipe with list
  final int? listIdForMerge;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeEntry(
          recipe: recipes[index],
          enableActions: enableActions,
          deleteCallback: deleteCallback,
          updateCallback: updateCallback,
          listIdForMerge: listIdForMerge,
        );
      },
    );
  }
}
