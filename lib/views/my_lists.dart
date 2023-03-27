import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/services/lists_service.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/views/bottom_navbar.dart';
import 'package:listeverywhere_app/widgets/reusable_button.dart';
import 'package:listeverywhere_app/widgets/reusable_field.dart';
import 'package:listeverywhere_app/widgets/shopping_list_entry.dart';

/// Displays a list of a user's Shopping Lists
class MyListsView extends StatefulWidget {
  const MyListsView({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyListsViewState();
  }
}

class MyListsViewState extends State<MyListsView> {
  /// Instance of [UserService]
  final userService = UserService();

  /// Instance of [ListsService]
  final listsService = ListsService();

  /// Returns a list of the user's shopping lists
  Future<List<ListModel>> getLists() async {
    // get user details
    var user = await userService.getUserFromToken();
    // get lists using user id
    var lists = await listsService.getUserLists(user.id!);
    return lists;
  }

  /// Creates a new shopping list
  Future<void> addList(ListModel? list) async {
    if (list != null) {
      // get user details
      var user = await userService.getUserFromToken();
      // set user id in new shopping list
      list.userId = user.id!;
      // use lists service to create list
      var response =
          await listsService.createList(list.listName, user.id!).then((value) {
        print(value);
        // if successful, close the dialog
        Navigator.pop(context);
      });
    }
  }

  /// Updates a shopping list
  Future<void> updateList(ListModel? list) async {
    if (list != null) {
      // use lists service to update the list
      var response = await listsService.updateList(list).then((value) {
        print(value);
        // if successful, close the dialog
        Navigator.pop(context);
      });
    }
  }

  /// Deletes a shopping list with matching [listId]
  Future<void> deleteList(int listId) async {
    await listsService.deleteList(listId);
  }

  /// Displays the dialog for updating a list
  Future<void> showUpdateList(BuildContext context, ListModel list) async {
    await updateListDialog(
        context, list, 'Updating list', 'Submit', updateList);
  }

  /// Displays the dialog for creating a list
  Future<void> createNewList(BuildContext context) async {
    await updateListDialog(
        context, null, 'Create a new Shopping List', 'Submit', addList);
  }

  /// Displays the dialog for adding/updating a shopping list
  Future<void> updateListDialog(BuildContext context, ListModel? list,
      String alertText, String submitText, Function(ListModel?) onSubmit) {
    // stores the list name text
    TextEditingController listName = TextEditingController();
    // set the field text if a list is specified
    listName.text = list != null ? list.listName : '';

    // displays the dialog
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(alertText),
          content: ReusableFormField(controller: listName, hint: 'List Name'),
          actions: [
            SizedBox(
              width: 100,
              height: 50,
              child: ReusableButton(
                padding: const EdgeInsets.all(4.0),
                text: 'Cancel',
                onTap: () {
                  // exit dialog, no action
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(
              width: 100,
              height: 50,
              child: ReusableButton(
                padding: const EdgeInsets.all(4.0),
                text: submitText,
                onTap: () async {
                  if (list != null) {
                    // if list is not null, list is being updated
                    list.listName = listName.text;
                    // run callback
                    onSubmit(list);
                  } else {
                    // create new list
                    ListModel newList = ListModel(
                        listId: -1,
                        userId: -1,
                        listName: listName.text,
                        creationDate: DateTime.now(),
                        lastModified: DateTime.now());
                    // run callback
                    onSubmit(newList);
                  }
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
                // user clicked logoff, pop all routes until back at welcome screen
                userService.logoff();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/welcome', (route) => false);
              },
              child: const Text('Log off'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // create new list
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
              // user has no shopping lists
              return const Center(
                child: Text('You do not have any Shopping Lists.'),
              );
            }
            // build list of shopping lists
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ShoppingListEntry(
                  list: data[index],
                  updateCallback: (list) async {
                    await showUpdateList(context, list);
                    setState(() {});
                  },
                  deleteCallback: (id) async {
                    await deleteList(id);
                    setState(() {});
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            // failed to load lists, likely token expired
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // display error and back button
                Text(snapshot.error.toString()),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/welcome', (route) => false),
                  child: const Text('Back'),
                ),
              ],
            ));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        parentContext: context,
      ),
    );
  }
}
