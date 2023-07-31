import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/auth/tos/tos_checkbox_widget.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/link_text.dart';
import 'package:mastermind_together/src/ui/widgets/logo.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

class RegisterScreen extends GetView<AuthController> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController(); // Add this

  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TosCheckboxWidget termsOfService = TosCheckboxWidget();

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Logo(),
                    const SizedBox(height: 2 * fontSize),
                    const Text('Create free account', style: h3),
                    const SizedBox(height: 2 * fontSize),
                    CustomTextFormField(
                      controller: usernameController,
                      label: 'Username',
                      hintText: "What username would you like to use?",
                      validator: FormValidators.validateUsername,
                    ),
                    const SizedBox(height: 2 * fontSize),
                    CustomTextFormField(
                      controller: emailController,
                      label: 'Email',
                      hintText: "What is your email?",
                      validator: FormValidators.validateEmail,
                    ),
                    const SizedBox(height: 2 * fontSize),
                    CustomTextFormField(
                      controller: passwordController,
                      label: 'Password',
                      hintText: "What is your password?",
                      obscureText: true,
                      validator: FormValidators.validatePassword,
                    ),
                    const SizedBox(height: 2 * fontSize),
                    CustomTextFormField(
                      controller: confirmPasswordController,
                      label: 'Confirm Password',
                      hintText: "Confirm your password",
                      obscureText: true,
                      validator: (value) {
                        return FormValidators.validateConfirmPassword(value, passwordController.text);
                      },
                    ),
                    const SizedBox(height: 2 * fontSize),
                    termsOfService,
                    const SizedBox(height: 2 * fontSize),
                    Obx(
                      () => CustomButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            controller.register(usernameController.text, emailController.text, passwordController.text);
                          }
                        },
                        enabled: termsOfService.isChecked.value,
                        child: const Text('Create Account'),
                      ),
                    ),
                    const SizedBox(height: 2 * fontSize),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        const SizedBox(width: fontSize / 2),
                        LinkText(textValue: 'Sign In', callback: () => Get.toNamed(Routes.login)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
