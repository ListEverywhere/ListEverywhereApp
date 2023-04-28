import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/services/recipes_service.dart';
import 'package:listeverywhere_app/widgets/recipes/recipes_list_view.dart';

/// Displays a list of recipes for recipe matching
class SelectRecipeForMatchView extends StatefulWidget {
  const SelectRecipeForMatchView({super.key, required this.listItemIdsInit});
  // Required parameters for view
  final RecipeMatchModel listItemIdsInit;

  @override
  State<StatefulWidget> createState() {
    return SelectRecipeForMatchViewState();
  }
}

/// Staet for the select recipe for match view
class SelectRecipeForMatchViewState extends State<SelectRecipeForMatchView> {
  /// Instance of [RecipesService]
  RecipesService recipesService = RecipesService();

  /// Returns a list of recipes with the matching list items
  Future<List<RecipeModel>> getRecipes() async {
    var recipes = await recipesService
        .matchListItemsToRecipes(widget.listItemIdsInit.listItemIds);

    return recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Search by List Items')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: Center(
                  child: Text(
                'Select a recipe to merge with your list:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              )),
            ),
            Expanded(
              flex: 4,
              child: FutureBuilder(
                future: getRecipes(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // recipes were returned
                    var data = snapshot.data!;

                    if (data.isNotEmpty) {
                      // recipes found
                      print(widget.listItemIdsInit.listId);
                      return RecipeListView(
                        recipes: data,
                        updateCallback: (p0) {},
                        deleteCallback: (p0) {},
                        enableActions: false,
                        listIdForMerge: widget.listItemIdsInit.listId,
                      );
                    }

                    // no matching recipes
                    return const Center(
                      child: Text(
                          'No recipes found containing the selected items.'),
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
