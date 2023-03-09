import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/services/lists_service.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/reusable_button.dart';
import 'package:listeverywhere_app/widgets/reusable_field.dart';
import 'package:listeverywhere_app/widgets/shopping_list_item_entry.dart';

class SingleListView extends StatefulWidget {
  SingleListView({super.key, required this.listId});
  int listId;

  @override
  State<StatefulWidget> createState() {
    return SingleListViewState();
  }
}

class SingleListViewState extends State<SingleListView> {
  final userService = UserService();
  final listsService = ListsService();
  String listName = '';

  Future onChecked(bool? value, ItemModel item) async {
    print('updating item checked state');
    await listsService.updateItem(item);
  }

  Future<ListModel> getList() async {
    var list = await listsService.getListById(widget.listId);
    print('getting new list');

    listName = list.listName;
    return list;
  }

  Future<void> addNewItem(BuildContext context) {
    TextEditingController itemName = TextEditingController();
    ItemModel? item;
    List<ItemModel> items = [];

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: ((context, setState) {
          return AlertDialog(
            title: const Text('Add an item to your list'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: ReusableFormField(
                          controller: itemName, hint: 'Item Name'),
                    ),
                    Expanded(
                      child: IconButton(
                          onPressed: () async {
                            var newItems = await listsService
                                .searchItemsByName(itemName.text);
                            setState(() {
                              items = newItems;
                            });
                          },
                          icon: const Icon(Icons.search)),
                    ),
                  ],
                ),
                DropdownButton<ItemModel>(
                  value: item,
                  items: items
                      .map<DropdownMenuItem<ItemModel>>(
                          (e) => DropdownMenuItem<ItemModel>(
                                value: e,
                                child: Text(e.itemName),
                              ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      item = value;
                      print(item!.itemName);
                    });
                  },
                ),
              ],
            ),
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
                  text: 'Add Item',
                  onTap: () async {
                    var user = await userService.getUserFromToken();
                    if (item != null) {
                      var listItem = ListItemModel(
                        checked: false,
                        itemId: item!.itemId,
                        listItemId: -1,
                        listId: widget.listId,
                      );
                      var response =
                          await listsService.addItem(listItem).then((value) {
                        print(value);
                        Navigator.pop(context);
                      });
                    }
                  },
                ),
              )
            ],
          );
        }));
      },
    );
  }

  Widget buildItemList(ListModel list) {
    print(list.listItems!.length);
    if (list.listItems != null) {
      var items = list.listItems!;
      print(items);
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          print(items[index].itemName);
          return ShoppingListItemEntry(
            item: items[index],
            key: Key(items[index].itemName),
            checkedCallback: onChecked,
          );
        },
      );
    } else {
      return const Center(
        child: Text('List has no items.'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(listName)),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            print('Add new list item');
            await addNewItem(context);
            setState(() {});
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder(
          future: getList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildItemList(snapshot.data!);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
