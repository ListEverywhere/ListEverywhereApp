import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/models/user_model.dart';
import 'package:listeverywhere_app/views/bottom_navbar.dart';
import 'package:listeverywhere_app/views/home.dart';
import 'package:listeverywhere_app/views/login.dart';
import 'package:listeverywhere_app/views/my_lists.dart';
import 'package:listeverywhere_app/views/my_recipes.dart';
import 'package:listeverywhere_app/views/register.dart';
import 'package:listeverywhere_app/views/single_list.dart';
import 'package:listeverywhere_app/views/single_recipe.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
  /*
  runApp(ChangeNotifierProvider(
    create: (context) => UserModel(
        firstName: firstName,
        lastName: lastName,
        email: email,
        dateOfBirth: dateOfBirth,
        username: username,
        password: password),
    child: const MyApp(),
  ));
  */
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ListEverywhere',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/welcome',
        routes: {
          //'/': (context) => BottomNavBar(),
          '/welcome': (context) => HomeView(),
          '/register': (context) => RegisterView(),
          '/login': (context) => LoginView(),
          '/lists': (context) => MyListsView(),
          '/lists/list': (context) => SingleListView(
              listId: ModalRoute.of(context)?.settings.arguments as int),
          '/recipes/user': (context) => MyRecipesView(),
          '/recipes/recipe': (context) => SingleRecipeView(
                recipeId: ModalRoute.of(context)?.settings.arguments as int,
              ),
        });
  }
}
