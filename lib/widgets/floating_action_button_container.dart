import 'package:flutter/material.dart';
import 'package:listeverywhere_app/constants.dart';

class FloatingActionButtonContainer extends StatelessWidget {
  const FloatingActionButtonContainer({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final Icon icon;
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
