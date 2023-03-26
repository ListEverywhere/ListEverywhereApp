import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/services/lists_service.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/reusable_button.dart';
import 'package:listeverywhere_app/widgets/reusable_field.dart';
import 'package:listeverywhere_app/widgets/shopping_list_entry.dart';

class MyListsView extends StatefulWidget {
  const MyListsView({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyListsViewState();
  }
}

class MyListsViewState extends State<MyListsView> {
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

  Future<void> createNewList(BuildContext context) {
    TextEditingController listName = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create a new Shopping List'),
          content: ReusableFormField(controller: listName, hint: 'List Name'),
          actions: [
            SizedBox(
              width: 100,
              height: 50,
              child: ReusableButton(
                padding: const EdgeInsets.all(4.0),
                text: 'Cancel',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(
              width: 100,
              height: 50,
              child: ReusableButton(
                padding: const EdgeInsets.all(4.0),
                text: 'Create List',
                onTap: () async {
                  var user = await userService.getUserFromToken();
                  var response = await listsService
                      .createList(listName.text, user.id!)
                      .then((value) {
                    print(value);
                    Navigator.pop(context);
                  });
                },
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
        automaticallyImplyLeading: false,
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
        onPressed: () async {
          print('Add new list');
          await createNewList(context);
          setState(() {});
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
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(snapshot.error.toString()),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false),
                  child: const Text('Back'),
                ),
              ],
            ));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
