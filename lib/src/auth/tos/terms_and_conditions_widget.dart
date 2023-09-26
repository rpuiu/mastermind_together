import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/checkbox/checkbox.dart';

class TermsAndConditionsWidget extends GetView {
  final RxBool isChecked = false.obs;

  TermsAndConditionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          CustomCheckbox(
            value: isChecked.value,
            onChanged: (value) {
              isChecked.value = value!;
            },
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: bodyRegular,
                children: <TextSpan>[
                  const TextSpan(text: 'By checking this box, you agree to our ', style: bodyRegular),
                  TextSpan(
                    text: 'Terms of Service',
                    style: linkTextStyle.copyWith(fontWeight: FontWeight.w500),
                    recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(Routes.termsOfService),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: linkTextStyle.copyWith(fontWeight: FontWeight.w500),
                    recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(Routes.privacyPolicy),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
