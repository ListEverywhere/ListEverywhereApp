import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/recipe_model.dart';

/// ListView containing numbered entries for each recipe step in [steps]
class RecipeStepList extends StatelessWidget {
  const RecipeStepList({
    super.key,
    required this.steps,
    required this.deleteCallback,
    required this.updateCallback,
    this.edit = true,
  });

  final List<RecipeStepModel> steps;
  final Function(int) deleteCallback;
  final Function(RecipeStepModel) updateCallback;
  final bool edit;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: steps.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            // create number index Text at start of ListTile
            leading: Text(
              '${index + 1}.',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            title: Text(steps[index].stepDescription),
            trailing: edit
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          // update step
                          updateCallback(steps[index]);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          // delete step
                          deleteCallback(steps[index].recipeStepId);
                        },
                        icon: const Icon(Icons.delete_forever),
                      ),
                    ],
                  )
                : null,
          ),
        );
      },
    );
  }
}
