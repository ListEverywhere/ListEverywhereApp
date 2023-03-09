import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';

class ShoppingListItemEntry extends StatefulWidget {
  ShoppingListItemEntry({
    super.key,
    required this.item,
    required this.checkedCallback,
  });

  ItemModel item;
  Function(bool?, ItemModel) checkedCallback;

  @override
  State<StatefulWidget> createState() {
    return ShoppingListItemEntryState();
  }
}

class ShoppingListItemEntryState extends State<ShoppingListItemEntry> {
  late ItemModel item;
  bool checked = false;

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

  @override
  Widget build(BuildContext context) {
    print('Single Item Entry: ${item.itemId}');
    return ItemCard(
      item: item,
      checkedCallback: checkedCallback,
    );
  }
}

class ListItemCard extends ItemCard {
  const ListItemCard({
    super.key,
    required super.item,
    required super.checkedCallback,
  });
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.checkedCallback,
  });

  final ItemModel item;
  final Function(bool?, ItemModel) checkedCallback;

  @override
  Widget build(BuildContext context) {
    bool checked = item.checked;
    return Card(
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        height: 80.0,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
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
        ),
      ),
    );
  }
}
