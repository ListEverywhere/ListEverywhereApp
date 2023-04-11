import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/services/lists_service.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/bottom_navbar.dart';
import 'package:listeverywhere_app/widgets/floating_action_button_container.dart';
import 'package:listeverywhere_app/widgets/reusable_button.dart';
import 'package:listeverywhere_app/widgets/reusable_field.dart';
import 'package:listeverywhere_app/widgets/shopping_list_entry.dart';
import 'package:listeverywhere_app/widgets/text_field_dialog.dart';

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
    if (list != null && list.listName.isNotEmpty) {
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
    if (list != null && list.listName.isNotEmpty) {
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
    // displays the dialog
    return showDialog(
      context: context,
      builder: (context) {
        return TextFieldDialog(
          alertText: alertText,
          formHint: 'List Name',
          submitText: submitText,
          initialText: list != null ? list.listName : '',
          onSubmit: (newName) {
            if (list != null) {
              // if list is not null, list is being updated
              list.listName = newName;
              // run callback
              onSubmit(list);
            } else {
              // create new list
              ListModel newList = ListModel(
                  listId: -1,
                  userId: -1,
                  listName: newName,
                  creationDate: DateTime.now(),
                  lastModified: DateTime.now());
              // run callback
              onSubmit(newList);
            }
          },
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
            return Column(
              children: [
                Expanded(
                  flex: 4,
                  child: ListView.builder(
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
                  ),
                ),
                Expanded(
                  child: FloatingActionButtonContainer(
                    onPressed: () async {
                      // create new list
                      await createNewList(context);
                      setState(() {});
                    },
                    icon: const Icon(Icons.add),
                  ),
                )
              ],
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
