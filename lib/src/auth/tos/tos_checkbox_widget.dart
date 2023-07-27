import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/checkbox/checkbox.dart';

class TosCheckboxWidget extends StatelessWidget {
  final RxBool isChecked = false.obs;

  TosCheckboxWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(() => CustomCheckbox(
              value: isChecked.value,
              onChanged: (value) => isChecked.value = value!,
            )),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: body,
              children: <TextSpan>[
                const TextSpan(text: 'By checking this box, you agree to our '),
                TextSpan(
                  text: 'Terms of Service',
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(Routes.termsOfService),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(Routes.privacyPolicy),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
