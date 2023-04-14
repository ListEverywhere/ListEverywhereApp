import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/widgets/lists/shopping_list_item_entry.dart';

class ListItemsListView extends StatelessWidget {
  const ListItemsListView(
      {super.key,
      required this.items,
      required this.onChecked,
      required this.onDelete,
      required this.onUpdate,
      required this.onReorder,
      this.enableActions = true});

  final Function(bool?, ItemModel) onChecked;

  final Function(ItemModel) onDelete;

  final Function(ItemModel) onUpdate;

  final Function(int, ItemModel) onReorder;

  final List<ItemModel> items;

  final bool enableActions;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      onReorder: (oldIndex, newIndex) {
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
          onReorder(newIndex, current);
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
          enableActions: enableActions,
        );
      },
    );
  }
}
