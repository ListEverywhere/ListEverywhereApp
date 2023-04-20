import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/services/lists_service.dart';
import 'package:listeverywhere_app/widgets/fatsecret_badge.dart';
import 'package:listeverywhere_app/widgets/reusable_button.dart';
import 'package:listeverywhere_app/widgets/reusable_field.dart';

class ItemDialog extends StatefulWidget {
  final String alertText;
  final String submitText;
  final BuildContext parentContext;
  final ListsService? listsService;
  final ItemModel? originalItem;
  final Function(ItemModel) onSubmit;
  final bool hideCheckbox;
  final bool isCustom;

  const ItemDialog({
    super.key,
    required this.alertText,
    required this.submitText,
    required this.parentContext,
    this.listsService,
    this.originalItem,
    required this.onSubmit,
    this.hideCheckbox = false,
    this.isCustom = false,
  });

  @override
  State<StatefulWidget> createState() {
    return ItemDialogState();
  }
}

class ItemDialogState extends State<ItemDialog> {
  ItemModel? newItem;
  TextEditingController itemName = TextEditingController();
  late bool isCustom;
  List<ItemModel> items = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isCustom = widget.isCustom;

    newItem = widget.originalItem;
    itemName.text = newItem != null ? newItem!.itemName : '';
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: StatefulBuilder(builder: ((innerContext, setState) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: AlertDialog(
            title: Text(
              widget.alertText,
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Enter your item name, then press the search icon',
                  style: TextStyle(fontSize: 12.0),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Form(
                        key: _formKey,
                        child: ReusableFormField(
                            controller: itemName, hint: 'Item Name'),
                      ),
                    ),
                    // if custom item is selected, hide item search
                    if (!isCustom)
                      Expanded(
                        child: IconButton(
                            onPressed: () async {
                              // search icon pressed, search items
                              if (widget.listsService == null) {
                                throw Exception('listsService is required.');
                              }
                              await widget.listsService!
                                  .searchItemsByName(itemName.text)
                                  .then((value) {
                                if (value.isEmpty) {
                                } else {
                                  // update items value and set current item to first
                                  setState(() {
                                    items = value;
                                    newItem = items.first;
                                  });
                                }
                              }).onError((error, stackTrace) {
                                // display error that items failed to load
                                ScaffoldMessenger.of(innerContext)
                                    .showSnackBar(SnackBar(
                                  content: const Text('Failed to get items.'),
                                  backgroundColor: Colors.red[400],
                                ));
                              });
                            },
                            icon: const Icon(Icons.search)),
                      ),
                  ],
                ),
                // if custom item is chosen, do not show
                if (!isCustom)
                  DropdownButton<ItemModel>(
                    isExpanded: true,
                    value: newItem,
                    // map items to a list of DropdownMenuItems
                    items: items
                        .map<DropdownMenuItem<ItemModel>>(
                            (e) => DropdownMenuItem<ItemModel>(
                                  value: e,
                                  child: Text(e.itemName),
                                ))
                        .toList(),
                    onChanged: (value) {
                      // update current item to changed item
                      setState(() {
                        newItem = value;
                      });
                    },
                  ),
                // hide checkbox when updating items
                if (!widget.hideCheckbox)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isCustom,
                        onChanged: (value) {
                          setState(() {
                            isCustom = value!;
                          });
                        },
                      ),
                      const Text('I can\'t find my item'),
                    ],
                  ),
                Text(
                  // display text only if custom item is selected
                  isCustom
                      ? 'This item will be added as a custom item.\nIt cannot be used for recipe matching.'
                      : '',
                  style: const TextStyle(fontSize: 12.0),
                ),
                if (!isCustom) const FatSecretBadge(),
              ],
            ),
            actions: [
              SizedBox(
                width: 100,
                height: 50,
                child: ReusableButton(
                  textColor: Colors.white,
                  fontSize: 16,
                  padding: const EdgeInsets.all(4.0),
                  text: 'Cancel',
                  onTap: () {
                    // exit dialog, no changes
                    Navigator.pop(innerContext);
                  },
                ),
              ),
              SizedBox(
                width: 100,
                height: 50,
                child: ReusableButton(
                  textColor: Colors.white,
                  fontSize: 16,
                  padding: const EdgeInsets.all(4.0),
                  text: widget.submitText,
                  onTap: () {
                    // if originalItem is not null, item is being updated
                    if (widget.originalItem != null) {
                      // set item name for custom items
                      newItem!.itemName = itemName.text;
                      // run callback
                      widget.onSubmit(newItem!);
                    } else {
                      if (isCustom) {
                        // check if form fields are valid
                        if (_formKey.currentState!.validate()) {
                          // save the form fields
                          _formKey.currentState?.save();

                          newItem = ItemModel(itemName: itemName.text);
                        }
                      }

                      if (newItem != null) {
                        // run callback on new item
                        widget.onSubmit(newItem!);
                      } else {
                        // item is missing
                        ScaffoldMessenger.of(innerContext)
                            .showSnackBar(SnackBar(
                          content: const Text(
                              'You must pick an item or add a custom item.'),
                          backgroundColor: Colors.red[400],
                        ));
                      }
                    }
                  },
                ),
              )
            ],
          ),
        );
      })),
    );
  }
}

class CustomListItemDialog extends StatelessWidget {
  const CustomListItemDialog({
    super.key,
    required this.onSubmit,
    required this.alertText,
    required this.submitText,
    required this.parentContext,
    this.originalItem,
    required this.listId,
  });

  final Function(CustomListItemModel) onSubmit;
  final String alertText;
  final String submitText;
  final BuildContext parentContext;
  final CustomListItemModel? originalItem;
  final int listId;

  @override
  Widget build(BuildContext context) {
    return ItemDialog(
      alertText: alertText,
      submitText: submitText,
      parentContext: parentContext,
      onSubmit: (item) {
        CustomListItemModel customItem;
        if (originalItem != null) {
          customItem = CustomListItemModel(
            itemName: item.itemName,
            checked: originalItem!.checked,
            position: originalItem!.position,
            listId: listId,
            customItemId: originalItem!.customItemId,
          );
        } else {
          customItem = CustomListItemModel(
              itemName: item.itemName,
              checked: false,
              position: -1,
              listId: listId,
              customItemId: -1);
        }

        onSubmit(customItem);
      },
      originalItem: originalItem,
      isCustom: true,
      hideCheckbox: true,
    );
  }
}

class ListItemDialog extends StatelessWidget {
  const ListItemDialog({
    super.key,
    required this.onSubmit,
    required this.alertText,
    required this.submitText,
    required this.parentContext,
    this.originalItem,
    required this.listId,
    required this.listsService,
  });

  final Function(ListItemModel) onSubmit;
  final String alertText;
  final String submitText;
  final BuildContext parentContext;
  final ListItemModel? originalItem;
  final int listId;
  final ListsService listsService;

  @override
  Widget build(BuildContext context) {
    return ItemDialog(
      listsService: listsService,
      alertText: alertText,
      submitText: submitText,
      parentContext: parentContext,
      onSubmit: (item) {
        ListItemModel listItem;
        if (originalItem != null) {
          listItem = ListItemModel(
            itemId: item.itemId,
            checked: originalItem!.checked,
            position: originalItem!.position,
            listItemId: originalItem!.listItemId,
            listId: listId,
          );
        } else {
          listItem = ListItemModel(
            itemId: item.itemId,
            checked: false,
            position: -1,
            listItemId: -1,
            listId: listId,
          );
        }

        onSubmit(listItem);
      },
      originalItem: originalItem,
      isCustom: false,
      hideCheckbox: true,
    );
  }
}

class RecipeItemDialog extends StatelessWidget {
  const RecipeItemDialog({
    super.key,
    required this.onSubmit,
    required this.alertText,
    required this.submitText,
    required this.parentContext,
    this.originalItem,
    required this.recipeId,
    required this.listsService,
  });

  final Function(RecipeItemModel) onSubmit;
  final String alertText;
  final String submitText;
  final BuildContext parentContext;
  final RecipeItemModel? originalItem;
  final int recipeId;
  final ListsService listsService;

  @override
  Widget build(BuildContext context) {
    return ItemDialog(
      listsService: listsService,
      alertText: alertText,
      submitText: submitText,
      parentContext: parentContext,
      onSubmit: (item) {
        RecipeItemModel recipeItem;
        if (originalItem != null) {
          recipeItem = RecipeItemModel(
            itemId: item.itemId,
            recipeItemId: originalItem!.recipeItemId,
            recipeId: recipeId,
          );
        } else {
          recipeItem = RecipeItemModel(
            itemId: item.itemId,
            recipeItemId: -1,
            recipeId: recipeId,
          );
        }

        onSubmit(recipeItem);
      },
      originalItem: originalItem,
      isCustom: false,
      hideCheckbox: true,
    );
  }
}
