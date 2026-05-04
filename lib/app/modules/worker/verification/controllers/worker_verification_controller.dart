import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkerVerificationController extends GetxController {
  final currentStep = 0.obs;
  final pageController = PageController();

  // Step 1: Document Selection
  final selectedDocType = 'ID Card'.obs; // 'ID Card' or 'Passport'

  // Step 2: Information
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final idNumberController = TextEditingController();

  @override
  void onClose() {
    pageController.dispose();
    nameController.dispose();
    dobController.dispose();
    idNumberController.dispose();
    super.onClose();
  }

  void nextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
      if (currentStep.value < 4) {
        pageController.animateToPage(
          currentStep.value,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      // From success/failure screen, we go back to dashboard
      Get.back();
    }
  }

  void previousStep() {
    if (currentStep.value > 0 && currentStep.value < 4) {
      currentStep.value--;
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  void showSuccess() {
    currentStep.value = 4;
  }

  void showFailure() {
    currentStep.value = 5;
  }

  void selectDocType(String type) {
    selectedDocType.value = type;
  }
}

