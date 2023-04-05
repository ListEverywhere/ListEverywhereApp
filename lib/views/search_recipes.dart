import 'package:flutter/material.dart';
import 'package:listeverywhere_app/constants.dart';
import 'package:listeverywhere_app/models/search_model.dart';
import 'package:listeverywhere_app/views/bottom_navbar.dart';
import 'package:listeverywhere_app/widgets/reusable_field.dart';

class SearchRecipesView extends StatefulWidget {
  const SearchRecipesView({super.key});

  @override
  State<StatefulWidget> createState() {
    return SearchRecipesViewState();
  }
}

class SearchRecipesViewState extends State<SearchRecipesView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController search = TextEditingController();
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
                  ReusableFormField(controller: search, hint: 'Recipe name'),
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
                        searchType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        print(
                            'Searching for ${search.text} with type $searchType');
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
