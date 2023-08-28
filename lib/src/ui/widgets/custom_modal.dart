import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class CustomModal extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final List<Widget> actions;

  const CustomModal({
    Key? key,
    required this.title,
    required this.children,
    required this.actions,
  }) : super(key: key);

  static void show({
    required BuildContext context,
    required String title,
    required List<Widget> children,
    required List<Widget> actions,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          child: CustomModal(title: title, actions: actions, children: children),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(1.5 * fontSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: headingText),
                xSpace,
                ...children,
                xSpace,
                ...actions,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
