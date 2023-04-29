import 'package:flutter/material.dart';
import 'package:listeverywhere_app/constants.dart';
import 'package:listeverywhere_app/models/search_model.dart';
import 'package:listeverywhere_app/widgets/bottom_navbar.dart';
import 'package:listeverywhere_app/widgets/reusable_field.dart';

/// Displays the search page for searching recipes by name
class SearchRecipesView extends StatefulWidget {
  const SearchRecipesView({super.key});

  @override
  State<StatefulWidget> createState() {
    return SearchRecipesViewState();
  }
}

/// State for the search recipes view
class SearchRecipesViewState extends State<SearchRecipesView> {
  /// Form Key
  final _formKey = GlobalKey<FormState>();

  /// Search term
  TextEditingController search = TextEditingController();

  /// Currently selected search type
  String searchType = searchTypes[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Recipes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Search recipes by name',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableFormField(
                    controller: search,
                    hint: 'Recipe name',
                    minLength: 3,
                    maxLength: 50,
                  ),
                  DropdownButton<String>(
                    value: searchType,
                    items: searchTypes
                        .map<DropdownMenuItem<String>>(
                            (e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        // update dropdown with new value
                        searchType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // validate form
                      if (_formKey.currentState!.validate()) {
                        // form is valid
                        _formKey.currentState?.save();
                        print(
                            'Searching for ${search.text} with type $searchType');
                        // create search model with information
                        SearchModel searchModel = SearchModel(
                          search: search.text,
                          searchType: searchType,
                        );

                        Navigator.pushNamed(
                          context,
                          '/recipes/search/results',
                          arguments: searchModel,
                        );
                      }
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          BottomNavBar(currentIndex: 2, parentContext: context),
    );
  }
}
