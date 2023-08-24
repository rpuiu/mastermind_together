import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';

class CustomCheckboxListTile extends StatelessWidget {
  final String title;
  final String tooltip;
  final bool value;
  final Function(bool?) onChanged;

  const CustomCheckboxListTile({
    Key? key,
    required this.title,
    required this.tooltip,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.only(left: 0, right: 0),
      title: Row(
        children: [
          Text(title),
          wHalfSpace,
          Tooltip(
            message: tooltip,
            child: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.onBackground,),
          ),
        ],
      ),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
