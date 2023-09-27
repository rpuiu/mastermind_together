import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';

class CustomLoadingButton extends StatelessWidget {
  final Color backgroundColor;
  final bool isEnabled;
  final VoidCallback? onPressed;

  final TextStyle labelTextStyle;

  const CustomLoadingButton({
    Key? key,
    required this.backgroundColor,
    this.isEnabled = true,
    this.onPressed,
    required this.labelTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    TextStyle mobileLabelTextStyle = labelTextStyle.copyWith(fontSize: fontSize, letterSpacing: 0.16);

    EdgeInsets buttonPadding = isMobile ? const EdgeInsets.symmetric(vertical: 14.0) : const EdgeInsets.symmetric(vertical: fontSize);

    double buttonHeightMobile = mobileLabelTextStyle.fontSize! + (2 * fontSize);
    double buttonHeightDesktop = labelTextStyle.fontSize! + (2 * fontSize);

    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(buttonPadding),
        minimumSize: MaterialStateProperty.all(Size(double.infinity, isMobile ? buttonHeightMobile : buttonHeightDesktop)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: const BorderSide(color: Colors.transparent),
          ),
        ),
      ),
      child: const CircularProgressIndicator(strokeWidth: 3.0,),
    );
  }
}
