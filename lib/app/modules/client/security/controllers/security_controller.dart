import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';
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

  Future<void> savePassword() async {
    final oldPassword = currentPassController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar('Error', 'New passwords do not match', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.replaceAll('"', '').trim();

      final response = await http.post(
        Uri.parse('${ApiServices.baseurl}/api/user/password/change/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
          'confirm_new_password': confirmPassword,
        }),
      );

      Get.back(); // close loading dialog

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Your password successfully changed', snackPosition: SnackPosition.BOTTOM);
        currentPassController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String errorMessage = 'Failed to change password';
        
        if (responseData.containsKey('detail')) {
          errorMessage = responseData['detail'];
        } else if (responseData.containsKey('old_password')) {
          errorMessage = responseData['old_password'][0];
        } else if (responseData.containsKey('new_password')) {
          errorMessage = responseData['new_password'][0];
        } else if (responseData.containsKey('confirm_new_password')) {
          errorMessage = responseData['confirm_new_password'][0];
        } else if (responseData.containsKey('non_field_errors')) {
          errorMessage = responseData['non_field_errors'][0];
        } else if (responseData.containsKey('error')) {
          errorMessage = responseData['error'];
        }
        
        Get.snackbar('Error', errorMessage, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.back(); // close loading dialog
      print('Error changing password: $e');
      Get.snackbar('Error', 'Something went wrong', snackPosition: SnackPosition.BOTTOM);
    }
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
