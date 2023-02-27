import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/widgets/shopping_list_item_entry.dart';

class SingleListView extends StatefulWidget {
  SingleListView({super.key, required this.list});
  ListModel list;

  @override
  State<StatefulWidget> createState() {
    return SingleListViewState();
  }
}

class SingleListViewState extends State<SingleListView> {
  Widget buildItemList() {
    if (widget.list.listItems != null) {
      var items = widget.list.listItems!;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.list.listName)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('Add new list item');
          },
          child: const Icon(Icons.add),
        ),
        body: buildItemList());
  }
}
