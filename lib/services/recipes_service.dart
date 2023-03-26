import 'package:listeverywhere_app/constants.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class RecipesService {
  final userService = UserService();
  final String _url = '$apiUrl/recipes';

  Future<RecipeModel> getRecipeById(int recipeId) async {
    String token = await userService.getTokenIfSet();

    var response = await http.get(
      Uri.parse('$_url/$recipeId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    var initialData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return RecipeModel.fromJson(initialData);
    }

    return Future.error(Exception(initialData['message'][0]));
  }

  Future<List<RecipeModel>> getRecipesByUser(int userId) async {
    String token = await userService.getTokenIfSet();

    var response = await http.get(
      Uri.parse('$_url/user/$userId'),
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
      print('No recipes found.');
      return [];
    }

    return Future.error(initialData['message'][0]);
  }
}
