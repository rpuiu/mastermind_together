import 'package:get/get.dart';

class DrawerButtonController extends GetxController {
  RxString activeButton = ''.obs;
  RxBool isHovered = false.obs;

  void setActiveButton(String buttonName) {
    activeButton.value = buttonName;
  }

  void setHovered(bool state) {
    isHovered.value = state;
  }
}
