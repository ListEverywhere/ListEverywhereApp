import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/services/lists_service.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/lists/shopping_lists_list_view.dart';
import 'package:listeverywhere_app/widgets/recipes/merge_dialog.dart';

/// Displays user's shopping lists to select one for recipe matching
class SelectListForMatchView extends StatefulWidget {
  const SelectListForMatchView({super.key, this.recipeId});

  /// Value is set if user clicked 'Merge with List' on a recipe
  final int? recipeId;

  @override
  State<StatefulWidget> createState() {
    return SelectListForMatchViewState();
  }
}

/// State for the shopping list select view
class SelectListForMatchViewState extends State<SelectListForMatchView> {
  ListsService listsService = ListsService();
  UserService userService = UserService();

  /// Returns list of user's shopping lists
  Future<List<ListModel>> getUserLists() async {
    var user = await userService.getUserFromToken();

    // get user lists with no custom items
    var lists = await listsService.getUserLists(
      user.id!,
      noItems: widget.recipeId != null,
      noCustomItems: true,
    );

    return lists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.recipeId != null
              ? 'Merge Recipe with List'
              : 'Recipe Search by List Items')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: Center(
                  child: Text(
                'Select a Shopping List',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              )),
            ),
            Expanded(
              flex: 4,
              child: FutureBuilder<List<ListModel>>(
                future: getUserLists(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!;

                    if (data.isNotEmpty) {
                      // user has lists, display listview
                      return ShoppingListsListView(
                        onUpdate: (p0) {},
                        onDelete: (p0) {},
                        onTap: (p0) async {
                          // user selected a list
                          print('Selected list ${p0.listId}');

                          // check for if user is going through recipe matching
                          if (widget.recipeId != null) {
                            // user started from recipe and clicked 'Merge with List'
                            print(
                                'merging list with recipe id ${widget.recipeId}');
                            await listsService
                                .mergeListWithRecipe(
                                    p0.listId, widget.recipeId!)
                                .then((value) {
                              // successfully merged recipe with list
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return RecipeMergeDialog(
                                      parentContext: context, success: true);
                                },
                              );
                            }).onError((error, stackTrace) {
                              // failed to do the recipe and list merge
                              showDialog(
                                context: context,
                                builder: (context) {
                                  print(error);
                                  return RecipeMergeDialog(
                                      parentContext: context, success: true);
                                },
                              );
                            });
                          } else {
                            // user originally clicked on recipe match through explore tab
                            print('moving on with search by list items');
                            // map each item as a list item
                            var items = p0.listItems!.map(
                              (e) {
                                return e as ListItemModel;
                              },
                            ).toList();
                            Navigator.pushNamed(
                                context, '/recipes/list-select/item-select',
                                arguments: ListMatchModel(
                                  listItems: items,
                                  listId: p0.listId,
                                ));
                          }
                        },
                        data: data,
                        enableActions: false,
                      );
                    }
                    // user has no lists
                    return const Center(
                        child: Text('You do not have any Shopping Lists.'));
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
