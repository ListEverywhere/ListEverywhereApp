import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReusableFormField extends StatelessWidget {
  const ReusableFormField(
      {super.key,
      required this.controller,
      required this.hint,
      this.isPassword = false});

  final TextEditingController controller;
  final String hint;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType:
          isPassword ? TextInputType.visiblePassword : TextInputType.text,
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      decoration: InputDecoration(hintText: hint),
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Invalid';
        }
        return null;
      },
    );
  }
}

class ReusableFormDateField extends StatelessWidget {
  const ReusableFormDateField(
      {super.key, required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      onTap: () async {
        DateTime? date = await showDatePicker(
            context: context,
            initialDate: controller.text.isEmpty
                ? DateTime(2000)
                : DateTime.parse(controller.text),
            firstDate: DateTime(1900),
            lastDate: DateTime(2023));

        if (date != null) {
          var dateString = DateFormat("yyyy-MM-dd").format(date);
          print(dateString);
          controller.text = dateString;
        }
      },
      decoration: InputDecoration(hintText: hint),
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Invalid';
        }
        return null;
      },
    );
  }
}
