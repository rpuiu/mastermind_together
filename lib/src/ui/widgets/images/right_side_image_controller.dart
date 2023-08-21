import 'dart:math';

import 'package:get/get.dart';

class RightSideImageController extends GetxController {
  var randomImageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    randomImageIndex.value = Random().nextInt(5);
  }
}

class RightSideImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RightSideImageController>(() => RightSideImageController());
  }
}
