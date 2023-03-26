import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/services/recipes_service.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/views/bottom_navbar.dart';
import 'package:listeverywhere_app/widgets/recipe_entry.dart';

class MyRecipesView extends StatefulWidget {
  const MyRecipesView({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyRecipesViewState();
  }
}

class MyRecipesViewState extends State<MyRecipesView> {
  final userService = UserService();
  final recipesService = RecipesService();

  Future<List<RecipeModel>> getUserRecipes() async {
    var user = await userService.getUserFromToken();

    var recipes = await recipesService.getRecipesByUser(user.id!);

    return recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
      ),
      body: FutureBuilder(
        future: getUserRecipes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<RecipeModel> data = snapshot.data!;
            if (data.isNotEmpty) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return RecipeEntry(recipe: data[index]);
                },
              );
            } else {
              return const Center(
                child: Text('You do not have any recipes.'),
              );
            }
          }

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
