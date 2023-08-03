import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/routes.dart';

class TenantDrawer extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

  TenantDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Tenant Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => Get.toNamed(Routes.tenantDashboard),
          ),
          ListTile(
            leading: const Icon(Icons.policy),
            title: const Text('Terms of Service & Privacy Policy'),
            onTap: () => Get.toNamed(Routes.editTerms),
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Goal & Group Categories'),
            onTap: () => Get.toNamed(Routes.categories),
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Logo & Colors'),
            onTap: () => {
              /* Navigate to Logo & Colors page */
            },
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
