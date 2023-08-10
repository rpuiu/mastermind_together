import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const CustomButton({
    Key? key,
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    this.isEnabled = true,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.transparent),
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.50,
        ),
      ),
    );
  }
}
