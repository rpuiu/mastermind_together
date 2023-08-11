import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class DrawerButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback onTap;

  const DrawerButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: fontSize / 2, vertical: 0),
      title: Row(
        children: [
          icon,
          const SizedBox(width: fontSize),
          Flexible(
              child: Text(
            text,
            style: menuBtnTextRegular,
            overflow: TextOverflow.ellipsis,
          )),
        ],
      ),
      onTap: onTap,
    );
  }
}
