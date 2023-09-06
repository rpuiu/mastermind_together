import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class LimitReachedAlertDialog extends StatelessWidget {
  final String title;
  final String message;

  const LimitReachedAlertDialog({
    Key? key,
    this.title = 'Limit Reached',
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: oneColContentWidth),
      child: AlertDialog(
        title: Text(
          title,
          style: headingText,
        ),
        content: Text(
          message,
          style: bodyRegular,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text('Contact Us'),
            onPressed: () {
              Get.back();
              Get.toNamed(Routes.feedback);
            },
          ),
        ],
      ),
    );
  }
}

void showLimitReachedAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return LimitReachedAlertDialog(message: message);
    },
  );
}
