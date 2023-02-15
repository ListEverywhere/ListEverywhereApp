import 'package:flutter/material.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/reusable_button.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
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
                onTap: () {},
                padding: const EdgeInsets.all(15.0),
              ),
            ),
            Expanded(
              child: ReusableButton(
                color: Colors.amber[300],
                text: "Sign up for a new account",
                onTap: () {
                  //registerTest();
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
