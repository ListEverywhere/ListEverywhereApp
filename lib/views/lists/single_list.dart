import 'package:flutter/material.dart';
import 'package:listeverywhere_app/constants.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/services/lists_service.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/fatsecret_badge.dart';
import 'package:listeverywhere_app/widgets/floating_action_button_container.dart';
import 'package:listeverywhere_app/widgets/item_dialog.dart';
import 'package:listeverywhere_app/widgets/lists/list_items_list_view.dart';

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

  /// List object
  ListModel? list;

  /// Updates the [item] checked property using [value]
  Future onChecked(bool? value, ItemModel item) async {
    print('updating item checked state');
    // update item using lists service
    await listsService.updateItem(item, false);

    if (item.checked) {
      // move item to end of list
      item.position = list!.listItems!.length - 1;

      await listsService.updateItem(item, true);

      setState(() {});
    }
  }

  /// Deletes the [item] from the server
  Future onDelete(ItemModel item) async {
    print('deleting item in single list.');
    // delete item using lists service
    await listsService.deleteItem(item).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to delete item.'),
        backgroundColor: errorColor,
      ));
    });
    setState(() {});
  }

  /// Returns a shopping list object with the class variable [listId]
  Future<ListModel> getList() async {
    // get list from lists service
    var list = await listsService.getListById(widget.listId);
    print('getting new list');

    // set the list name
    listName = list.listName;

    // set list
    this.list = list;

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
      }).onError((error, stackTrace) {
        // close the dialog, error
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to add item.'),
          backgroundColor: errorColor,
        ));
      });
      ;
    }
  }

  /// Updates an [item] from the list
  Future<void> editItem(ItemModel? item) async {
    print('updating item in single list');
    // use lists service to update item
    await listsService.updateItem(item!, false).then((value) {
      // close the dialog
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      // close the dialog, error
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to update item.'),
        backgroundColor: errorColor,
      ));
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
      return ListItemsListView(
        items: items,
        onChecked: onChecked,
        onDelete: onDelete,
        onUpdate: onUpdate,
        onReorder: (index, current) async {
          // update position in API
          print('Updating item: $current to position $index');
          var response = await listsService.updateItem(current, true);
          print('Response: $response');
        },
      );
    } else {
      // list is empty
      return const Center(
        child: Text('List has no items.'),
      );
    }
  }

  Widget buildListItemContainer(BuildContext context, Widget child) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: child,
        ),
        Expanded(
          child: FloatingActionButtonContainer(
            onPressed: () async {
              print('Add new list item');
              // show add item dialog
              await updateItem(context, null, 'Add an item to your list',
                  'Add item', addItem);
              setState(() {});
            },
            icon: const Icon(Icons.add),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: FatSecretBadge(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(listName)),
        body: SafeArea(
          child: FutureBuilder(
            future: getList(),
            builder: (context, snapshot) {
              // check if data is available
              if (snapshot.hasData) {
                if (snapshot.data!.listItems!.isEmpty) {
                  // list has no items
                  return buildListItemContainer(
                    context,
                    const Center(
                      child: Text('There are no items in this list.'),
                    ),
                  );
                }
                // data is available and not empty
                return buildListItemContainer(
                  context,
                  buildItemList(snapshot.data!),
                );
              }
              // data is not ready
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}
