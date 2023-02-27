import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/services/lists_service.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/shopping_list_entry.dart';

class MyListsView extends StatelessWidget {
  MyListsView({super.key});

  final userService = UserService();
  final listsService = ListsService();

  void test() {
    listsService.getUserLists(2);
  }

  Future<List<ListModel>> getLists() async {
    var user = await userService.getUserFromToken();
    var lists = await listsService.getUserLists(user.id!);
    return lists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.amber)),
              onPressed: () {
                userService.logoff();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
              child: const Text('Log off'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Add new list');
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<ListModel>>(
        future: getLists(),
        builder: (context, snapshot) {
          // waiting for data
          if (snapshot.hasData) {
            List<ListModel> data = snapshot.data!;
            if (data.isEmpty) {
              return const Center(
                child: Text('You do not have any Shopping Lists.'),
              );
            }
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ShoppingListEntry(list: data[index]);
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
