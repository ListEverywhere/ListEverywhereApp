import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/services/recipes_service.dart';

class SingleRecipeView extends StatefulWidget {
  SingleRecipeView({super.key, required this.recipeId});

  final int recipeId;

  @override
  State<StatefulWidget> createState() {
    return SingleRecipeViewState();
  }
}

class SingleRecipeViewState extends State<SingleRecipeView> {
  final recipesService = RecipesService();

  Future<RecipeModel> getRecipe() async {
    var recipe = await recipesService.getRecipeById(widget.recipeId);

    return recipe;
  }

  ListView buildList(List<String> items) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
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
        future: getRecipe(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            RecipeModel recipe = snapshot.data!;
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
                    buildList(
                      recipe.recipeItems!
                          .map<String>((e) => e.itemName)
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text('Steps:',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500)),
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
