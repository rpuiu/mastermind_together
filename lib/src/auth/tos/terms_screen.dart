import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/tenant/terms/terms_controller.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/theme/text_styles.dart';

class TermsScreen extends GetView<TermsController> {
  final String documentType;

  const TermsScreen({Key? key, required this.documentType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(documentType == 'TOS' ? 'Terms of Service' : 'Privacy Policy'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(() {
                    return Text(
                      documentType == 'TOS' ? controller.termsOfService.value : controller.privacyPolicy.value,
                      textAlign: TextAlign.center,
                      style: bodyRegular,
                    );
                  }),
                ),
              ),
              xSpace,
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Accept Terms'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
