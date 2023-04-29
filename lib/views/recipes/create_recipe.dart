import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/category_model.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/models/user_model.dart';
import 'package:listeverywhere_app/services/recipes_service.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/reusable_field.dart';

/// Displays the form for creating or updating a recipe
class CreateRecipeView extends StatefulWidget {
  const CreateRecipeView({
    super.key,
    this.recipe,
  });

  /// RecipeModel to update. Leave null for create recipe
  final RecipeModel? recipe;

  @override
  State<StatefulWidget> createState() {
    return CreateRecipeViewState();
  }
}

/// State for the create recipe view
class CreateRecipeViewState extends State<CreateRecipeView> {
  /// Instance of [RecipesService]
  RecipesService recipesService = RecipesService();

  /// Instance of [UserService]
  UserService userService = UserService();

  /// Recipe Name
  TextEditingController recipeName = TextEditingController();

  /// Recipe Description
  TextEditingController recipeDescription = TextEditingController();

  /// Recipe Cook Time
  TextEditingController cookTime = TextEditingController();

  /// Form Key
  final _formKey = GlobalKey<FormState>();

  /// Selected recipe category
  CategoryModel? selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      // recipe is not null, display update screen
      // set fields with values from recipe
      selectedCategory = CategoryModel(categoryId: widget.recipe!.category);
      recipeName.text = widget.recipe!.recipeName;
      recipeDescription.text = widget.recipe!.recipeDescription;
      cookTime.text = widget.recipe!.cookTime.toString();
    }
  }

  /// Returns a list of recipe categories
  Future<List<CategoryModel>> getCategories() async {
    var categories = await recipesService.getCategories();
    return categories;
  }

  /// Builds the recipe category selector dropdown
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
        // checks if a category is selected
        if (value == null) {
          return 'Recipe Category is required';
        }
        return null;
      },
      onChanged: (value) {
        // update selected category
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
            widget.recipe != null ? 'Updating Recipe' : 'Create a new recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              children: const [
                Text('Enter the recipe information below:',
                    style: TextStyle(fontSize: 24))
              ],
            ),
            Expanded(
              flex: 2,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ReusableFormField(
                      controller: recipeName,
                      hint: 'Recipe Name',
                      minLength: 1,
                      maxLength: 50,
                    ),
                    FutureBuilder(
                      future: getCategories(),
                      builder: (context, snapshot) {
                        // build category dropdown
                        if (snapshot.hasData) {
                          // categories are found
                          var data = snapshot.data!;

                          return buildCategoryDropdown(data);
                        } else {
                          // display empty dropdown until categories are found
                          return buildCategoryDropdown([]);
                        }
                      },
                    ),
                    ReusableFormField(
                      controller: recipeDescription,
                      hint: 'Recipe Description',
                      maxLength: 400,
                    ),
                    ReusableFormField(
                        onlyNumbers: true,
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
                        // display dialog with error
                        showDialog(
                          context: context,
                          builder: (ctxt) => AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'))
                            ],
                            content: const Text(
                                'Failed to create or update the recipe.'),
                          ),
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
