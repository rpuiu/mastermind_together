import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/common_auth_layout.dart';
import 'package:mastermind_together/src/auth/mobile_aware_layout.dart';
import 'package:mastermind_together/src/auth/register_controller.dart';
import 'package:mastermind_together/src/auth/tos/terms_and_conditions_widget.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/link_text.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

import '../ui/widgets/buttons/custom_loading_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileAwareLayout(child: CommonAuthLayout(form: RegisterForm()));
  }
}

class RegisterForm extends GetView<RegisterController> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TermsAndConditionsWidget termsOfService = TermsAndConditionsWidget(tenantId: controller.getTenantId());

    return FocusScope(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 406),
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) {
            if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
              if (formKey.currentState?.validate() ?? false) {
                controller.register(usernameController.text, emailController.text, passwordController.text);
              }
            }
          },
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Craft Your Success Story', style: welcomeTextStyle),
                xxSpace,
                CustomTextFormField(
                  controller: usernameController,
                  label: 'Username',
                  hintText: "What username would you like to use?",
                  validator: FormValidators.validateUsername,
                ),
                xxSpace,
                CustomTextFormField(
                  controller: emailController,
                  label: 'Email',
                  hintText: "What is your email?",
                  validator: FormValidators.validateEmail,
                ),
                xxSpace,
                CustomTextFormField(
                  controller: passwordController,
                  label: 'Password',
                  hintText: "What is your password?",
                  obscureText: true,
                  maxLines: 1,
                  validator: FormValidators.validatePassword,
                ),
                xxSpace,
                CustomTextFormField(
                  controller: confirmPasswordController,
                  label: 'Confirm Password',
                  hintText: "Confirm your password",
                  obscureText: true,
                  maxLines: 1,
                  validator: (value) {
                    return FormValidators.validateConfirmPassword(value, passwordController.text);
                  },
                ),
                xxSpace,
                termsOfService,
                xxSpace,
                Obx(() {
                  if (controller.isLoading.value) {
                    return const CustomLoadingButton(
                      labelTextStyle: buttonTextStyle,
                      backgroundColor: buttonBackgroundColor,
                      onPressed: null,
                    );
                  } else {
                    return CustomButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          controller.register(usernameController.text, emailController.text, passwordController.text);
                        }
                      },
                      isEnabled: termsOfService.isChecked.value,
                      label: 'Create Account',
                      labelTextStyle: termsOfService.isChecked.value ? buttonTextStyle : inactiveButtonTextStyle,
                      backgroundColor: buttonBackgroundColor,
                    );
                  }
                }),
                xxSpace,
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("Already have an account?", style: subtitleTextStyle),
                    wHalfSpace,
                    LinkText(textValue: 'Sign In', callback: () => Get.toNamed(Routes.login)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
