import 'package:get/get.dart';

class AppExpansionTileController extends GetxController {
  final RxBool isExpanded = false.obs;

  AppExpansionTileController();

  void toggle() {
    isExpanded.value = !isExpanded.value;
  }

  void collapse() {
    isExpanded.value = false;
  }

  void expand() {
    isExpanded.value = true;
  }
}
