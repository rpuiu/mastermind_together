import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/splash/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setContext(context);
    });

    return Obx(() {
      if (controller.dataLoaded.value) {
        Future.microtask(() => controller.redirect());
      }

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
