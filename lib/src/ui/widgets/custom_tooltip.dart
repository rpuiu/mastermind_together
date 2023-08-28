import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class CustomTooltip extends StatelessWidget {
  final String message;
  final Widget child;

  const CustomTooltip({
    Key? key,
    required this.message,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      decoration: BoxDecoration(
        color: drawerBgColor,
        borderRadius: borderRadius,
      ),
      richMessage: WidgetSpan(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: goalCardWidth),
          child: Padding(
            padding: const EdgeInsets.all(fontSize / 2),
            child: Text(message, style: labelText.copyWith(color: whiteColor)),
          ),
        ),
      ),
      child: child,
    );
  }
}
