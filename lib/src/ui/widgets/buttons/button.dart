import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool enabled;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.enabled = true, // by default, the button is enabled
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null, // if the button is not enabled, onPressed should be null
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        backgroundColor: enabled ? Theme.of(context).colorScheme.primary : Colors.grey,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      child: child,
    );
  }
}
