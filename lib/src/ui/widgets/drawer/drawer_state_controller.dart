import 'package:get/get.dart';

class DrawerStateController extends GetxController {
  var activeButton = 'Home'.obs;

  void setActiveButton(String text) {
    activeButton.value = text;
  }
}
