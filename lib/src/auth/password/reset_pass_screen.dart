import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/common_auth_layout.dart';
import 'package:mastermind_together/src/auth/mobile_aware_layout.dart';
import 'package:mastermind_together/src/auth/password/password_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_loading_button.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

class ResetPassScreen extends GetView<PasswordController> {
  const ResetPassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MobileAwareLayout(
      child: CommonAuthLayout(
        form: controller.isAuthenticated() ? ResetPasswordForm(controller) : const ExpiredUrlWidget(),
      ),
    );
  }
}

class ResetPasswordForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final PasswordController controller;

  ResetPasswordForm(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 406),
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) {
            if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
              if (_formKey.currentState?.validate() ?? false) {}
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Reset your password", style: welcomeTextStyle),
              xHalfSpace,
              Text(
                "Create a new password to secure your account. Make sure to pick a strong password that you haven't used elsewhere.",
                style: subtitleTextStyle,
              ),
              xxxSpace,
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextFormField(
                      controller: controller.newPasswordController,
                      label: 'New Password',
                      hintText: 'Enter your new password',
                      obscureText: true,
                      validator: FormValidators.validatePassword,
                    ),
                    xxSpace,
                    CustomTextFormField(
                      controller: controller.confirmPasswordController,
                      label: 'Confirm Password',
                      hintText: 'Confirm your new password',
                      obscureText: true,
                      validator: (value) {
                        return FormValidators.validateConfirmPassword(value, controller.confirmPasswordController.text);
                      },
                    ),
                    xxSpace,
                    Obx(() {
                      if (controller.isLoading.value) {
                        return CustomLoadingButton(
                          labelTextStyle: buttonTextStyle,
                          backgroundColor: buttonBackgroundColor,
                          onPressed: _validateAndReset,
                        );
                      } else {
                        return CustomButton(
                          label: 'Reset Password',
                          labelTextStyle: buttonTextStyle,
                          backgroundColor: buttonBackgroundColor,
                          onPressed: _validateAndReset,
                        );
                      }
                    }),
                    xxxSpace,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _validateAndReset() async {
    if (_formKey.currentState!.validate()) {
      await controller.updatePassword();
    }
  }
}

class ExpiredUrlWidget extends StatelessWidget {
  const ExpiredUrlWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("The reset password URL has expired. Please reset your password again.", style: subtitleTextStyle),
        xxSpace,
        CustomButton(
          label: 'Go Back to Forgot Password',
          labelTextStyle: buttonTextStyle,
          backgroundColor: buttonBackgroundColor,
          onPressed: () => Get.toNamed(Routes.forgotPass),
        )
      ],
    );
  }
}
