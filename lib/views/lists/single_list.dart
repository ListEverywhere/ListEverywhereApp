import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/services/lists_service.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/floating_action_button_container.dart';
import 'package:listeverywhere_app/widgets/item_dialog.dart';
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
      // find type of item
      if (item.itemId < 0) {
        // custom list item
        item = CustomListItemModel(
            itemName: item.itemName,
            checked: false,
            position: -1,
            listId: widget.listId,
            customItemId: -1);
      } else {
        // list item
        item = ListItemModel(
          checked: false,
          itemId: item.itemId,
          listItemId: -1,
          listId: widget.listId,
          position: -1,
        );
      }

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
    ItemModel? originalItem = item;
    bool isCustom = false;
    bool hideCheckbox = false;

    // display the dialog
    return showDialog(
      context: context,
      builder: (context) {
        // if item is not null, item is being updated
        if (item != null) {
          if (item is CustomListItemModel) {
            return CustomListItemDialog(
              onSubmit: onSubmit,
              alertText: alertText,
              submitText: submitText,
              parentContext: context,
              listId: widget.listId,
              originalItem: item,
            );
          } else if (item is ListItemModel) {
            return ListItemDialog(
              onSubmit: onSubmit,
              alertText: alertText,
              submitText: submitText,
              parentContext: context,
              listId: widget.listId,
              originalItem: item,
              listsService: listsService,
            );
          }

          throw Exception('Invalid item.');
        } else {
          // adding item, show generic item dialog
          return ItemDialog(
            alertText: alertText,
            submitText: submitText,
            parentContext: context,
            listsService: listsService,
            onSubmit: onSubmit,
            originalItem: originalItem,
            isCustom: isCustom,
            hideCheckbox: hideCheckbox,
          );
        }
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
              return Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: buildItemList(snapshot.data!),
                  ),
                  Expanded(
                    child: FloatingActionButtonContainer(
                      onPressed: () async {
                        print('Add new list item');
                        // show add item dialog
                        await updateItem(context, null,
                            'Add an item to your list', 'Add item', addItem);
                        setState(() {});
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ],
              );
            }
            // data is not ready
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
