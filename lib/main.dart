import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/models/user_model.dart';
import 'package:listeverywhere_app/views/home.dart';
import 'package:listeverywhere_app/views/login.dart';
import 'package:listeverywhere_app/views/my_lists.dart';
import 'package:listeverywhere_app/views/register.dart';
import 'package:listeverywhere_app/views/single_list.dart';
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
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeView(),
          '/register': (context) => RegisterView(),
          '/login': (context) => LoginView(),
          '/lists': (context) => MyListsView(),
          '/lists/list': (context) => SingleListView(
              items:
                  ModalRoute.of(context)?.settings.arguments as List<ItemModel>)
        });
  }
}
