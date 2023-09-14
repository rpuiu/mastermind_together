import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? label;
  final bool readOnly;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final ValueChanged<String>? onFieldSubmitted;

  final Widget? icon;

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
    this.minLines = 1,
    this.maxLines = 1,
    this.onFieldSubmitted,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    EdgeInsets mobileContentPadding = const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Row(
            children: [
              Text(label!, style: isMobile ? mobileLabelTextStyle : formLabelTextStyle),
              if (icon != null) icon!,
            ],
          ),
        halfSpace,
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          keyboardType: keyboardType,
          maxLength: maxLength,
          minLines: minLines,
          maxLines: maxLines,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            contentPadding: isMobile ? mobileContentPadding : null,
            hintText: hintText,
            hintStyle: isMobile ? mobileLabelTextStyle.copyWith(color: textFieldHintColor) : formHintTextStyle,
            filled: true,
            fillColor: formTextFieldFillColor,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: textFieldBorderColor, width: 0.5),
              borderRadius: borderRadius,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: textFieldBorderColor, width: 0.5),
              borderRadius: borderRadius,
            ),
          ),
        ),
      ],
    );
  }
}
