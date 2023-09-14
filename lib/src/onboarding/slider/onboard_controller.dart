import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/services/sharedprefs/local_storage.dart';

class OnBoardController extends GetxController {
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();

  int currentPage = 0;
  bool isLastPage = false;
  final int totalPages = 3;

  bool hasCompletedOnboarding() {
    return false;
  }

  void onPageChanged(int page) {
    currentPage = page;
    isLastPage = currentPage == (totalPages - 1);
    update();
  }

  void restartOnboarding() {
    currentPage = 0;
    isLastPage = false;
    update();
  }

  void getStarted() {
    _localStorage.completeOnboarding();
    Get.toNamed(Routes.home);
  }
}
