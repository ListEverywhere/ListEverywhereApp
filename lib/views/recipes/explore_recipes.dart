import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:listeverywhere_app/widgets/bottom_navbar.dart';
import 'package:listeverywhere_app/widgets/explore_card.dart';

class ExploreRecipes extends StatelessWidget {
  const ExploreRecipes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Recipes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Flexible(
              child: Text(
                'Explore ListEverywhere\'s catalog of recipes and take your list to the next level by matching it to a recipe!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22.0),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ExploreCard(
                    cardText: 'Recipe Categories',
                    onTap: () {
                      Navigator.pushNamed(context, '/recipes/categories');
                    },
                    color: Colors.amber,
                    fontColor: Colors.black,
                    cardIcon: FontAwesomeIcons.layerGroup,
                  ),
                  ExploreCard(
                    cardText: 'Search Recipes',
                    onTap: () {
                      Navigator.pushNamed(context, '/recipes/search');
                    },
                    color: Colors.green,
                    fontColor: Colors.white,
                    cardIcon: FontAwesomeIcons.magnifyingGlass,
                  ),
                  ExploreCard(
                    cardText: 'Match List to Recipe',
                    onTap: () {},
                    color: Colors.deepPurple,
                    fontColor: Colors.white,
                    cardIcon: FontAwesomeIcons.listCheck,
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
