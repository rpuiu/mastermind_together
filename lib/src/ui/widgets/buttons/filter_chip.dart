import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class CustomFilterChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final Function(bool) onSelected;

  const CustomFilterChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(category, style: bodyMedium),
      selectedColor: buttonActiveBackgroundColor,
      backgroundColor: categoryBgColor,
      selected: isSelected,
      onSelected: onSelected,
      elevation: 0,
    );
  }
}
