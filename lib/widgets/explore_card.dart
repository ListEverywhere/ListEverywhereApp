import 'package:flutter/material.dart';

/// An action card for the recipe explore view
class ExploreCard extends StatelessWidget {
  /// Card text
  final String cardText;

  /// Callback for tapping
  final Function() onTap;

  /// Card color
  final Color color;

  /// Font color
  final Color fontColor;

  /// Card icon
  final IconData cardIcon;

  const ExploreCard({
    super.key,
    required this.cardText,
    required this.onTap,
    required this.color,
    required this.fontColor,
    required this.cardIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 120.0, minWidth: 400),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: color,
        borderRadius: BorderRadiusDirectional.circular(25),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cardText,
                  style: TextStyle(
                    color: fontColor,
                    fontSize: 24,
                  ),
                ),
                Icon(
                  cardIcon,
                  size: 32,
                  color: fontColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
