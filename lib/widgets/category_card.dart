import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/category_model.dart';

/// Displays a recipe category card
class CategoryCard extends StatelessWidget {
  /// Recipe category
  final CategoryModel category;

  /// Card color
  final Color color;

  /// Callback for tapping
  final Function(int) onTap;

  const CategoryCard({
    super.key,
    required this.category,
    this.color = Colors.teal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.0,
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: color,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () {
            onTap(category.categoryId);
          },
          child: Center(
            child: Text(
              category.categoryName,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
