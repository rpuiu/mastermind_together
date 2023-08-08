import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/home/app_expansion_tile_controller.dart';

class GoalsCarouselController extends GetxController {
  static const double defaultHeight = 230.0;

  AppExpansionTileController expansionTileController = Get.find<AppExpansionTileController>();

  final RxDouble height = defaultHeight.obs;

  final PageController pageController = PageController(viewportFraction: 0.8);

  void updateHeight(bool expanded, int numberOfKeyResults) {
    double expandedHeight = expanded ? (numberOfKeyResults * 24.0) + 330.0 : defaultHeight;
    height.value = expandedHeight;
  }

  void resetHeight() {
    expansionTileController.collapse();
    height.value = defaultHeight;
  }

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(_pageChanged);
  }

  void _pageChanged() {
    int currentPage = pageController.page!.round();
    if (currentPage != pageController.page) {
      resetHeight();
    }
  }

  @override
  void onClose() {
    pageController.removeListener(_pageChanged);
    pageController.dispose();
    super.onClose();
  }
}
