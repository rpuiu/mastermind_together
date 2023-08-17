import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  final bool readOnly;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? minLines;  // Added this
  final int? maxLines;  // Added this

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.readOnly = false,
    this.obscureText = false,
    required this.label,
    this.validator,
    this.onChanged,
    this.onTap,
    this.keyboardType,
    this.maxLength,
    this.minLines = 1,  // Defaulting to 1 line
    this.maxLines,     // Null by default, meaning it can expand indefinitely based on user input.
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLength: maxLength,
      minLines: minLines, // Added this
      maxLines: maxLines, // Added this
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        labelText: label,
        labelStyle: Theme.of(context).textTheme.labelSmall,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.labelMedium,
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 0.50, color: Theme.of(context).colorScheme.primary),
          gapPadding: 0,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }
}
