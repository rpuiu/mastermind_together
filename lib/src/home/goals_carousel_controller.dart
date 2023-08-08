import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalsCarouselController extends GetxController {
  static const double defaultHeight = 230.0;
  final RxDouble height = defaultHeight.obs;

  final PageController pageController = PageController(viewportFraction: 0.8);

  void updateHeight(bool expanded, int numberOfKeyResults) {
    double expandedHeight = expanded ? (numberOfKeyResults * 24.0) + 330.0 : defaultHeight;
    height.value = expandedHeight;
  }

  void resetHeight() {
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
