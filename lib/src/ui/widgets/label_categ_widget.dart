import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/util/color_util.dart';

class LabelCategoryWidget extends StatelessWidget {
  final String label;

  const LabelCategoryWidget({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(color: getCategoryColor(label)),
      child: Text(label, style: labelText),
    );
  }
}
