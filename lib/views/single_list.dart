import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/widgets/shopping_list_item_entry.dart';

class SingleListView extends StatefulWidget {
  SingleListView({super.key, required this.items});
  List<ItemModel>? items;

  @override
  State<StatefulWidget> createState() {
    return SingleListViewState();
  }
}

class SingleListViewState extends State<SingleListView> {
  @override
  Widget build(BuildContext context) {
    if (widget.items != null) {
      var items = widget.items!;
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ShoppingListItemEntry(item: items[index]);
        },
      );
    } else {
      return const Center(
        child: Text('List has no items.'),
      );
    }
  }
}
