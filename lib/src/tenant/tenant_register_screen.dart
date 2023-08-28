import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/tos/terms_and_conditions_widget.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/tenant/tenant_controller.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/custom_button.dart';
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
    String mmtTenantId = dotenv.env['MMT_TENANT_ID']!;
    final TermsAndConditionsWidget termsOfService = TermsAndConditionsWidget(tenantId: mmtTenantId);

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
                    xxSpace,
                    const Text('Register Tenant', style: headingText),
                    xxSpace,
                    CustomTextFormField(
                      controller: tenantNameController,
                      label: 'Tenant Name',
                      hintText: "Enter your tenant name",
                      validator: FormValidators.validateUsername, // update this as per your requirements
                    ),
                    xxSpace,
                    CustomTextFormField(
                      controller: adminEmailController,
                      label: 'Admin Email',
                      hintText: "Enter your admin email",
                      validator: FormValidators.validateEmail,
                    ),
                    xxSpace,
                    CustomTextFormField(
                      controller: adminPasswordController,
                      label: 'Admin Password',
                      hintText: "Enter your admin password",
                      obscureText: true,
                      validator: FormValidators.validatePassword,
                    ),
                    xxSpace,
                    CustomTextFormField(
                      controller: confirmAdminPasswordController,
                      label: 'Confirm Admin Password',
                      hintText: "Confirm your admin password",
                      obscureText: true,
                      validator: (value) {
                        return FormValidators.validateConfirmPassword(value, adminPasswordController.text);
                      },
                    ),
                    xxSpace,
                    termsOfService,
                    xxSpace,
                    Obx(
                      () => CustomButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            controller.registerTenant(tenantNameController.text, adminEmailController.text, adminPasswordController.text);
                          }
                        },
                        isEnabled: termsOfService.isChecked.value,
                        label: 'Register Tenant',
                        labelTextStyle: buttonTextStyle,
                        backgroundColor: buttonBackgroundColor,
                      ),
                    ),
                    xxSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        wHalfSpace,
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
