import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/tenant/tenant_controller.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/tenant_drawer.dart';

class TenantDashboardScreen extends GetView<TenantController> {
  const TenantDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: const Center(
        child: Text('Tenant Dashboard'),
      ),
      drawer: TenantDrawer(),
    );
  }
}
