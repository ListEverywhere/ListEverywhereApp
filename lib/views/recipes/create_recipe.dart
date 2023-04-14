import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/category_model.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/models/user_model.dart';
import 'package:listeverywhere_app/services/recipes_service.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/reusable_field.dart';

class CreateRecipeView extends StatefulWidget {
  const CreateRecipeView({
    super.key,
    this.recipe,
  });

  final RecipeModel? recipe;

  @override
  State<StatefulWidget> createState() {
    return CreateRecipeViewState();
  }
}

class CreateRecipeViewState extends State<CreateRecipeView> {
  RecipesService recipesService = RecipesService();
  UserService userService = UserService();

  TextEditingController recipeName = TextEditingController();
  TextEditingController recipeDescription = TextEditingController();
  TextEditingController cookTime = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  CategoryModel? selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      selectedCategory = CategoryModel(categoryId: widget.recipe!.category);
      recipeName.text = widget.recipe!.recipeName;
      recipeDescription.text = widget.recipe!.recipeDescription;
      cookTime.text = widget.recipe!.cookTime.toString();
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    var categories = await recipesService.getCategories();
    return categories;
  }

  Widget buildCategoryDropdown(List<CategoryModel> categories) {
    return DropdownButtonFormField<CategoryModel>(
      value: selectedCategory,
      hint: const Text('Recipe Category'),
      items: categories.map<DropdownMenuItem<CategoryModel>>((e) {
        return DropdownMenuItem(
          value: e,
          child: Text(e.categoryName),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Recipe Category is required';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.recipe != null ? 'Updating recipe' : 'Create a new recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ReusableFormField(
                        controller: recipeName, hint: 'Recipe Name'),
                    FutureBuilder(
                      future: getCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!;

                          return buildCategoryDropdown(data);
                        } else {
                          return buildCategoryDropdown([]);
                        }
                      },
                    ),
                    ReusableFormField(
                        controller: recipeDescription,
                        hint: 'Recipe Description'),
                    ReusableFormField(
                        controller: cookTime,
                        hint: 'Cook Time (minutes)',
                        keyboardType: TextInputType.number),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  style: const ButtonStyle(
                      maximumSize:
                          MaterialStatePropertyAll<Size>(Size(100, 80))),
                  onPressed: () async {
                    // check if form fields are valid
                    if (_formKey.currentState!.validate() &&
                        selectedCategory != null) {
                      // save the form fields
                      _formKey.currentState?.save();
                      dynamic response;
                      try {
                        dynamic response;

                        if (widget.recipe != null) {
                          // updating recipe
                          RecipeModel recipe = widget.recipe!;

                          recipe.category = selectedCategory!.categoryId;
                          recipe.recipeName = recipeName.text;
                          recipe.recipeDescription = recipeDescription.text;
                          recipe.cookTime = int.parse(cookTime.text);

                          response =
                              await recipesService.updateRecipe(recipe).then(
                            (value) {
                              Navigator.pop(context);
                            },
                          );
                        } else {
                          // creating recipe
                          UserModel current =
                              await userService.getUserFromToken();

                          RecipeModel recipe = RecipeModel(
                            recipeId: -1,
                            category: selectedCategory!.categoryId,
                            recipeName: recipeName.text,
                            recipeDescription: recipeDescription.text,
                            published: false,
                            userId: current.id!,
                            cookTime: int.parse(cookTime.text),
                          );

                          // use recipes service to create recipe
                          response = await recipesService
                              .createRecipe(recipe)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        }
                      } catch (e) {
                        // an error has occurred
                        response = e.toString();
                        // display dialog with error
                        showDialog(
                          context: context,
                          builder: (ctxt) =>
                              AlertDialog(content: Text(response)),
                        );
                      }
                    }
                  },
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
