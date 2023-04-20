import 'package:flutter/material.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/fatsecret_badge.dart';
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
                  color: Colors.blue,
                  margin: const EdgeInsets.all(15.0),
                  child: const Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: 'Welcome to ListEverywhere!\n',
                              style: TextStyle(
                                  fontSize: 42.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                            text: 'Your shopping lists reimagined.',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),
            Expanded(
              child: ReusableButton(
                color: Colors.blue[200],
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
                color: Colors.blue[300],
                text: "Sign up for a new account",
                onTap: () {
                  // user pressed register button
                  Navigator.pushNamed(context, '/register');
                },
                padding: const EdgeInsets.all(15.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text('ListEverywhere 2023'),
                  FatSecretBadge(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
