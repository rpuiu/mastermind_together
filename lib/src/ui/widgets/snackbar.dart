import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

showSuccessSnackBar({String title = "Success", required String message}) {
  return _getSnackBar(
    title,
    message,
    AppIcons.getIcon('success', IconState.done),
    hoverMenuTextColor,
    Colors.green.shade600,
  );
}

showInfoSnackBar({String title = 'Info', required String message}) {
  return _getSnackBar(
    title,
    message,
    AppIcons.getIcon('info', IconState.hoverState),
    hoverMenuTextColor,
    Colors.blue.shade600,
  );
}

showErrorSnackBar({String title = 'Error', required String message, bool hasActionButton = false}) {
  return _getSnackBar(
    title,
    message,
    AppIcons.getIcon('error', IconState.fail),
    hoverMenuTextColor,
    Colors.red.shade600,
    hasActionButton: hasActionButton,
  );
}

_getSnackBar(String title, String message, Widget? icon, Color backgroundColor, Color shadowColor, {bool hasActionButton = false}) {
  return Get.snackbar(
    title,
    message,
    icon: icon,
    shouldIconPulse: true,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: backgroundColor.withOpacity(0.9),
    borderRadius: 8,
    margin: const EdgeInsets.all(fontSize),
    padding: const EdgeInsets.symmetric(horizontal: 2 * fontSize, vertical: fontSize),
    colorText: Colors.white,
    duration: const Duration(seconds: 4),
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack,
    boxShadows: [BoxShadow(color: shadowColor, offset: const Offset(0.0, 2.0), blurRadius: 3.0)],
    titleText: Text(title, style: subtitleTextStyle.copyWith(fontWeight: FontWeight.w500)),
    messageText: Text(message, style: bodyRegular),
    mainButton: hasActionButton
        ? TextButton(
            onPressed: () {},
            child: const Text('Action'),
          )
        : TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
    overlayBlur: 0,
    snackStyle: SnackStyle.FLOATING,
    backgroundGradient: LinearGradient(colors: [backgroundColor, backgroundColor]),
  );
}
