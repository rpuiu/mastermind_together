import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class LinkText extends StatelessWidget {
  final String textValue;
  final GestureTapCallback callback;

  const LinkText({Key? key, required this.textValue, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: textValue,
            style: linkStyle,
            recognizer: TapGestureRecognizer()..onTap = callback,
          )
        ],
      ),
    );
  }
}
