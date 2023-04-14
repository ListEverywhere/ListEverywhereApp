import 'package:flutter/material.dart';
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

  Future onDelete(int recipeId) async {
    await recipesService.deleteRecipe(recipeId);
    setState(() {});
  }

  Future onUpdate(RecipeModel recipe) async {
    await Navigator.pushNamed(context, '/recipes/edit', arguments: recipe).then(
      (value) {
        setState(() {});
      },
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
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 4,
                    child: RecipeListView(
                      recipes: data,
                      updateCallback: onUpdate,
                      deleteCallback: onDelete,
                    ),
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
                  )),
                ],
              );
            } else {
              // user has no recipes
              return const Center(
                child: Text('You do not have any recipes.'),
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
