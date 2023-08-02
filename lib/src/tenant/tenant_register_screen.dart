import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/tos/terms_and_conditions_widget.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/tenant/tenant_controller.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/link_text.dart';
import 'package:mastermind_together/src/ui/widgets/logo.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

class TenantRegisterScreen extends GetView<TenantController> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tenantNameController = TextEditingController();
  final TextEditingController adminEmailController = TextEditingController();
  final TextEditingController adminPasswordController = TextEditingController();
  final TextEditingController confirmAdminPasswordController = TextEditingController();

  TenantRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TermsAndConditionsWidget termsOfService = TermsAndConditionsWidget(tenantId: "OUR_TENANT_TODO"); //TODO Add our tenantId to display our TOS.

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
                    const Text('Register Tenant', style: h3),
                    const SizedBox(height: 2 * fontSize),
                    CustomTextFormField(
                      controller: tenantNameController,
                      label: 'Tenant Name',
                      hintText: "Enter your tenant name",
                      validator: FormValidators.validateUsername, // update this as per your requirements
                    ),
                    const SizedBox(height: 2 * fontSize),
                    CustomTextFormField(
                      controller: adminEmailController,
                      label: 'Admin Email',
                      hintText: "Enter your admin email",
                      validator: FormValidators.validateEmail,
                    ),
                    const SizedBox(height: 2 * fontSize),
                    CustomTextFormField(
                      controller: adminPasswordController,
                      label: 'Admin Password',
                      hintText: "Enter your admin password",
                      obscureText: true,
                      validator: FormValidators.validatePassword,
                    ),
                    const SizedBox(height: 2 * fontSize),
                    CustomTextFormField(
                      controller: confirmAdminPasswordController,
                      label: 'Confirm Admin Password',
                      hintText: "Confirm your admin password",
                      obscureText: true,
                      validator: (value) {
                        return FormValidators.validateConfirmPassword(value, adminPasswordController.text);
                      },
                    ),
                    const SizedBox(height: 2 * fontSize),
                    termsOfService,
                    const SizedBox(height: 2 * fontSize),
                    Obx(
                      () => CustomButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            controller.registerTenant(tenantNameController.text, adminEmailController.text, adminPasswordController.text);
                          }
                        },
                        enabled: termsOfService.isChecked.value,
                        child: const Text('Register Tenant'),
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
