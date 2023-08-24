import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/widgets/fatsecret_badge.dart';
import 'package:listeverywhere_app/widgets/lists/list_items_list_view.dart';

/// Displays a list of shopping list items for the user to select for recipe match
class SelectListItemsForMatchView extends StatefulWidget {
  const SelectListItemsForMatchView({super.key, required this.listItemsInit});

  /// Contains parameters for the view
  final ListMatchModel listItemsInit;

  @override
  State<StatefulWidget> createState() {
    return SelectListItemsForMatchViewState();
  }
}

/// State for the shopping list items list view
class SelectListItemsForMatchViewState
    extends State<SelectListItemsForMatchView> {
  /// Number of items currently selected
  int selectedItemCount = 0;

  /// List items
  late List<ListItemModel> listItems;

  @override
  void initState() {
    super.initState();
    if (widget.listItemsInit.listItems.isNotEmpty) {
      // list items is not empty
      listItems = widget.listItemsInit.listItems.map(
        (e) {
          // set checked status to false in this view
          // does not affect checked status on shopping list
          e.checked = false;
          return e;
        },
      ).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Search by List Items')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
                      // list items is not empty, build listview
                      return ListItemsListView(
                        items: listItems,
                        enableActions: false,
                        onChecked: (value, item) {
                          // user checked item
                          // change selected item count based on true or false
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
                    // list has no items
                    return const Center(
                        child:
                            Text('This shopping list contains no list items.'));
                  },
                ),
              ),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        maximumSize:
                            MaterialStatePropertyAll<Size>(Size(100, 80))),
                    onPressed: selectedItemCount > 0
                        ? () async {
                            // continue to next view
                            print('Selected items: $selectedItemCount');
                            // create new list of items, removed unchecked items and duplicates
                            var selectedItems = widget.listItemsInit.listItems
                                .where((element) => element.checked)
                                .map((e) {
                                  return MatchListItemModel(
                                      listItemId: e.listItemId,
                                      itemId: e.itemId);
                                })
                                .toSet()
                                .toList();

                            // get list item ids
                            List<int> ids = selectedItems.map(
                              (e) {
                                return e.listItemId;
                              },
                            ).toList();

                            // navigate to results view
                            Navigator.pushNamed(context,
                                '/recipes/list-select/item-select/results',
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
        ),
      ),
    );
  }
}
