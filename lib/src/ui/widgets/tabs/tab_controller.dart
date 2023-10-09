import 'package:get/get.dart';

class TabsController extends GetxController {
  RxInt tabIndex = (0).obs;
  RxInt hoverIndex = (-1).obs; // -1 indicates no tab is being hovered over
}
