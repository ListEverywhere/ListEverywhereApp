import 'package:listeverywhere_app/constants.dart';
import 'package:listeverywhere_app/models/category_model.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/models/search_model.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Provides various actions for Recipes, such as getting recipes or adding items
class RecipesService {
  /// Instance of [UserService]
  final userService = UserService();

  /// API url
  final String _url = '$apiUrl/recipes';

  /// Returns a recipe with the given [recipeId]
  Future<RecipeModel> getRecipeById(int recipeId) async {
    // get user token
    String token = await userService.getTokenIfSet();

    // send HTTP get to get recipe
    var response = await http.get(
      Uri.parse('$_url/$recipeId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // recipe was received
      return RecipeModel.fromJson(initialData);
    }

    // error has occurred, return message from response
    return Future.error(Exception(initialData['message'][0]));
  }

  /// Returns a list of recipes with a matching [userId]
  Future<List<RecipeModel>> getRecipesByUser(int userId) async {
    // get user token
    String token = await userService.getTokenIfSet();

    // send HTTP get to get recipe list
    var response = await http.get(
      Uri.parse('$_url/user/$userId?noItems=true'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // recipes was found, map JSON data to list of RecipeModel objects
      var recipes = (initialData as List<dynamic>).map((e) {
        return RecipeModel.fromJson(e);
      }).toList();
      return recipes;
    } else if (response.statusCode == 404) {
      // user has no recipes, return empty list
      return [];
    }

    // error has occurred, return message from response
    return Future.error(initialData['message'][0]);
  }

  /// Returns a list of recipes with a matching [category] id
  Future<List<RecipeModel>> getRecipesByCategory(int category) async {
    // get user token
    String token = await userService.getTokenIfSet();

    // send request to get recipes by category
    var response = await http.get(
      Uri.parse('$_url/categories/$category?noItems=true'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // map recipes to a list
      var recipes = (initialData as List<dynamic>).map((e) {
        return RecipeModel.fromJson(e);
      }).toList();
      // return recipe list
      return recipes;
    } else if (response.statusCode == 404) {
      // no recipes found, return empty list
      return [];
    }
    // error getting recipes
    return Future.error(initialData['message'][0]);
  }

  /// Returns a list of recipe categories that are available
  Future<List<CategoryModel>> getCategories() async {
    // get user token
    String token = await userService.getTokenIfSet();

    // send request to get all categories
    var response = await http.get(
      Uri.parse('$_url/categories/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // map categories to list
      var categories = (initialData as List<dynamic>).map((e) {
        return CategoryModel.fromJson(e);
      }).toList();
      // return category list
      return categories;
    }
    // error getting categories
    return Future.error(initialData['message'][0]);
  }

  /// Returns information about a single category given the [categoryId]
  Future<CategoryModel> getCategoryById(int categoryId) async {
    // get user token
    String token = await userService.getTokenIfSet();

    // send request to get category
    var response = await http.get(
      Uri.parse('$_url/categories/category/$categoryId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // map category to object
      var category = CategoryModel.fromJson(initialData);

      return category;
    }
    // error getting category
    return Future.error(initialData['message'][0]);
  }

  /// Search recipes by name given the parameters in [search] <br>
  /// Search type can only be contains, starts, ends
  Future<List<RecipeModel>> searchRecipes(SearchModel search) async {
    // create search data
    var searchData = jsonEncode(search);

    // get user token
    String token = await userService.getTokenIfSet();

    // send post request to search with search data
    var response = await http.post(
      Uri.parse('$_url/search/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: searchData,
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // recipes was found, map JSON data to list of RecipeModel objects
      var recipes = (initialData as List<dynamic>).map((e) {
        return RecipeModel.fromJson(e);
      }).toList();
      return recipes;
    } else if (response.statusCode == 404) {
      // no recipes found
      return [];
    }
    // error searching recipes
    return Future.error(initialData['message'][0]);
  }

  /// Creates a new recipe with the given [recipe] information, no steps or items included
  Future createRecipe(RecipeModel recipe) async {
    // get user token
    String token = await userService.getTokenIfSet();

    // send post request with recipe data
    var response = await http.post(
      Uri.parse(
        '$_url/',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(recipe),
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // created successfully
      return Future.value(1);
    }
    // error creating recipe
    return Future.error(initialData['message'][0]);
  }

  /// Deletes a recipe with the given [recipeId]
  Future deleteRecipe(int recipeId) async {
    // get user token
    String token = await userService.getTokenIfSet();

    // send delete request
    var response = await http.delete(
      Uri.parse('$_url/$recipeId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // deleted successfully
      return Future.value(1);
    }
    // failed to delete
    return Future.error(initialData['message'][0]);
  }

  /// Updates recipe information given [updated], not including items and steps
  Future updateRecipe(RecipeModel updated) async {
    // get user token
    String token = await userService.getTokenIfSet();
    // send request with recipe data
    var response = await http.put(
      Uri.parse('$_url/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updated),
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // successfully updated
      return Future.value(1);
    }
    // error updating
    return Future.error(initialData['message'][0]);
  }

  /// Adds a new item to a recipe given the [item]
  Future addRecipeItem(RecipeItemModel item) async {
    // get user token
    String token = await userService.getTokenIfSet();
    // send post request with item data
    var response = await http.post(
      Uri.parse('$_url/items/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(item),
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // added successfully
      return Future.value(1);
    }
    // failed to add
    return Future.error(initialData['message'][0]);
  }

  /// Deletes a recipe item given the [recipeItemId]
  Future deleteRecipeItem(int recipeItemId) async {
    // get user token
    String token = await userService.getTokenIfSet();
    // send delete request
    var response = await http.delete(
      Uri.parse('$_url/items/$recipeItemId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // deleted successfully
      return Future.value(1);
    }
    // failed to delete
    return Future.error(initialData['message'][0]);
  }

  /// Updates a recipe item given the [updated] information
  Future updateRecipeItem(RecipeItemModel updated) async {
    // get user token
    String token = await userService.getTokenIfSet();
    // send put request with item data
    var response = await http.put(
      Uri.parse('$_url/items/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updated),
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // successfully updated
      return Future.value(1);
    }
    // failed to update
    return Future.error(initialData['message'][0]);
  }

  /// Adds a new step to a recipe given the [step]
  Future addRecipeStep(RecipeStepModel step) async {
    // get user token
    String token = await userService.getTokenIfSet();
    // send post request with step data
    var response = await http.post(
      Uri.parse('$_url/steps/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(step),
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // successfully added
      return Future.value(1);
    }
    // failed to add
    return Future.error(initialData['message'][0]);
  }

  /// Updates a recpe step given the [updated] information
  Future updateRecipeStep(RecipeStepModel updated) async {
    // get user token
    String token = await userService.getTokenIfSet();
    // send put request with step data
    var response = await http.put(
      Uri.parse('$_url/steps/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updated),
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // successfully updated
      return Future.value(1);
    }
    // failed to update
    return Future.error(initialData['message'][0]);
  }

  /// Deletes a recipe step given the [recipeStepId]
  Future deleteRecipeStep(int recipeStepId) async {
    // get user token
    String token = await userService.getTokenIfSet();
    // send delete request
    var response = await http.delete(
      Uri.parse('$_url/steps/$recipeStepId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // successfully deleted
      return Future.value(1);
    }
    // failed to delete
    return Future.error(initialData['message'][0]);
  }

  /// Returns a list of recipes with matching items from [listItemIds]
  Future<List<RecipeModel>> matchListItemsToRecipes(
      List<int> listItemIds) async {
    // get user token
    var token = await userService.getTokenIfSet();

    // send post request with list item ids
    var response = await http.post(
      Uri.parse('$_url/item-match'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(listItemIds),
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // recipes was found, map JSON data to list of RecipeModel objects
      var recipes = (initialData as List<dynamic>).map((e) {
        return RecipeModel.fromJson(e);
      }).toList();
      return recipes;
    } else if (response.statusCode == 404) {
      // no recipes found
      return [];
    }
    // error finding recipes
    return Future.error(initialData['message'][0]);
  }

  /// Publishes or unpublishes a recipe, given the [recipeId] and [isPublished] status
  Future publishRecipe(int recipeId, bool isPublished) async {
    // get user token
    var token = await userService.getTokenIfSet();

    // send post request
    var response = await http.post(
      // if published, go to unpublish endpoint.
      // if unpublished, go to publish endpoint.
      Uri.parse(isPublished
          ? '$_url/unpublish/$recipeId'
          : '$_url/publish/$recipeId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    // decode initial data
    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // transaction successful
      return Future.value(1);
    }
    // failed
    return Future.error(initialData['message'][0]);
  }
}
