import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/widgets/lists/shopping_list_entry.dart';

/// Creates a list view of shopping lists
class ShoppingListsListView extends StatelessWidget {
  const ShoppingListsListView(
      {super.key,
      required this.onUpdate,
      required this.onDelete,
      required this.onTap,
      this.enableActions = true,
      required this.data});

  /// Callback function for updating
  final Function(ListModel) onUpdate;

  /// Callback function for deleting
  final Function(int) onDelete;

  /// Callback function for tapping
  final Function(ListModel) onTap;

  /// Enable editing
  final bool enableActions;

  /// List of Shopping Lists
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
