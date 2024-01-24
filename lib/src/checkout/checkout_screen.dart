import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/checkout/checkout_controller.dart';

class CheckoutScreen extends GetView<CheckoutController> {
  CheckoutScreen({super.key});

  final String? priceId = Get.parameters['priceId'];

  @override
  Widget build(BuildContext context) {
    if(!controller.isLoading.value) {
      return FutureBuilder(
        future: controller.initiateCheckout(priceId: priceId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          }
          return const Scaffold(
            body: Center(child: Text('Checkout process initiated')),
          );
        },
      );
    }
    else return Container();
  }
}
