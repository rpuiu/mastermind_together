import 'package:get/get.dart';

class ActionEditController extends GetxController {
  var isEditingMap = <String, bool>{}.obs;

  void toggleEditing(String actionId) {
    if (isEditingMap[actionId] == null || !isEditingMap[actionId]!) {
      isEditingMap[actionId] = true;
    } else {
      isEditingMap[actionId] = false;
    }
    update();
  }

  bool isEditing(String actionId) {
    return isEditingMap[actionId] ?? false;
  }
}
