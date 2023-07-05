import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSuccessSnackBar({String title = "Success", required String message, IconData? icon}) {
  return _getSnackBar(title, message, icon, Colors.green);
}

showInfoSnackBar({String title = 'Info', required String message, IconData? icon}) {
  return _getSnackBar(title, message, icon, Colors.blue);
}

showErrorSnackBar({String title = 'Error', required String message, IconData icon = Icons.error}) {
  return _getSnackBar(title, message, icon, Colors.red);
}

SnackbarController _getSnackBar(String title, String message, IconData? icon, Color backgroundColor) {
  return Get.snackbar(
    title,
    message,
    icon: Icon(icon),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: backgroundColor,
    borderRadius: 20,
    margin: EdgeInsets.all(15),
    colorText: Colors.white,
    duration: Duration(seconds: 4),
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack,
  );
}
