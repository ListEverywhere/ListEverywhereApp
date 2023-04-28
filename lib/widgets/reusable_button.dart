import 'package:flutter/material.dart';
import 'package:listeverywhere_app/constants.dart';

/// A styled InkWell button with padding
class ReusableButton extends StatelessWidget {
  const ReusableButton(
      {super.key,
      this.onTap,
      this.color = primary,
      this.padding = const EdgeInsets.all(0),
      this.border = const BorderRadius.all(Radius.circular(15.0)),
      this.text = "",
      this.textColor = Colors.black,
      this.fontSize = 12});

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

  /// Button text color
  final Color? textColor;

  /// Button text size
  final double fontSize;

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
          child: Center(
              child: Text(text,
                  style: TextStyle(color: textColor, fontSize: fontSize))),
        ),
      ),
    );
  }
}
