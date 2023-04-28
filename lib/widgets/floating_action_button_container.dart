import 'package:flutter/material.dart';
import 'package:listeverywhere_app/constants.dart';

/// Creates a container at the bottom with a [FloatingActionButton] at the center right
class FloatingActionButtonContainer extends StatelessWidget {
  const FloatingActionButtonContainer({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  /// Button icon
  final Icon icon;

  /// Callback for button tap
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: FloatingActionButton(
          backgroundColor: primary,
          onPressed: onPressed,
          child: icon,
        ),
      ),
    );
  }
}
