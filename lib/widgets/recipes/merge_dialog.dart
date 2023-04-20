import 'package:flutter/material.dart';
import 'package:listeverywhere_app/services/lists_service.dart';

class RecipeMergeDialog extends StatelessWidget {
  const RecipeMergeDialog({
    super.key,
    required this.parentContext,
    required this.success,
  });

  final BuildContext parentContext;
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
