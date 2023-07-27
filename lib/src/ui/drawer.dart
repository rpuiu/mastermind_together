import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';
import 'package:mastermind_together/src/ui/widgets/logo.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3, // 50% of screen width
                height: MediaQuery.of(context).size.height * 0.1, // 10% of screen height
                child: const Logo(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Get.toNamed(Routes.home),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Goal'),
            onTap: () => Get.toNamed(Routes.createGoal),
          ),
          ListTile(
            leading: const Icon(Icons.event_available),
            title: const Text('Availability'),
            onTap: () => Get.toNamed(Routes.availability),
          ),
          ListTile(
            leading: const Icon(Icons.groups),
            title: const Text('Groups'),
            onTap: () => Get.toNamed(Routes.allGroups),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: _authController.logout,
          ),
        ],
      ),
    );
  }
}
