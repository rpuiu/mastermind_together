import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/profile/profile_pic_widget.dart';
import 'package:mastermind_together/src/profile/user_profile_controller.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/custom_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';
import 'package:mastermind_together/src/ui/widgets/text_form_field.dart';
import 'package:mastermind_together/src/util/form_validators.dart';

class UserProfileScreen extends GetView<UserProfileController> {
  UserProfileScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _usernameFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(fontSize),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const CircularProgressIndicator();
            }
            return userProfile(context);
          }),
        ),
      ),
    );
  }

  Widget userProfile(BuildContext context) {
    UserModel user = controller.user.value!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const ProfilePictureWidget(allowEditing: true),
        xSpace,
        Text(user.username, style: headingText),
        xSpace,
        Text(user.email, style: labelText),
        xxSpace,
        changeUsername(context, user),
        xSpace,
        changePassword(context),
        xxSpace,
      ],
    );
  }

  ElevatedButton changePassword(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Change Password'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // set to min to prevent overflow
                  children: [
                    CustomTextFormField(
                      controller: controller.oldPasswordController,
                      label: 'Old Password',
                      hintText: 'Enter your old password',
                      obscureText: true,
                      validator: FormValidators.validatePassword,
                    ),
                    xSpace, // Add space
                    CustomTextFormField(
                      controller: controller.newPasswordController,
                      label: 'New Password',
                      hintText: 'Enter your new password',
                      obscureText: true,
                      validator: FormValidators.validatePassword,
                    ),
                    xSpace,
                    CustomTextFormField(
                      controller: controller.confirmPasswordController,
                      label: 'Confirm Password',
                      hintText: 'Confirm your new password',
                      obscureText: true,
                      validator: (value) {
                        return FormValidators.validateConfirmPassword(value, controller.confirmPasswordController.text);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Change Password'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    controller.changePassword().then((_) {
                      controller.clearForm();
                      Navigator.of(context).pop();
                    }).catchError((e) {
                      showErrorSnackBar(message: 'Failed to change password: $e');
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
      child: const Text("Change Password"),
    );
  }

  ElevatedButton changeUsername(BuildContext context, UserModel user) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('New Username'),
            content: Form(
              key: _usernameFormKey,
              child: CustomTextFormField(
                controller: controller.usernameController,
                label: 'Username',
                hintText: 'Enter your username',
                onChanged: (value) {
                  user = user.copyWith(username: value);
                  controller.user.value = user;
                },
                validator: FormValidators.validateUsername,
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  if (_usernameFormKey.currentState!.validate()) {
                    controller.updateUser(user);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
      child: const Text("Change Username"),
    );
  }
}
