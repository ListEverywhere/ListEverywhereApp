import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final Color color;
  final Function(int) onTap;

  const CategoryCard({
    super.key,
    required this.category,
    this.color = Colors.teal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          onTap(category.categoryId);
        },
        child: Container(
            height: 80.0,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                category.categoryName,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            )),
      ),
    );
  }
}
