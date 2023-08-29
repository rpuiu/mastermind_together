import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) { //TODO remove because it is already configured using the theme.
    return const CircularProgressIndicator(
      color: hoverMenuIconColor,
    );
  }
}
