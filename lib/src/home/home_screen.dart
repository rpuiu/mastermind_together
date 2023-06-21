import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/auth/auth_controller.dart';
import 'package:mastermind_together/src/routes.dart';

class HomeScreen extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: authController.logout,
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Get.toNamed(Routes.goal),
          child: Text("+ Goal"),
        ),
      ),
    );
  }
}
