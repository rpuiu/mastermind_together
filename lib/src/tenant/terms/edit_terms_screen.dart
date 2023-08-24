import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/tenant/terms/terms_controller.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/tenant_drawer.dart';

class EditTermsScreen extends GetView<TermsController> {
  const EditTermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service & Privacy Policy'),
      ),
      drawer: TenantDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Obx(() => TextField(
                    controller: controller.tosController.value,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Terms of Service',
                    ),
                  )),
              xSpace,
              Obx(() => TextField(
                    controller: controller.ppController.value,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Privacy Policy',
                    ),
                  )),
              xSpace,
              ElevatedButton(
                onPressed: () => controller.updateTerms(),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
