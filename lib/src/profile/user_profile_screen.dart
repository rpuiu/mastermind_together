import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/user_model.dart';
import 'package:mastermind_together/src/profile/user_profile_controller.dart';
import 'package:mastermind_together/src/ui/drawer.dart';
import 'package:mastermind_together/src/ui/widgets/snackbar.dart';

class UserProfileScreen extends GetView<UserController> {
  UserProfileScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _usernameFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            UserModel user = controller.user.value!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Edit Username'),
                        content: Form(
                          key: _usernameFormKey,
                          child: TextFormField(
                            initialValue: user.username,
                            decoration: const InputDecoration(labelText: 'Username'),
                            onChanged: (value) {
                              user = user.copyWith(username: value);
                              controller.user.value = user;
                            },
                            validator: (value) => controller.validateIfEmpty(value!, 'Please enter your username'),
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
                  child: const Text("Edit Username"),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Change Password'),
                        content: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // set to min to prevent overflow
                            children: [
                              TextFormField(
                                controller: controller.oldPasswordController,
                                decoration: const InputDecoration(labelText: 'Old Password'),
                                obscureText: true,
                                validator: (value) => controller.validateIfEmpty(value!, 'Please enter your old password'),
                              ),
                              TextFormField(
                                controller: controller.newPasswordController,
                                decoration: const InputDecoration(labelText: 'New Password'),
                                obscureText: true,
                                validator: (value) => controller.validateIfEmpty(value!, 'Please enter your new password'),
                              ),
                              TextFormField(
                                controller: controller.confirmPasswordController,
                                decoration: const InputDecoration(labelText: 'Confirm Password'),
                                obscureText: true,
                                validator: (value) => controller.validateConfirmPassword(value!),
                              ),
                            ],
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
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
