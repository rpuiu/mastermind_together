import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/admin/tenant_controller.dart';
import 'package:mastermind_together/src/ui/widgets/buttons/button.dart';

class TenantRegisterScreen extends GetView<TenantController> {
  const TenantRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Tenant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: controller.tenantNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tenant Name',
              ),
            ),
            CustomButton(
              onPressed: controller.registerTenant,
              child: Text('Register Tenant'),
            ),
          ],
        ),
      ),
    );
  }
}
