import 'package:flutter/material.dart';
import 'package:listeverywhere_app/services/lists_service.dart';
import 'package:listeverywhere_app/services/user_service.dart';

class MyListsView extends StatelessWidget {
  MyListsView({super.key});

  final userService = UserService();
  final listsService = ListsService();

  void test() {
    listsService.getUserLists(2);
  }

  @override
  Widget build(BuildContext context) {
    test();
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Logged in.'),
            ElevatedButton(
              onPressed: () {
                userService.logoff();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
              child: const Text('Log off'),
            ),
          ],
        ),
      ),
    );
  }
}
