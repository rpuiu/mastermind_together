import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/common_auth_layout.dart';
import 'package:mastermind_together/src/auth/mobile_aware_layout.dart';
import 'package:mastermind_together/src/auth/password/forgot_pass_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_loading_button.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

class ForgotPasswordScreen extends GetView {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileAwareLayout(child: CommonAuthLayout(form: const ForgotPasswordForm()));
  }
}

class ForgotPasswordForm extends GetView<ForgotPassController> {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 406),
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) {
            if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
              controller.resetPassword();
            }
          },
          child: Obx(() {
            if (controller.successMessage.isNotEmpty) {
              return Column(
                children: [
                  Text("Check your email", style: welcomeTextStyle),
                  xHalfSpace,
                  Text(controller.successMessage.value, style: subtitleTextStyle),
                  xHalfSpace,
                  CustomButton(
                    label: 'Return to Log In',
                    labelTextStyle: buttonTextStyle,
                    backgroundColor: buttonBackgroundColor,
                    onPressed: () => Get.toNamed(Routes.login),
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Forgot your password?", style: welcomeTextStyle),
                  xHalfSpace,
                  Text(
                    "It happens to the best of us. Provide your email address and we’ll send a link for you to reset your password.",
                    style: subtitleTextStyle,
                  ),
                  xxxSpace,
                  CustomTextFormField(
                    controller: controller.emailController,
                    label: 'Email',
                    hintText: "email@address.com",
                    validator: FormValidators.validateEmail,
                  ),
                  xHalfSpace,
                  Obx(() {
                    if (controller.isLoading.value) {
                      return CustomLoadingButton(
                        labelTextStyle: buttonTextStyle,
                        backgroundColor: buttonBackgroundColor,
                        onPressed: () => controller.resetPassword(),
                      );
                    } else if (controller.successMessage.isNotEmpty) {
                      return Text(controller.successMessage.value, style: subtitleTextStyle);
                    } else {
                      return CustomButton(
                        label: 'Reset Password',
                        labelTextStyle: buttonTextStyle,
                        backgroundColor: buttonBackgroundColor,
                        onPressed: () => controller.resetPassword(),
                      );
                    }
                  }),
                  xxxSpace,
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
