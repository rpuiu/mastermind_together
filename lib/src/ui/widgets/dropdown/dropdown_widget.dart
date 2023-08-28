import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class CustomDropDown extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final Widget? icon;

  const CustomDropDown({
    Key? key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.label,
    this.validator,
    this.hint,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    EdgeInsets mobileContentPadding = const EdgeInsets.symmetric(vertical: 14.0, horizontal: fontSize);

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
        DropdownButtonFormField<String>(
          borderRadius: borderRadius,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          value: items.contains(selectedValue) ? selectedValue : null,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: bodyRegular),
            );
          }).toList(),
          validator: validator,
          decoration: InputDecoration(
            contentPadding: isMobile ? mobileContentPadding : null,
            hintText: hint,
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
          isExpanded: true,
          icon: AppIcons.getIcon('arrow-down', IconState.hoverState),
          dropdownColor: formTextFieldFillColor,
          style: bodyRegular,
        ),
      ],
    );
  }
}
