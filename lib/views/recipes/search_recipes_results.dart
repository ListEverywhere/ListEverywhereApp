import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/models/search_model.dart';
import 'package:listeverywhere_app/services/recipes_service.dart';
import 'package:listeverywhere_app/widgets/recipes/recipes_list_view.dart';

/// Displays the recipe name search results
class SearchRecipesResultsView extends StatefulWidget {
  const SearchRecipesResultsView({super.key, required this.search});

  /// Search information
  final SearchModel search;

  @override
  State<StatefulWidget> createState() {
    return SearchRecipesResultsViewState();
  }
}

/// State for the search recipes results view
class SearchRecipesResultsViewState extends State<SearchRecipesResultsView> {
  /// Instance of [RecipesService]
  RecipesService recipesService = RecipesService();

  /// Returns a list of recipes given the search information
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
              // recipes were found, create list view
              return RecipeListView(
                recipes: data,
                enableActions: false,
                deleteCallback: (p0) {},
                updateCallback: (p0) {},
              );
            } else {
              // no recipes found
              return const Center(
                child: Text('No recipes found.'),
              );
            }
          }

          // if error, show error screen
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                  'An error has occured while trying to search.\nPlease try again later.'),
            );
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
