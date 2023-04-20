import 'package:flutter/material.dart';
import 'package:listeverywhere_app/constants.dart';
import 'package:listeverywhere_app/models/list_model.dart';

/// A single shopping list card with information from [list]
class ShoppingListEntry extends StatelessWidget {
  /// List object
  final ListModel list;

  /// Callback function for updating
  final Function(ListModel) updateCallback;

  /// Callback function for deleting
  final Function(int) deleteCallback;

  final Function() onTap;

  final bool enableActions;

  const ShoppingListEntry(
      {super.key,
      required this.list,
      required this.updateCallback,
      required this.deleteCallback,
      required this.onTap,
      this.enableActions = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: secondary,
        onTap: onTap,
        child: SizedBox(
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(list.listName),
              ),
              if (enableActions)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        // update shopping list
                        updateCallback(list);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        // delete shopping list
                        deleteCallback(list.listId);
                      },
                      icon: const Icon(Icons.delete_forever),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
