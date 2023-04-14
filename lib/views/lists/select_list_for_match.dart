import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/models/list_model.dart';
import 'package:listeverywhere_app/services/lists_service.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/lists/shopping_lists_list_view.dart';

class SelectListForMatchView extends StatefulWidget {
  const SelectListForMatchView({super.key});

  @override
  State<StatefulWidget> createState() {
    return SelectListForMatchViewState();
  }
}

class SelectListForMatchViewState extends State<SelectListForMatchView> {
  ListsService listsService = ListsService();
  UserService userService = UserService();

  Future<List<ListModel>> getUserLists() async {
    var user = await userService.getUserFromToken();

    var lists = await listsService.getUserLists(
      user.id!,
      noItems: false,
      noCustomItems: true,
    );

    return lists;
  }

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
                    return ShoppingListsListView(
                      onUpdate: (p0) {},
                      onDelete: (p0) {},
                      onTap: (p0) {
                        print('Selected list ${p0.listId}');
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
                      },
                      data: data,
                      enableActions: false,
                    );
                  }

                  return const Center(
                      child: Text('You do not have any Shopping Lists.'));
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
