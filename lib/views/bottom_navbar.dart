import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatelessWidget {
  int currentIndex;
  final pages = [
    '/lists',
    '/recipes/user',
    '/recipes/explore',
  ];
  BuildContext parentContext;

  BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.basketShopping),
          label: 'My Lists',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.listUl),
          label: 'My Recipes',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.magnifyingGlass),
          label: 'Find Recipes',
        ),
      ],
      onTap: (value) {
        Navigator.popAndPushNamed(parentContext, pages[value]);
      },
    );
  }
}

/*
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<StatefulWidget> createState() {
    return BottomNavBarState();
  }
}

class BottomNavBarState extends State<BottomNavBar> {
  final pages = [
    '/lists',
    '/recipes/user',
    '/recipes/explore',
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.basketShopping),
            label: 'My Lists',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.listUl),
            label: 'My Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.magnifyingGlass),
            label: 'Find Recipes',
          ),
        ],
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
          Navigator.pushNamed(context, pages[index]);
        },
      ),
    );
  }
}
*/