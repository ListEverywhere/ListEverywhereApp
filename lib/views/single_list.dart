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
    await listsService.updateItem(item, false);
  }

  Future onDelete(ItemModel item) async {
    print('deleting item in single list.');
    await listsService.deleteItem(item);
    setState(() {});
  }

  Future<ListModel> getList() async {
    var list = await listsService.getListById(widget.listId);
    print('getting new list');

    listName = list.listName;
    return list;
  }

  Future<void> addItem(ItemModel? item) async {
    var user = await userService.getUserFromToken();
    if (item != null) {
      var listItem = ListItemModel(
        checked: false,
        itemId: item.itemId,
        listItemId: -1,
        listId: widget.listId,
        position: -1,
      );
      var response = await listsService.addItem(listItem).then((value) {
        print(value);
        Navigator.pop(context);
      });
    }
  }

  Future<void> editItem(ItemModel? item) async {
    print('updating item in single list');
    print(item);
    await listsService.updateItem(item!, false).then((value) {
      Navigator.pop(context);
    });
  }

  Future<void> onUpdate(ItemModel item) async {
    await updateItem(context, item, 'Updating item', 'Update', editItem);
    setState(() {});
  }

  Future<void> updateItem(BuildContext context, ItemModel? item,
      String alertText, String submitText, Function(ItemModel?) onSubmit) {
    TextEditingController itemName = TextEditingController();
    ItemModel? originalItem = item;
    ItemModel? newItem;
    List<ItemModel> items = [];

    if (originalItem != null) itemName.text = originalItem.itemName;

    return showDialog(
      context: context,
      builder: (context) {
        return ScaffoldMessenger(
          child: StatefulBuilder(builder: ((innerContext, setState) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: AlertDialog(
                title: Text(alertText),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter your item name, then press the search icon',
                      style: TextStyle(fontSize: 12.0),
                    ),
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
                                await listsService
                                    .searchItemsByName(itemName.text)
                                    .then((value) {
                                  if (value.isEmpty) {
                                  } else {
                                    setState(() {
                                      items = value;
                                      newItem = items.first;
                                    });
                                  }
                                }).onError((error, stackTrace) {
                                  ScaffoldMessenger.of(innerContext)
                                      .showSnackBar(SnackBar(
                                    content: const Text('Failed to get items.'),
                                    backgroundColor: Colors.red[400],
                                  ));
                                });
                              },
                              icon: const Icon(Icons.search)),
                        ),
                      ],
                    ),
                    DropdownButton<ItemModel>(
                      value: newItem,
                      items: items
                          .map<DropdownMenuItem<ItemModel>>(
                              (e) => DropdownMenuItem<ItemModel>(
                                    value: e,
                                    child: Text(e.itemName),
                                  ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          newItem = value;
                          print(newItem!.itemName);
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
                        Navigator.pop(innerContext);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: ReusableButton(
                      padding: const EdgeInsets.all(4.0),
                      text: submitText,
                      onTap: () {
                        if (originalItem != null) {
                          originalItem.itemId = newItem!.itemId;
                          onSubmit(originalItem);
                        } else {
                          onSubmit(newItem);
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          })),
        );
      },
    );
  }

  Widget buildItemList(ListModel list) {
    //print(list.listItems!.length);
    if (list.listItems != null) {
      var items = list.listItems!;
      //print(items);
      return ReorderableListView.builder(
        buildDefaultDragHandles: false,
        onReorder: (oldIndex, newIndex) async {
          if (oldIndex < newIndex) {
            newIndex--;
          }

          print('oldIndex: $oldIndex | newIndex $newIndex');

          ItemModel current = items.removeAt(oldIndex);

          current.position = newIndex;

          items.insert(newIndex, current);

          if (oldIndex != newIndex) {
            // update item position
            for (int i = 0; i < items.length; i++) {
              items[i].position = i;
            }
            // update position in API
            print('Updating item: $current to position $newIndex');
            var response = await listsService.updateItem(current, true);
            print('Response: $response');
          }
        },
        itemCount: items.length,
        itemBuilder: (context, index) {
          //print(items[index].itemName);
          return ShoppingListItemEntry(
            item: items[index],
            key: Key(items[index].hashCode.toString()),
            checkedCallback: onChecked,
            deleteCallback: onDelete,
            updateCallback: onUpdate,
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
            await updateItem(
                context, null, 'Add an item to your list', 'Add item', addItem);
            setState(() {});
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder(
          future: getList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.listItems!.isEmpty) {
                return const Center(
                    child: Text('There are no items in this list.'));
              }
              return buildItemList(snapshot.data!);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
