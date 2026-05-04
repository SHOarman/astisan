import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import 'delete_account_dialog.dart';

class SecurityController extends GetxController {
  final currentPassController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isCurrentPassVisible = false.obs;
  final isNewPassVisible = false.obs;
  final isConfirmPassVisible = false.obs;

  void toggleCurrentPassVisibility() => isCurrentPassVisible.toggle();
  void toggleNewPassVisibility() => isNewPassVisible.toggle();
  void toggleConfirmPassVisibility() => isConfirmPassVisible.toggle();

  void navigateToChangePassword() {
    Get.toNamed(Routes.CHANGE_PASSWORD);
  }

  void showDeleteAccountDialog() {
    Get.dialog(const DeleteAccountDialog());
  }

  void savePassword() {
    // Logic to save password
    Get.back();
  }

  void deleteAccount() {
    // Logic to delete account
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    currentPassController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
