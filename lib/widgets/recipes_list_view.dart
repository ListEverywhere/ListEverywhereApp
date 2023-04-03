import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/widgets/recipe_entry.dart';

class RecipeListView extends StatelessWidget {
  const RecipeListView({
    super.key,
    required this.recipes,
  });

  final List<RecipeModel> recipes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeEntry(recipe: recipes[index]);
      },
    );
  }
}
