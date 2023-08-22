import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/auth/common_auth_layout.dart';
import 'package:mastermind_together/src/auth/mobile_aware_layout.dart';
import 'package:mastermind_together/src/auth/tos/terms_and_conditions_widget.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/link_text.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileAwareLayout(child: CommonAuthLayout(form: RegisterForm()));
  }
}

class LeftRegisterForm extends GetView<AuthController> {
  const LeftRegisterForm({Key? key}) : super(key: key);

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
                      const SizedBox(height: 3 * fontSize),
                      SvgPicture.asset(width: 308, height: 30, 'assets/images/logo/logo-small-black.svg'),
                      const SizedBox(height: 3 * fontSize),
                      RegisterForm(),
                      const SizedBox(height: 3 * fontSize),
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

class RegisterForm extends GetView<AuthController> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TermsAndConditionsWidget termsOfService = TermsAndConditionsWidget(tenantId: controller.getTenantId());

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 406),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Craft Your Success Story', style: welcomeTextStyle),
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
              maxLines: 1,
              validator: FormValidators.validatePassword,
            ),
            const SizedBox(height: 2 * fontSize),
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
                isEnabled: termsOfService.isChecked.value,
                label: 'Create Account',
                labelTextStyle: termsOfService.isChecked.value ? buttonTextStyle : inactiveButtonTextStyle,
                backgroundColor: buttonBackgroundColor,
              ),
            ),
            const SizedBox(height: 2 * fontSize),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("Already have an account?", style: subtitleTextStyle),
                const SizedBox(width: fontSize / 2),
                LinkText(textValue: 'Sign In', callback: () => Get.toNamed(Routes.login)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
