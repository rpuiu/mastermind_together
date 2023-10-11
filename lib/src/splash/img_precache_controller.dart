import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePrecacheController extends GetxController {
  final RxBool imagesLoaded = false.obs;
  final List<String> images = [
    'assets/images/login/login-1.png',
    'assets/images/login/login-2.png',
    'assets/images/login/login-3.png',
    'assets/images/login/login-4.png',
    'assets/images/login/login-5.png',
  ];
  final RxInt randomImageIndex = (0).obs;

  String get randomImagePath => images[randomImageIndex.value];

  Future<void> loadImages(BuildContext context) async {
    for (var imagePath in images) {
      await precacheImage(AssetImage(imagePath), context);
    }
    randomImageIndex.value = Random().nextInt(images.length); // Set a random image index
    imagesLoaded.value = true; // Set the flag to true once all images are loaded
  }
}
