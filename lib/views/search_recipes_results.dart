import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/models/search_model.dart';
import 'package:listeverywhere_app/services/recipes_service.dart';
import 'package:listeverywhere_app/widgets/recipes_list_view.dart';

class SearchRecipesResultsView extends StatefulWidget {
  const SearchRecipesResultsView({super.key, required this.search});
  final SearchModel search;

  @override
  State<StatefulWidget> createState() {
    return SearchRecipesResultsViewState();
  }
}

class SearchRecipesResultsViewState extends State<SearchRecipesResultsView> {
  RecipesService recipesService = RecipesService();

  Future<List<RecipeModel>> searchRecipes() async {
    var recipes = await recipesService.searchRecipes(widget.search);
    return recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Results')),
      body: FutureBuilder(
        future: searchRecipes(),
        builder: (context, snapshot) {
          // check if data is available
          if (snapshot.hasData) {
            // data is available
            List<RecipeModel> data = snapshot.data!;
            if (data.isNotEmpty) {
              // user has recipes, create list of recipe entries
              return RecipeListView(recipes: data);
            } else {
              // user has no recipes
              return const Center(
                child: Text('No recipes found.'),
              );
            }
          }

          // if no data, show loading indicator
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
