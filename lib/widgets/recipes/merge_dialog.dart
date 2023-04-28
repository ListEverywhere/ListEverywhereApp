import 'package:flutter/material.dart';

/// Creates the status dialog for merging recipe with list
class RecipeMergeDialog extends StatelessWidget {
  const RecipeMergeDialog({
    super.key,
    required this.parentContext,
    required this.success,
  });

  /// Parent context
  final BuildContext parentContext;

  /// If the merge was successful
  final bool success;

  @override
  Widget build(BuildContext context) {
    if (success) {
      return AlertDialog(
        title: const Text('Success'),
        content: const Text('Successfully merged list with recipe!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(
                parentContext, ModalRoute.withName('/recipes')),
            child: const Text('Back to Explore'),
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: const Text('Error'),
        content: const Text('Failed to merge the recipe with the list.'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(parentContext);
              },
              child: const Text('Close'))
        ],
      );
    }
  }
}
