import 'package:flutter/material.dart';
import 'package:listeverywhere_app/constants.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/services/recipes_service.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/bottom_navbar.dart';
import 'package:listeverywhere_app/widgets/floating_action_button_container.dart';
import 'package:listeverywhere_app/widgets/recipes/recipe_entry.dart';
import 'package:listeverywhere_app/widgets/recipes/recipes_list_view.dart';

/// Displays a list of a user's Recipes
class MyRecipesView extends StatefulWidget {
  const MyRecipesView({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyRecipesViewState();
  }
}

/// State for the user recipes view
class MyRecipesViewState extends State<MyRecipesView> {
  /// Instance of [UserService]
  final userService = UserService();

  /// Instance of [RecipesService]
  final recipesService = RecipesService();

  /// Returns a list of the current user's recipes
  Future<List<RecipeModel>> getUserRecipes() async {
    // get user details
    var user = await userService.getUserFromToken();

    // use recipes service to get recipes
    var recipes = await recipesService.getRecipesByUser(user.id!);

    return recipes;
  }

  /// Callback for deleting a recipe
  Future onDelete(int recipeId) async {
    // send delete request
    await recipesService.deleteRecipe(recipeId).onError((error, stackTrace) {
      // failed to delete
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to delete recipe.'),
        backgroundColor: errorColor,
      ));
    });
    setState(() {});
  }

  /// Callback for updating recipe
  Future onUpdate(RecipeModel recipe) async {
    await Navigator.pushNamed(context, '/recipes/edit', arguments: recipe).then(
      (value) {
        setState(() {});
      },
    );
  }

  /// Builds view with child and floating action button on bottom
  Widget buildListContainer(BuildContext context, Widget child) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: child,
        ),
        Expanded(
          child: FloatingActionButtonContainer(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // create new recipe
              await Navigator.pushNamed(context, '/recipes/create')
                  .then((value) {
                setState(() {});
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
      ),
      //floatingActionButton:
      body: FutureBuilder(
        future: getUserRecipes(),
        builder: (context, snapshot) {
          // check if data is available
          if (snapshot.hasData) {
            // data is available
            List<RecipeModel> data = snapshot.data!;
            if (data.isNotEmpty) {
              // user has recipes, create list of recipe entries
              return buildListContainer(
                context,
                RecipeListView(
                  recipes: data,
                  updateCallback: onUpdate,
                  deleteCallback: onDelete,
                ),
              );
            } else {
              // user has no recipes
              return buildListContainer(
                context,
                const Center(
                  child: Text('You do not have any recipes.'),
                ),
              );
            }
          }

          // if no data, show loading indicator
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        parentContext: context,
      ),
    );
  }
}
