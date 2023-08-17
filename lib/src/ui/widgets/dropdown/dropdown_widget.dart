import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class CustomDropDown extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? label;
  final String? Function(String?)? validator;

  const CustomDropDown({
    Key? key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.label,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      borderRadius: borderRadius,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: labelText,
        fillColor: categoryBgColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      value: items.contains(selectedValue) ? selectedValue : null,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: fontSize),
            child: Text(value, style: bodyRegular),
          ),
        );
      }).toList(),
      validator: validator,
      style: body,
      dropdownColor: Theme.of(context).colorScheme.surfaceVariant,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: bodyButtonInactiveTextColor),
    );
  }
}
