import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/services/lists_service.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/reusable_button.dart';
import 'package:listeverywhere_app/widgets/reusable_field.dart';
import 'package:listeverywhere_app/widgets/shopping_list_item_entry.dart';

/// Provides the view for a single shopping list using the [listId]
class SingleListView extends StatefulWidget {
  const SingleListView({super.key, required this.listId});

  /// ID number of the list
  final int listId;

  @override
  State<StatefulWidget> createState() {
    return SingleListViewState();
  }
}

class SingleListViewState extends State<SingleListView> {
  /// Instance of [UserService]
  final userService = UserService();

  /// Instance of [ListsService]
  final listsService = ListsService();

  /// Name of the list
  String listName = '';

  /// Updates the [item] checked property using [value]
  Future onChecked(bool? value, ItemModel item) async {
    print('updating item checked state');
    // update item using lists service
    await listsService.updateItem(item, false);
  }

  /// Deletes the [item] from the server
  Future onDelete(ItemModel item) async {
    print('deleting item in single list.');
    // delete item using lists service
    await listsService.deleteItem(item);
    setState(() {});
  }

  /// Returns a shopping list object with the class variable [listId]
  Future<ListModel> getList() async {
    // get list from lists service
    var list = await listsService.getListById(widget.listId);
    print('getting new list');

    // set the list name
    listName = list.listName;
    return list;
  }

  /// Adds [item] to the shopping list
  Future<void> addItem(ItemModel? item) async {
    var user = await userService.getUserFromToken();
    if (item != null) {
      // if item is not null, add item using lists service
      var response = await listsService.addItem(item).then((value) {
        print(value);
        // close the dialog
        Navigator.pop(context);
      });
    }
  }

  /// Updates an [item] from the list
  Future<void> editItem(ItemModel? item) async {
    print('updating item in single list');
    // use lists service to update item
    await listsService.updateItem(item!, false).then((value) {
      // close the dialog
      Navigator.pop(context);
    });
  }

  /// Callback for updating an item
  Future<void> onUpdate(ItemModel item) async {
    await updateItem(context, item, 'Updating item', 'Update', editItem);
    setState(() {});
  }

  /// Displays a dialog for adding/updating a list item
  Future<void> updateItem(BuildContext context, ItemModel? item,
      String alertText, String submitText, Function(ItemModel?) onSubmit) {
    // stores item name
    TextEditingController itemName = TextEditingController();
    ItemModel? originalItem = item;
    ItemModel? newItem;
    List<ItemModel> items = [];
    bool isCustom = false;
    bool disableCheckbox = false;
    bool hideCheckbox = false;

    // if item is not null, item is being updated
    if (item != null) {
      if (item is CustomListItemModel) {
        // prevent changing item type
        disableCheckbox = true;
        // hide item search
        isCustom = true;
      } else if (item is ListItemModel) {
        // prevent changing item type
        hideCheckbox = true;
      }
    }
    // set the item text field if updating item
    if (originalItem != null) itemName.text = originalItem.itemName;

    // display the dialog
    return showDialog(
      context: context,
      builder: (context) {
        // create new scaffold so that snackbar show up above dialog
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
                        // if custom item is selected, hide item search
                        if (!isCustom)
                          Expanded(
                            child: IconButton(
                                onPressed: () async {
                                  // search icon pressed, search items
                                  await listsService
                                      .searchItemsByName(itemName.text)
                                      .then((value) {
                                    if (value.isEmpty) {
                                    } else {
                                      // update items value and set current item to first
                                      setState(() {
                                        items = value;
                                        newItem = items.first;
                                      });
                                    }
                                  }).onError((error, stackTrace) {
                                    // display error that items failed to load
                                    ScaffoldMessenger.of(innerContext)
                                        .showSnackBar(SnackBar(
                                      content:
                                          const Text('Failed to get items.'),
                                      backgroundColor: Colors.red[400],
                                    ));
                                  });
                                },
                                icon: const Icon(Icons.search)),
                          ),
                      ],
                    ),
                    // if custom item is chosen, do not show
                    if (!isCustom)
                      DropdownButton<ItemModel>(
                        value: newItem,
                        // map items to a list of DropdownMenuItems
                        items: items
                            .map<DropdownMenuItem<ItemModel>>(
                                (e) => DropdownMenuItem<ItemModel>(
                                      value: e,
                                      child: Text(e.itemName),
                                    ))
                            .toList(),
                        onChanged: (value) {
                          // update current item to changed item
                          setState(() {
                            newItem = value;
                          });
                        },
                      ),
                    // hide checkbox when updating items
                    if (!hideCheckbox)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: isCustom,
                            onChanged: (value) {
                              setState(() {
                                isCustom = disableCheckbox ? true : value!;
                              });
                            },
                          ),
                          const Text('I can\'t find my item'),
                        ],
                      ),
                    Text(
                      // display text only if custom item is selected
                      isCustom
                          ? 'This item will be added as a custom item.\nIt cannot be used for recipe matching.'
                          : '',
                      style: const TextStyle(fontSize: 12.0),
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
                        // exit dialog, no changes
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
                        // if originalItem is not null, item is being updated
                        if (originalItem != null) {
                          // itemId is set if the item is not a custom item, otherwise set to -1
                          originalItem.itemId =
                              originalItem.itemId >= 0 ? newItem!.itemId : -1;
                          // set item name for custom items
                          originalItem.itemName = itemName.text;
                          // run callback
                          onSubmit(originalItem);
                        } else {
                          if (isCustom) {
                            // create new custom list item
                            newItem = CustomListItemModel(
                                itemName: itemName.text,
                                checked: false,
                                position: -1,
                                listId: widget.listId,
                                customItemId: -1);
                          } else {
                            // create new list item model
                            int itemId = newItem!.itemId;
                            newItem = ListItemModel(
                              checked: false,
                              itemId: itemId,
                              listItemId: -1,
                              listId: widget.listId,
                              position: -1,
                            );
                          }
                          // run callback
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

  /// Builds the ListView for the items from [list]
  Widget buildItemList(ListModel list) {
    // only continue if there are list items
    if (list.listItems != null) {
      var items = list.listItems!;
      // create reordable list
      return ReorderableListView.builder(
        buildDefaultDragHandles: false,
        onReorder: (oldIndex, newIndex) async {
          // update position of item
          if (oldIndex < newIndex) {
            // decrease newIndex by 1 when moving items down the list
            newIndex--;
          }

          // remove item at old position
          ItemModel current = items.removeAt(oldIndex);

          current.position = newIndex;

          // insert item at new position
          items.insert(newIndex, current);

          if (oldIndex != newIndex) {
            // update item positions
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
          // build the item entry
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
      // list is empty
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
            // show add item dialog
            await updateItem(
                context, null, 'Add an item to your list', 'Add item', addItem);
            setState(() {});
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder(
          future: getList(),
          builder: (context, snapshot) {
            // check if data is available
            if (snapshot.hasData) {
              if (snapshot.data!.listItems!.isEmpty) {
                // list has no items
                return const Center(
                    child: Text('There are no items in this list.'));
              }
              // data is available and not empty
              return buildItemList(snapshot.data!);
            }
            // data is not ready
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
