import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class CloseBtn extends StatelessWidget {
  final VoidCallback? onPressed;

  const CloseBtn({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: AppIcons.getIcon('close', IconState.fail),
      color: buttonBackgroundColor,
      padding: const EdgeInsets.all(fontSize / 2),
      splashRadius: fontSize * 1.5,
    );
  }
}
