import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/widgets/recipes/recipe_entry.dart';

class RecipeListView extends StatelessWidget {
  const RecipeListView({
    super.key,
    required this.recipes,
    this.enableActions = true,
    required this.updateCallback,
    required this.deleteCallback,
  });

  final List<RecipeModel> recipes;
  final bool enableActions;
  final Function(RecipeModel) updateCallback;
  final Function(int) deleteCallback;

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
        );
      },
    );
  }
}
