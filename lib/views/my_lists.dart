import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/services/lists_service.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/views/bottom_navbar.dart';
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

  Future<void> addList(ListModel? list) async {
    if (list != null) {
      var user = await userService.getUserFromToken();
      list.userId = user.id!;
      var response =
          await listsService.createList(list.listName, user.id!).then((value) {
        print(value);
        Navigator.pop(context);
      });
    }
  }

  Future<void> updateList(ListModel? list) async {
    if (list != null) {
      var response = await listsService.updateList(list).then((value) {
        print(value);
        Navigator.pop(context);
      });
    }
  }

  Future<void> deleteList(int listId) async {
    await listsService.deleteList(listId);
  }

  Future<void> showUpdateList(BuildContext context, ListModel list) async {
    await updateListDialog(
        context, list, 'Updating list', 'Submit', updateList);
  }

  Future<void> createNewList(BuildContext context) async {
    await updateListDialog(
        context, null, 'Create a new Shopping List', 'Submit', addList);
  }

  Future<void> updateListDialog(BuildContext context, ListModel? list,
      String alertText, String submitText, Function(ListModel?) onSubmit) {
    TextEditingController listName = TextEditingController();
    listName.text = list != null ? list.listName : '';

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
                    list.listName = listName.text;
                    onSubmit(list);
                  } else {
                    ListModel newList = ListModel(
                        listId: -1,
                        userId: -1,
                        listName: listName.text,
                        creationDate: DateTime.now(),
                        lastModified: DateTime.now());
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        parentContext: context,
      ),
    );
  }
}
