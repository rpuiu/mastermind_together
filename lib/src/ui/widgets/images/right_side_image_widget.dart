import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/ui/theme/sizes.dart';
import 'package:mastermind_together/src/ui/widgets/images/right_side_image_controller.dart';

class RightSideImage extends GetView<RightSideImageController> {
  const RightSideImage({super.key});

  @override
  Widget build(BuildContext context) {
    // List of image paths
    final List<String> images = [
      'assets/images/login/login-1.png',
      'assets/images/login/login-2.png',
      'assets/images/login/login-3.png',
      'assets/images/login/login-4.png',
      'assets/images/login/login-5.png',
    ];

    int randomIndex = controller.randomImageIndex.value;
    String randomImagePath = images[randomIndex];

    return Padding(
      padding: const EdgeInsets.all(2 * fontSize),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          image: DecorationImage(
            image: AssetImage(randomImagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
