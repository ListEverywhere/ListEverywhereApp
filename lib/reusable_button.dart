import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  const ReusableButton(
      {super.key,
      this.onTap,
      this.color = Colors.amber,
      this.padding = const EdgeInsets.all(0),
      this.border = const BorderRadius.all(Radius.circular(15.0)),
      this.text = ""});

  final Function()? onTap;
  final Color? color;
  final EdgeInsets padding;
  final BorderRadius border;
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
