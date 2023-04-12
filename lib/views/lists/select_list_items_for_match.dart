import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/widgets/lists/list_items_list_view.dart';

class SelectListItemsForMatchView extends StatefulWidget {
  const SelectListItemsForMatchView({super.key, required this.listItems});

  final List<ItemModel> listItems;

  @override
  State<StatefulWidget> createState() {
    return SelectListItemsForMatchViewState();
  }
}

class SelectListItemsForMatchViewState
    extends State<SelectListItemsForMatchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Search by List Items')),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Center(
                child: Text(
              'Select list items to match',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            )),
          ),
          Expanded(
            flex: 4,
            child: Builder(
              builder: (context) {
                if (widget.listItems.isNotEmpty) {
                  return ListItemsListView(
                    items: widget.listItems,
                    enableActions: false,
                    onChecked: (value, item) {},
                    onDelete: (p0) {},
                    onUpdate: (p0) {},
                    onReorder: (p0, p1) {},
                  );
                }

                return const Center(
                    child: Text('This shopping list contains no list items.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
