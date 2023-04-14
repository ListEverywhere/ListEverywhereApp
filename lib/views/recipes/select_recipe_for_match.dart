import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/services/recipes_service.dart';
import 'package:listeverywhere_app/widgets/recipes/recipes_list_view.dart';

class SelectRecipeForMatchView extends StatefulWidget {
  const SelectRecipeForMatchView({super.key, required this.listItemIdsInit});

  final RecipeMatchModel listItemIdsInit;

  @override
  State<StatefulWidget> createState() {
    return SelectRecipeForMatchViewState();
  }
}

class SelectRecipeForMatchViewState extends State<SelectRecipeForMatchView> {
  RecipesService recipesService = RecipesService();

  Future<List<RecipeModel>> getRecipes() async {
    var recipes = await recipesService
        .matchListItemsToRecipes(widget.listItemIdsInit.listItemIds);

    return recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Search by List Items')),
      body: Column(
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
                  var data = snapshot.data!;

                  if (data.isNotEmpty) {
                    print(widget.listItemIdsInit.listId);
                    return RecipeListView(
                      recipes: data,
                      updateCallback: (p0) {},
                      deleteCallback: (p0) {},
                      enableActions: false,
                      listIdForMerge: widget.listItemIdsInit.listId,
                    );
                  }

                  return const Center(
                    child:
                        Text('No recipes found containing the selected items.'),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
