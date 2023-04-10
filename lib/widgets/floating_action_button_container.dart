import 'package:flutter/material.dart';

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
          onPressed: onPressed,
          child: icon,
        ),
      ),
    );
  }
}
