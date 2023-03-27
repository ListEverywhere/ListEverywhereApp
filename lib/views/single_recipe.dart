import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/services/recipes_service.dart';

/// Provides the view for a single recipe object from the given [recipeId]
class SingleRecipeView extends StatefulWidget {
  SingleRecipeView({super.key, required this.recipeId});

  /// Recipe ID to load
  final int recipeId;

  @override
  State<StatefulWidget> createState() {
    return SingleRecipeViewState();
  }
}

class SingleRecipeViewState extends State<SingleRecipeView> {
  /// instance of RecipesService
  final recipesService = RecipesService();

  /// Returns a RecipeModel object for the recipe id given
  Future<RecipeModel> getRecipe() async {
    // use recipes service to get recipe
    var recipe = await recipesService.getRecipeById(widget.recipeId);

    return recipe;
  }

  /// Returns a ListView containing numbered entries for each string in [items]
  ListView buildList(List<String> items) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            // create number index Text at start of ListTile
            leading: Text(
              '${index + 1}.',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            title: Text(items[index]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viewing Recipe'),
      ),
      body: FutureBuilder(
        // when getRecipe returns recipe model, build view
        future: getRecipe(),
        builder: (context, snapshot) {
          // check if data is available
          if (snapshot.hasData) {
            // data is received
            RecipeModel recipe = snapshot.data!;
            // return scrollable view
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.recipeName,
                      style: const TextStyle(
                          fontSize: 48, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    Flexible(
                      child: Text(recipe.recipeDescription),
                    ),
                    const SizedBox(height: 20),
                    const Text('Ingredients:',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500)),
                    // build list of recipe items
                    buildList(
                      recipe.recipeItems!
                          .map<String>((e) => e.itemName)
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text('Steps:',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500)),
                    // build list of recipe steps
                    buildList(
                      recipe.recipeSteps!
                          .map<String>((e) => e.stepDescription)
                          .toList(),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // recipe is not loaded yet, show spinner
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
