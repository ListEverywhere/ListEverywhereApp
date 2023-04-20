import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

/// A text field for a form control
class ReusableFormField extends StatelessWidget {
  const ReusableFormField({
    super.key,
    required this.controller,
    required this.hint,
    this.isPassword = false,
    this.minLength = 1,
    this.maxLength = 64,
    this.keyboardType = TextInputType.text,
    this.onlyNumbers = false,
  });

  /// Stores the form field text
  final TextEditingController controller;

  /// Text displayed when field is empty
  final String hint;

  /// Hides field characters
  final bool isPassword;

  /// Minimum field length
  final int minLength;

  /// Maximum field length
  final int maxLength;

  final TextInputType keyboardType;

  final bool onlyNumbers;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters:
          onlyNumbers ? [FilteringTextInputFormatter.digitsOnly] : [],
      keyboardType: keyboardType,
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      decoration: InputDecoration(hintText: hint),
      controller: controller,
      validator: (value) {
        // check constraints for length and if empty
        if (value == null || value.isEmpty) {
          return "$hint cannot be blank.";
        } else if (value.length < minLength || value.length > maxLength) {
          return "$hint must be between $minLength to $maxLength characters.";
        }
        return null;
      },
    );
  }
}

/// A single form field containing a date picker
class ReusableFormDateField extends StatelessWidget {
  const ReusableFormDateField(
      {super.key,
      required this.controller,
      required this.hint,
      this.minAge = 13});

  /// Stores the date text
  final TextEditingController controller;

  final int minAge;

  /// Text displayed when field is blank
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.datetime,
      readOnly: true,
      onTap: () async {
        // display date picker when clicked
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
        // validate constraints
        if (value == null || value.isEmpty) {
          return '$hint cannot be blank.';
        }
        int valueYear = DateTime.parse(value).year;
        if (DateTime.now().year - valueYear < minAge) {
          return 'You must be $minAge years or older to register';
        }
        return null;
      },
    );
  }
}
