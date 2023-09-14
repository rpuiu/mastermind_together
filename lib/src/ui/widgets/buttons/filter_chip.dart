import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class CustomFilterChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final Function(bool) onSelected;
  final Color customBackgroundColor;
  final Color customSelectedColor;

  const CustomFilterChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onSelected,
    required this.customBackgroundColor,
    required this.customSelectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(category, style: bodyMedium),
      selectedColor: customSelectedColor,
      backgroundColor: customBackgroundColor,
      selected: isSelected,
      onSelected: onSelected,
      elevation: 0,
    );
  }
}
