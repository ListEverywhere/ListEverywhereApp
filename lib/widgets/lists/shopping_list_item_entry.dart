import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';

/// A single shopping list item entry using information from [item]
class ShoppingListItemEntry extends StatefulWidget {
  const ShoppingListItemEntry({
    super.key,
    required this.item,
    required this.checkedCallback,
    required this.deleteCallback,
    required this.updateCallback,
    this.enableActions = true,
  });

  /// Item object
  final ItemModel item;

  /// Callback function for when item is checked
  final Function(bool?, ItemModel) checkedCallback;

  /// Callback function for when item is deleted
  final Function(ItemModel) deleteCallback;

  /// Callback function for when item is updated
  final Function(ItemModel) updateCallback;

  /// Enable editing
  final bool enableActions;

  @override
  State<StatefulWidget> createState() {
    return ShoppingListItemEntryState();
  }
}

/// State for shopping list item entry
class ShoppingListItemEntryState extends State<ShoppingListItemEntry> {
  /// Item object
  late ItemModel item;

  /// Is item checked
  bool checked = false;

  @override
  void initState() {
    super.initState();
    // set item and checked property
    item = widget.item;
    checked = item.checked;
  }

  /// Runs checked callback and updates state
  void checkedCallback(bool? value, ItemModel item) {
    widget.checkedCallback(value, item);
    setState(() {});
  }

  /// Runs delete callback and updates state
  void deleteCallback(ItemModel item) {
    widget.deleteCallback(item);
    setState(() {});
  }

  /// Runs update callback and updates state
  void updateCallback(ItemModel item) {
    widget.updateCallback(item);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ItemCard(
      item: item,
      checkedCallback: checkedCallback,
      deleteCallback: deleteCallback,
      updateCallback: updateCallback,
      edit: widget.enableActions,
    );
  }
}

/// A single shopping list item card
class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.checkedCallback,
    required this.deleteCallback,
    required this.updateCallback,
    this.edit = true,
    this.enableDragHandles = true,
  });

  /// Item object
  final ItemModel item;

  /// Callback for checked
  final Function(bool?, ItemModel) checkedCallback;

  /// Callback for delete
  final Function(ItemModel) deleteCallback;

  /// Callback for update
  final Function(ItemModel) updateCallback;
  final bool edit;

  final bool enableDragHandles;

  @override
  Widget build(BuildContext context) {
    bool checked = item.checked;
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 60.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                      value: checked,
                      onChanged: (value) {
                        // user checked/unchecked item
                        item.checked = value!;
                        checkedCallback(value, item);
                      }),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item.itemName),
                    ),
                  ),
                ],
              ),
            ),
            if (edit)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      // updating item
                      updateCallback(item);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      // deleting item
                      deleteCallback(item);
                    },
                    icon: const Icon(Icons.delete_forever),
                  ),
                  // create drag handles
                  if (enableDragHandles)
                    ReorderableDragStartListener(
                      index: item.position,
                      child: const Icon(Icons.drag_handle),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
