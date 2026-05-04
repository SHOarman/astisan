import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  /// Updates the current index when user swipes PageView
  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  /// Navigates to next page natively, or goes to login if on the final page
  void onNextTapped() {
    if (currentIndex.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed(Routes.ROLE_SELECTION);
    }
  }
}

