import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/auth/common_auth_layout.dart';
import 'package:mastermind_together/src/auth/mobile_aware_layout.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/link_text.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileAwareLayout(child: CommonAuthLayout(form: LoginForm()));
  }
}

class LeftLoginForm extends StatelessWidget {
  const LeftLoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(2 * fontSize),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      xxxSpace,
                      SvgPicture.asset(width: 308, height: 30, 'assets/images/logo/logo-small-black.svg'),
                      xxxSpace,
                      LoginForm(),
                      xxxSpace,
                      Text(
                        '© 2023 ALL RIGHTS RESERVED MASTERMINDTOGETHER',
                        textAlign: TextAlign.center,
                        style: copyrightTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LoginForm extends GetView<AuthController> {
  LoginForm({Key? key}) : super(key: key);

  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController(text: 'rp@rp.com');
  final TextEditingController passwordController = TextEditingController(text: 'Abcd1234'); //TODO REMOVE

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 406),
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
            hintText: "At least 6 characters",
            obscureText: true,
            maxLines: 1,
          ),
          xHalfSpace,
          Align(
            alignment: Alignment.centerRight,
            child: Text('Forgot Password?', style: linkTextStyle), //TODO MAIN-T-49
          ),
          xHalfSpace,
          CustomButton(
            label: 'Sign in',
            labelTextStyle: buttonTextStyle,
            backgroundColor: buttonBackgroundColor,
            onPressed: () => controller.login(emailController.text, passwordController.text),
          ),
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
