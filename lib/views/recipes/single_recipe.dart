import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/item_model.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';
import 'package:listeverywhere_app/services/lists_service.dart';
import 'package:listeverywhere_app/services/recipes_service.dart';
import 'package:listeverywhere_app/widgets/item_dialog.dart';
import 'package:listeverywhere_app/widgets/recipes/recipe_item_list.dart';
import 'package:listeverywhere_app/widgets/recipes/recipe_step_list.dart';
import 'package:listeverywhere_app/widgets/reusable_button.dart';
import 'package:listeverywhere_app/widgets/text_field_dialog.dart';

/// Provides the view for a single recipe object from the given [recipeId]
class SingleRecipeView extends StatefulWidget {
  const SingleRecipeView({super.key, required this.recipeInit});

  /// Recipe ID to load
  final RecipeViewModel recipeInit;

  @override
  State<StatefulWidget> createState() {
    return SingleRecipeViewState();
  }
}

class SingleRecipeViewState extends State<SingleRecipeView> {
  /// instance of RecipesService
  final recipesService = RecipesService();

  /// instance of ListsService
  final listsService = ListsService();

  late bool edit;

  @override
  void initState() {
    super.initState();
    edit = widget.recipeInit.edit;
  }

  /// Returns a RecipeModel object for the recipe id given
  Future<RecipeModel> getRecipe() async {
    // use recipes service to get recipe
    var recipe = await recipesService.getRecipeById(widget.recipeInit.recipeId);

    return recipe;
  }

  /// Returns a ListView containing numbered entries for each item in [items]
  ListView buildList(List<String> items) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            // create number index Text at start of ListTile
            leading: Text(
              '${index + 1}.',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            title: Text(items[index]),
          ),
        );
      },
    );
  }

  Future addRecipeItem(RecipeItemModel item) async {
    await recipesService.addRecipeItem(item).then(
      (value) {
        Navigator.pop(context);
        setState(() {});
      },
    );
  }

  Future deleteRecipeItem(int recipeItemId) async {
    await recipesService.deleteRecipeItem(recipeItemId).then((value) {
      setState(() {});
    });
  }

  Future updateRecipeItem(RecipeItemModel item) async {
    await recipesService.updateRecipeItem(item).then(
      (value) {
        Navigator.pop(context);
        setState(() {});
      },
    );
  }

  Future addRecipeStep(RecipeStepModel step) async {
    await recipesService.addRecipeStep(step).then((value) {
      Navigator.pop(context);
      setState(() {});
    });
  }

  Future deleteRecipeStep(int recipeStepId) async {
    await recipesService.deleteRecipeStep(recipeStepId).then((value) {
      setState(() {});
    });
  }

  Future updateRecipeStep(RecipeStepModel updated) async {
    await recipesService.updateRecipeStep(updated).then((value) {
      Navigator.pop(context);
      setState(() {});
    });
  }

  void showRecipeItemDialog(
    BuildContext context,
    RecipeItemModel? original,
    Function(RecipeItemModel) onSubmit,
    String alertText,
    String submitText,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return RecipeItemDialog(
          originalItem: original,
          onSubmit: onSubmit,
          alertText: alertText,
          submitText: submitText,
          parentContext: context,
          recipeId: widget.recipeInit.recipeId,
          listsService: listsService,
        );
      },
    );
  }

  void showRecipeStepDialog(
    BuildContext context,
    RecipeStepModel? original,
    Function(RecipeStepModel) onSubmit,
    String alertText,
    String submitText,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return TextFieldDialog(
          initialText: original != null ? original.stepDescription : '',
          alertText: alertText,
          formHint: 'Step Description',
          submitText: submitText,
          onSubmit: (stepDescription) {
            if (original != null) {
              original.stepDescription = stepDescription;

              onSubmit(original);
            } else {
              var step = RecipeStepModel(
                recipeStepId: -1,
                stepDescription: stepDescription,
                recipeId: widget.recipeInit.recipeId,
              );

              onSubmit(step);
            }
          },
        );
      },
    );
  }

  Widget? buildMergeButton() {
    return Center(
      child: ReusableButton(
        padding: const EdgeInsets.all(16.0),
        color: Colors.blue,
        textColor: Colors.white,
        onTap: () async {
          print('Merge with list ${widget.recipeInit.listId}');
          await listsService
              .mergeListWithRecipe(
                  widget.recipeInit.listId!, widget.recipeInit.recipeId)
              .then((value) {
            // successfully merged recipe with list
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Success'),
                  content: const Text('Successfully merged list with recipe!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.popUntil(
                          context, ModalRoute.withName('/recipes')),
                      child: const Text('Back to Explore'),
                    ),
                  ],
                );
              },
            );
          }).onError((error, stackTrace) {
            // failed to do the recipe and list merge
            showDialog(
              context: context,
              builder: (context) {
                print(error);
                return AlertDialog(
                  title: const Text('Error'),
                  content:
                      const Text('Failed to merge the recipe with the list.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'))
                  ],
                );
              },
            );
          });
        },
        text: 'Merge with List',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viewing Recipe'),
      ),
      body: FutureBuilder(
        // when getRecipe returns recipe model, build view
        future: getRecipe(),
        builder: (context, snapshot) {
          // check if data is available
          if (snapshot.hasData) {
            // data is received
            RecipeModel recipe = snapshot.data!;
            // return scrollable view
            return Column(
              children: [
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  recipe.recipeName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 20),
                                Flexible(
                                  child: Text(
                                    recipe.recipeDescription,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text.rich(
                                  TextSpan(
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                      children: [
                                        const TextSpan(
                                            text: 'Cook Time: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '${recipe.cookTime} minutes'),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Ingredients:',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500)),
                              if (edit)
                                ElevatedButton(
                                  onPressed: () {
                                    print('add recipe item');
                                    showRecipeItemDialog(
                                        context,
                                        null,
                                        addRecipeItem,
                                        'Add new recipe item',
                                        'Submit');
                                  },
                                  child: const Text('Add Ingredient'),
                                ),
                            ],
                          ),
                          // build list of recipe items
                          if (recipe.recipeItems != null)
                            RecipeItemList(
                              edit: edit,
                              items: recipe.recipeItems!,
                              deleteCallback: deleteRecipeItem,
                              updateCallback: (item) {
                                print(
                                    'updating recipe item ${recipe.recipeId}');
                                showRecipeItemDialog(
                                    context,
                                    item,
                                    updateRecipeItem,
                                    'Update recipe item',
                                    'Update');
                              },
                            ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Steps:',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500)),
                              if (edit)
                                ElevatedButton(
                                  onPressed: () {
                                    print('add recipe step');
                                    showRecipeStepDialog(
                                        context,
                                        null,
                                        addRecipeStep,
                                        'Add recipe step',
                                        'Submit');
                                  },
                                  child: const Text('Add Step'),
                                ),
                            ],
                          ),
                          // build list of recipe steps
                          if (recipe.recipeSteps != null)
                            RecipeStepList(
                              edit: edit,
                              steps: recipe.recipeSteps!,
                              deleteCallback: (id) {
                                print('deleting recipe step id $id');
                                deleteRecipeStep(id);
                              },
                              updateCallback: (step) {
                                print(
                                    'updating recipe step id ${step.recipeStepId}');
                                showRecipeStepDialog(
                                    context,
                                    step,
                                    updateRecipeStep,
                                    'Updating recipe step',
                                    'Update');
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.recipeInit.listId != null)
                  Expanded(
                      child: Container(
                    child: buildMergeButton(),
                  )),
              ],
            );
          } else {
            // recipe is not loaded yet, show spinner
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
