import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/list_model.dart';

class ShoppingListEntry extends StatelessWidget {
  final ListModel list;
  final Function(ListModel) updateCallback;
  final Function(int) deleteCallback;

  const ShoppingListEntry(
      {super.key,
      required this.list,
      required this.updateCallback,
      required this.deleteCallback});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.amber,
        onTap: () {
          print('Tapped list id ${list.listId}');
          Navigator.pushNamed(context, '/lists/list', arguments: list.listId);
        },
        child: SizedBox(
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(list.listName),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      print('Updating list ${list.listName}');
                      updateCallback(list);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      print('Deleting list ${list.listName}');
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
