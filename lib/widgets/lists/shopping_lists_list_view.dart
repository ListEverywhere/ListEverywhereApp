import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/widgets/lists/shopping_list_entry.dart';

class ShoppingListsListView extends StatelessWidget {
  const ShoppingListsListView(
      {super.key,
      required this.onUpdate,
      required this.onDelete,
      required this.onTap,
      this.enableActions = true,
      required this.data});

  final Function(ListModel) onUpdate;
  final Function(int) onDelete;
  final Function(ListModel) onTap;
  final bool enableActions;
  final List<ListModel> data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ShoppingListEntry(
          list: data[index],
          onTap: () {
            onTap(data[index]);
          },
          updateCallback: onUpdate,
          deleteCallback: onDelete,
          enableActions: enableActions,
        );
      },
    );
  }
}
