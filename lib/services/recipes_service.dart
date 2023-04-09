import 'package:listeverywhere_app/constants.dart';
import 'package:listeverywhere_app/models/category_model.dart';
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

    var response = await http.get(
      Uri.parse('$_url/categories/$category?noItems=true'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var recipes = (initialData as List<dynamic>).map((e) {
        return RecipeModel.fromJson(e);
      }).toList();
      return recipes;
    } else if (response.statusCode == 404) {
      return [];
    }

    return Future.error(initialData['message'][0]);
  }

  Future<List<CategoryModel>> getCategories() async {
    // get user token
    String token = await userService.getTokenIfSet();

    var response = await http.get(
      Uri.parse('$_url/categories/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var categories = (initialData as List<dynamic>).map((e) {
        return CategoryModel.fromJson(e);
      }).toList();

      return categories;
    }

    return Future.error(initialData['message'][0]);
  }

  Future<List<RecipeModel>> searchRecipes(SearchModel search) async {
    // create search data
    var searchData = jsonEncode(search);

    // get user token
    String token = await userService.getTokenIfSet();

    var response = await http.post(
      Uri.parse('$_url/search/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: searchData,
    );

    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // recipes was found, map JSON data to list of RecipeModel objects
      var recipes = (initialData as List<dynamic>).map((e) {
        return RecipeModel.fromJson(e);
      }).toList();
      return recipes;
    } else if (response.statusCode == 404) {
      return [];
    }

    return Future.error(initialData['message'][0]);
  }

  Future createRecipe(RecipeModel recipe) async {
    // get user token
    String token = await userService.getTokenIfSet();

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

    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Future.value(1);
    }

    return Future.error(initialData['message'][0]);
  }
}
