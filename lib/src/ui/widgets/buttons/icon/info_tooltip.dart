import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/ui/theme/app_icons.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class InfoTooltip extends StatelessWidget {
  final String title;
  final String content;

  const InfoTooltip({Key? key, required this.title, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AppIcons.getIcon('info', IconState.defaultState),
      hoverColor: Colors.transparent,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title, style: bodyMedium),
            content: Text(content, style: bodyRegular),
            actions: [
              TextButton(
                child: const Text("Got it!"),
                onPressed: () => Get.back(),
              ),
            ],
            insetPadding: EdgeInsets.symmetric(horizontal: (MediaQuery.of(context).size.width - 450) / 2),
          ),
        );
      },
    );
  }
}
