import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/category_model.dart';
import 'package:listeverywhere_app/services/recipes_service.dart';
import 'package:listeverywhere_app/views/bottom_navbar.dart';
import 'package:listeverywhere_app/widgets/category_card.dart';

class RecipeCategoriesView extends StatefulWidget {
  const RecipeCategoriesView({super.key});

  @override
  State<StatefulWidget> createState() {
    return RecipeCategoriesViewState();
  }
}

class RecipeCategoriesViewState extends State<RecipeCategoriesView> {
  /// Instance of [RecipesService]
  final recipesService = RecipesService();

  Future<List<CategoryModel>> getCategories() async {
    var categories = await recipesService.getCategories();
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Categories'),
      ),
      body: FutureBuilder(
        future: getCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // categories received
            List<CategoryModel> categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CategoryCard(
                    category: categories[index],
                    onTap: (p0) {
                      print('category id $p0');
                      Navigator.pushNamed(
                          context, '/recipes/categories/category',
                          arguments: categories[index]);
                    },
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        parentContext: context,
      ),
    );
  }
}
