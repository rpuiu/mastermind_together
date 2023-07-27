import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Image.asset(
      'assets/images/logo/mmt-logo.png',
      width: screenWidth * 0.1, // adjust the fraction as per your need
      height: screenWidth * 0.1 * 64 / 115.96, // maintaining the aspect ratio
    );
  }
}
