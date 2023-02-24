import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/list_model.dart';

class ShoppingListEntry extends StatelessWidget {
  ListModel list;

  ShoppingListEntry({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.amber,
        onTap: () {
          print('Tapped list id ${list.listId}');
        },
        child: SizedBox(
          height: 80.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(list.listName),
            ),
          ),
        ),
      ),
    );
  }
}
