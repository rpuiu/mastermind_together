import 'package:flutter/material.dart';
import 'package:mastermind_together/src/groups/widgets/edit_modal_widget.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/edit_button.dart';

class ConditionalEditButton extends StatelessWidget {
  final bool condition;
  final String title;
  final String label;
  final String hintText;
  final String initialValue;
  final Function(String) onSave;

  const ConditionalEditButton({
    required this.condition,
    required this.title,
    required this.label,
    required this.hintText,
    required this.initialValue,
    required this.onSave,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return condition
        ? EditBtn(
            onPressed: () => EditModal.show(
              context: context,
              title: title,
              label: label,
              hintText: hintText,
              initialValue: initialValue,
              onSave: onSave,
            ),
          )
        : Container();
  }
}
