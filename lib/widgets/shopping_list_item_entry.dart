import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';

class ShoppingListItemEntry extends StatefulWidget {
  ShoppingListItemEntry({
    super.key,
    required this.item,
    required this.checkedCallback,
    required this.deleteCallback,
    required this.updateCallback,
  });

  ItemModel item;
  final Function(bool?, ItemModel) checkedCallback;
  final Function(ItemModel) deleteCallback;
  final Function(ItemModel) updateCallback;

  @override
  State<StatefulWidget> createState() {
    return ShoppingListItemEntryState();
  }
}

class ShoppingListItemEntryState extends State<ShoppingListItemEntry> {
  late ItemModel item;
  bool checked = false;
  bool edit = false;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    checked = item.checked;
  }

  void checkedCallback(bool? value, ItemModel item) {
    widget.checkedCallback(value, item);
    setState(() {});
  }

  void deleteCallback(ItemModel item) {
    widget.deleteCallback(item);
    setState(() {});
  }

  void updateCallback(ItemModel item) {
    widget.updateCallback(item);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('Single Item Entry: ${item.itemId}');
    return ItemCard(
      item: item,
      checkedCallback: checkedCallback,
      deleteCallback: deleteCallback,
      updateCallback: updateCallback,
      edit: edit,
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.checkedCallback,
    required this.deleteCallback,
    required this.updateCallback,
    this.edit = false,
  });

  final ItemModel item;
  final Function(bool?, ItemModel) checkedCallback;
  final Function(ItemModel) deleteCallback;
  final Function(ItemModel) updateCallback;
  final bool edit;

  @override
  Widget build(BuildContext context) {
    bool checked = item.checked;
    return Card(
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        height: 80.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    value: checked,
                    onChanged: (value) {
                      item.checked = value!;
                      print('Item ${item.itemId} checked: $value');
                      checkedCallback(value, item);
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item.itemName),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    print('Updating item ${item.itemName}');
                    updateCallback(item);
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    print('Deleting item ${item.itemName}');
                    deleteCallback(item);
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
