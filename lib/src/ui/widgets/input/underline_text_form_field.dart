import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

class CustomUnderlineTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;

  final String emptyValidationMsg;

  const CustomUnderlineTextField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.emptyValidationMsg,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: formHintTextStyle,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: hoverMenuIconColor, width: 2.0),
        ),
      ),
      validator: (value) => FormValidators.validateEmpty(value, emptyValidationMsg),
    );
  }
}

class CustomEditTextField extends StatelessWidget {
  const CustomEditTextField({
    super.key,
    required this.editController,
    this.onEditingComplete,
  });

  final VoidCallback? onEditingComplete;
  final TextEditingController editController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 3,
      minLines: 1,
      controller: editController,
      onEditingComplete: onEditingComplete,
      decoration: const InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: hoverMenuIconColor, width: 2.0),
        ),
      ),
    );
  }
}
