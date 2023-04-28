import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/category_model.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/services/recipes_service.dart';
import 'package:listeverywhere_app/widgets/recipes/recipes_list_view.dart';

/// Displays a list of recipes with the given [category]
class CategoryRecipesView extends StatefulWidget {
  const CategoryRecipesView({
    super.key,
    required this.category,
  });

  /// Recipe Category
  final CategoryModel category;

  @override
  State<StatefulWidget> createState() {
    return CategoryRecipesViewState();
  }
}

/// State for the category recipes view
class CategoryRecipesViewState extends State<CategoryRecipesView> {
  /// Instance of [RecipesService]
  final recipesService = RecipesService();

  /// Returns a list of recipes with the matching category
  Future<List<RecipeModel>> getRecipes() async {
    var recipes =
        await recipesService.getRecipesByCategory(widget.category.categoryId);
    return recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.categoryName)),
      body: FutureBuilder(
        future: getRecipes(),
        builder: (context, snapshot) {
          // check if data is available
          if (snapshot.hasData) {
            // data is available
            List<RecipeModel> data = snapshot.data!;
            if (data.isNotEmpty) {
              // user has recipes, create list of recipe entries
              return RecipeListView(
                recipes: data,
                enableActions: false,
                updateCallback: (p0) {},
                deleteCallback: (p0) {},
              );
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
