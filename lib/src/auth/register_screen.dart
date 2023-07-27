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
import 'package:mastermind_together/src/ui/widgets/text_field.dart';

class RegisterScreen extends GetView<AuthController> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Logo(),
                  const SizedBox(height: 2 * fontSize),
                  const Text('Create free account', style: h3),
                  const SizedBox(height: 2 * fontSize),
                  CustomTextField(
                    controller: usernameController,
                    label: 'Username',
                    hintText: "What username would you like to use?",
                  ),
                  const SizedBox(height: 2 * fontSize),
                  CustomTextField(
                    controller: emailController,
                    label: 'Email',
                    hintText: "What is your email?",
                  ),
                  const SizedBox(height: 2 * fontSize),
                  CustomTextField(
                    controller: passwordController,
                    label: 'Password',
                    hintText: "What is your password?",
                    obscureText: true,
                  ),
                  const SizedBox(height: 2 * fontSize),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Change this as per your requirement
                    children: [
                      TosCheckboxWidget(),
                      const SizedBox(height: 2 * fontSize),
                      CustomButton(
                        onPressed: () => controller.register(usernameController.text, emailController.text, passwordController.text),
                        child: const Text('Create Account'),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
