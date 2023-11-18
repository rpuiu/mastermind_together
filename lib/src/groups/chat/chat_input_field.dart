import 'package:flutter/material.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSendPressed;
  final FocusNode focusNode;

  final bool enabled;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSendPressed,
    required this.focusNode,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(fontSize),
      padding: const EdgeInsets.symmetric(horizontal: fontSize),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        enabled: enabled,
        focusNode: focusNode,
        controller: controller,
        onSubmitted: (_) {
          onSendPressed();
          focusNode.requestFocus(); // Request focus back after submitting
        },
        decoration: InputDecoration(
          hintText: 'Type a message...',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.all(fontSize),
          suffixIcon: IconButton(
            hoverColor: Colors.transparent,
            padding: EdgeInsets.zero,
            icon: AppIcons.getIcon('send', IconState.hoverState),
            onPressed: () {
              onSendPressed();
              focusNode.requestFocus(); // Request focus back after pressing the button
            },
          ),
        ),
      ),
    );
  }
}
