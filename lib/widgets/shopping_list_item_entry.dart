import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';

class ShoppingListItemEntry extends StatefulWidget {
  ShoppingListItemEntry({super.key, required this.item});

  ItemModel item;

  @override
  State<StatefulWidget> createState() {
    return ShoppingListItemEntryState();
  }
}

class ShoppingListItemEntryState extends State<ShoppingListItemEntry> {
  late ItemModel item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  bool checked = false;

  @override
  Widget build(BuildContext context) {
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
                    setState(() {
                      checked = value!;
                    });
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
