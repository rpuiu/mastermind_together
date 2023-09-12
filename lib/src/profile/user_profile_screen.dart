import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/profile/profile_pic_widget.dart';
import 'package:mastermind_together/src/profile/user_profile_controller.dart';
import 'package:mastermind_together/src/ui/theme/scaffold/custom_scaffold.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/icon/edit_button.dart';
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
      applyPadding: false,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return userProfile(context);
      }),
    );
  }

  Widget userProfile(BuildContext context) {
    UserModel user = controller.user.value!;
    return Center(
      child: Column(
        children: [
          _buildBanner(),
          Transform.translate(
            offset: const Offset(0, -50),
            child: _buildProfilePicture(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(user.username, style: headingText),
              EditBtn(onPressed: () => _changeUserName(context, user)),
            ],
          ),
          halfSpace,
          Text(user.email, style: bodyMedium),
          xSpace,
          changePassword(context),
        ],
      ),
    );
  }

  SizedBox _buildBanner() {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: controller.signedAvatarUrl.value,
            placeholder: (context, url) => SizedBox(
              width: double.infinity,
              height: 200,
              child: Image.asset(
                'assets/images/profile/profile-banner.png',
                fit: BoxFit.cover,
                alignment: const Alignment(1, -0.55),
              ),
            ),
            errorWidget: (context, url, error) => SizedBox(
              width: double.infinity,
              height: 200,
              child: Image.asset(
                'assets/images/profile/profile-banner.png',
                fit: BoxFit.cover,
                alignment: const Alignment(1, -0.55),
              ),
            ),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  alignment: const Alignment(1, -0.55),
                ),
              ),
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [labelTextColor.withOpacity(0.6), hoverMenuIconColor.withOpacity(0.6)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return CircleAvatar(
      radius: 53,
      backgroundColor: whiteColor,
      child: ProfilePictureWidget(
        allowEditing: true,
        size: 100,
        imageUrl: controller.signedAvatarUrl.value,
        onEdit: () => controller.pickImage(),
      ),
    );
  }

  MouseRegion changePassword(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Change Password'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormField(
                        controller: controller.oldPasswordController,
                        label: 'Old Password',
                        hintText: 'Enter your old password',
                        obscureText: true,
                        validator: FormValidators.validatePassword,
                      ),
                      CustomTextFormField(
                        controller: controller.newPasswordController,
                        label: 'New Password',
                        hintText: 'Enter your new password',
                        obscureText: true,
                        validator: FormValidators.validatePassword,
                      ),
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
        child: Text("Change Password", style: linkTextStyle),
      ),
    );
  }

  void _changeUserName(BuildContext context, UserModel user) {
    TextEditingController tempUsernameController = TextEditingController(text: user.username);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Username'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 100),
          child: Form(
            key: _usernameFormKey,
            child: CustomTextFormField(
              controller: tempUsernameController,
              label: 'Username',
              hintText: 'Enter your username',
              validator: FormValidators.validateUsername,
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              if (_usernameFormKey.currentState!.validate()) {
                user = user.copyWith(username: tempUsernameController.text);
                controller.updateUser(user);
                controller.user.value = user;
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
