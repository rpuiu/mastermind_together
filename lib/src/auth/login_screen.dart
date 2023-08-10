import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/link_text.dart';
import 'package:mastermind_together/src/ui/widgets/logo.dart';
import 'package:mastermind_together/src/ui/widgets/text_field.dart';

class LoginScreen extends GetView<AuthController> {
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController(text: 'ui@io.com');
  final TextEditingController passwordController = TextEditingController(text: 'Abcd1234'); //TODO REMOVE

  LoginScreen({super.key});

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
                  const Text('Login to your account', style: h3),
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
                      CustomButton(
                        onPressed: () => controller.login(emailController.text, passwordController.text),
                        child: const Text('Log In'),
                      ),
                      const SizedBox(height: 2 * fontSize),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          const SizedBox(width: fontSize / 2),
                          LinkText(textValue: 'Register', callback: () => Get.toNamed(Routes.register)),
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
