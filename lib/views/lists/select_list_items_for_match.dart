import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/widgets/fatsecret_badge.dart';
import 'package:listeverywhere_app/widgets/lists/list_items_list_view.dart';

class SelectListItemsForMatchView extends StatefulWidget {
  const SelectListItemsForMatchView({super.key, required this.listItemsInit});

  final ListMatchModel listItemsInit;

  @override
  State<StatefulWidget> createState() {
    return SelectListItemsForMatchViewState();
  }
}

class SelectListItemsForMatchViewState
    extends State<SelectListItemsForMatchView> {
  int selectedItemCount = 0;

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
                if (widget.listItemsInit.listItems.isNotEmpty) {
                  return ListItemsListView(
                    items: widget.listItemsInit.listItems,
                    enableActions: false,
                    onChecked: (value, item) {
                      print(value);
                      if (value!) {
                        selectedItemCount++;
                      } else {
                        selectedItemCount--;
                      }
                      setState(() {});
                    },
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
          Expanded(
            child: Center(
              child: ElevatedButton(
                style: const ButtonStyle(
                    maximumSize: MaterialStatePropertyAll<Size>(Size(100, 80))),
                onPressed: selectedItemCount > 0
                    ? () async {
                        print('Selected items: $selectedItemCount');
                        var selectedItems = widget.listItemsInit.listItems
                            .where((element) => element.checked)
                            .map((e) {
                              return MatchListItemModel(
                                  listItemId: e.listItemId, itemId: e.itemId);
                            })
                            .toSet()
                            .toList();

                        print(selectedItems.length);

                        List<int> ids = selectedItems.map(
                          (e) {
                            return e.listItemId;
                          },
                        ).toList();

                        Navigator.pushNamed(
                            context, '/recipes/list-select/item-select/results',
                            arguments: RecipeMatchModel(
                              listItemIds: ids,
                              listId: widget.listItemsInit.listId,
                            ));
                      }
                    : null,
                child: const Text('Continue'),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: FatSecretBadge(),
          ),
        ],
      ),
    );
  }
}
