import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';

class RecipeEntry extends StatelessWidget {
  const RecipeEntry({
    super.key,
    required this.recipe,
    this.enableActions = true,
  });

  final RecipeModel recipe;
  final bool enableActions;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.amber,
        onTap: () {
          print('tapped recipe ID ${recipe.recipeId}');
          Navigator.pushNamed(context, '/recipes/recipe',
              arguments: recipe.recipeId);
        },
        child: SizedBox(
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(recipe.recipeName),
              ),
              if (enableActions)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        print('Updating recipe ID ${recipe.recipeId}');
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        print('Deleting recipe ID ${recipe.recipeId}');
                      },
                      icon: const Icon(Icons.delete_forever),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
