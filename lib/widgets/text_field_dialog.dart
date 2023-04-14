import 'package:flutter/material.dart';
import 'package:listeverywhere_app/widgets/reusable_button.dart';
import 'package:listeverywhere_app/widgets/reusable_field.dart';

class TextFieldDialog extends StatefulWidget {
  const TextFieldDialog({
    super.key,
    required this.alertText,
    required this.formHint,
    required this.submitText,
    this.initialText,
    required this.onSubmit,
    this.maxLength = 64,
    this.minLength = 1,
  });

  final String alertText;
  final String formHint;
  final String submitText;
  final String? initialText;
  final Function(String) onSubmit;
  final int maxLength;
  final int minLength;

  @override
  State<StatefulWidget> createState() {
    return TextFieldDialogState();
  }
}

class TextFieldDialogState extends State<TextFieldDialog> {
  TextEditingController formField = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    formField.text = widget.initialText ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.alertText),
      content: Form(
        key: _formKey,
        child: ReusableFormField(
            controller: formField,
            hint: widget.formHint,
            maxLength: widget.maxLength,
            minLength: widget.minLength),
      ),
      actions: [
        SizedBox(
          width: 100,
          height: 50,
          child: ReusableButton(
            padding: const EdgeInsets.all(4.0),
            text: 'Cancel',
            onTap: () {
              // exit dialog, no action
              Navigator.pop(context);
            },
          ),
        ),
        SizedBox(
          width: 100,
          height: 50,
          child: ReusableButton(
            padding: const EdgeInsets.all(4.0),
            text: widget.submitText,
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                widget.onSubmit(formField.text);
              }
            },
          ),
        )
      ],
    );
  }
}
