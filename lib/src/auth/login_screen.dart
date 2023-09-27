import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/common_auth_layout.dart';
import 'package:mastermind_together/src/auth/mobile_aware_layout.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_loading_button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/link_text.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';

import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileAwareLayout(child: CommonAuthLayout(form: LoginForm()));
  }
}

class LoginForm extends GetView<LoginController> {
  LoginForm({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // final TextEditingController emailController = TextEditingController(text: 'test70@yahoo.com');
  // final TextEditingController passwordController = TextEditingController(text: 'Test_1234'); //TODO REMOVE

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 406),
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) {
            if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
              controller.login(emailController.text, passwordController.text);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeWidget(),
              xHalfSpace,
              Text(
                'Today is a new day. It\'s your day. You shape it.',
                style: subtitleTextStyle,
              ),
              xxxSpace,
              CustomTextFormField(
                label: "Email",
                controller: emailController,
                hintText: "Example@email.com",
              ),
              xHalfSpace,
              CustomTextFormField(
                label: "Password",
                controller: passwordController,
                hintText: "At least 8 characters",
                obscureText: true,
                maxLines: 1,
                onFieldSubmitted: (_) {
                  controller.login(emailController.text, passwordController.text);
                },
              ),
              xHalfSpace,
              Align(
                alignment: Alignment.centerRight,
                child: Text('Forgot Password?', style: linkTextStyle), //TODO MAIN-T-49
              ),
              xHalfSpace,
              Obx(() {
                if (controller.isLoading.value) {
                  return CustomLoadingButton(
                    labelTextStyle: buttonTextStyle,
                    backgroundColor: buttonBackgroundColor,
                    onPressed: () => controller.login(emailController.text, passwordController.text),
                  );
                } else {
                  return CustomButton(
                    label: 'Sign in',
                    labelTextStyle: buttonTextStyle,
                    backgroundColor: buttonBackgroundColor,
                    onPressed: () => controller.login(emailController.text, passwordController.text),
                  );
                }
              }),
              xxxSpace,
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text("Don't you have an account?", style: subtitleTextStyle),
                  wHalfSpace,
                  LinkText(textValue: 'Sign Up', callback: () => Get.toNamed(Routes.register)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Welcome ', style: welcomeTextStyle),
          TextSpan(text: ' 👋', style: welcomeTextStyle.copyWith(fontWeight: FontWeight.w400)),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
