import 'package:flutter/material.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/reusable_button.dart';

/// The home page of the application. Displays login and register options.
class HomeView extends StatelessWidget {
  HomeView({super.key});

  /// Instance of [UserService]
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    // if user token is available, automatically navigate to lists page
    userService.getTokenIfSet().then((value) {
      if (value != null) {
        Navigator.popAndPushNamed(context, '/lists');
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                  color: Colors.amber,
                  margin: const EdgeInsets.all(15.0),
                  child: const Center(
                    child: Text("Welcome to ListEverywhere!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 42.0)),
                  )),
            ),
            Expanded(
              child: ReusableButton(
                color: Colors.amber[200],
                text: "Sign in",
                onTap: () {
                  // user pressed login button
                  Navigator.pushNamed(context, '/login');
                },
                padding: const EdgeInsets.all(15.0),
              ),
            ),
            Expanded(
              child: ReusableButton(
                color: Colors.amber[300],
                text: "Sign up for a new account",
                onTap: () {
                  // user pressed register button
                  Navigator.pushNamed(context, '/register');
                },
                padding: const EdgeInsets.all(15.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
