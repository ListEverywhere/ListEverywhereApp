import 'package:flutter/material.dart';

/// A styled InkWell button with padding
class ReusableButton extends StatelessWidget {
  const ReusableButton(
      {super.key,
      this.onTap,
      this.color = Colors.amber,
      this.padding = const EdgeInsets.all(0),
      this.border = const BorderRadius.all(Radius.circular(15.0)),
      this.text = ""});

  /// Function to run after button click
  final Function()? onTap;

  /// Background color
  final Color? color;

  /// Button padding
  final EdgeInsets padding;

  /// Button border
  final BorderRadius border;

  /// Button text
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        color: color,
        borderRadius: border,
        //margin: const EdgeInsets.all(15.0),
        child: InkWell(
          onTap: onTap,
          child: Center(child: Text(text)),
        ),
      ),
    );
  }
}
