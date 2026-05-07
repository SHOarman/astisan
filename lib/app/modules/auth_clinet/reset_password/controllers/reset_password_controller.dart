import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/Services/api_services.dart';
import '../../../../core/routes/app_routes.dart';

class ResetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final obscureNewPassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoading = false.obs;
  String resetToken = "";

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) resetToken = Get.arguments['reset_token'] ?? '';
  }

  void toggleNewPasswordVisibility() => obscureNewPassword.value = !obscureNewPassword.value;
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> confirmReset() async {
    if (formKey.currentState!.validate()) {
      Get.focusScope?.unfocus();
      isLoading.value = true;
      try {
        final response = await http.post(
          Uri.parse(ApiServices.forgot_password_confirm),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "reset_token": resetToken,
            "new_password": newPasswordController.text,
            "confirm_new_password": confirmPasswordController.text,
          }),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          FocusManager.instance.primaryFocus?.unfocus();
          await Future.delayed(const Duration(milliseconds: 250));
          
          Get.snackbar('Success', 'Password reset successfully');
          Get.offAllNamed(Routes.LOGIN);
        } else {
          Get.snackbar('Error', 'Failed to reset password');
        }
      } catch (e) { Get.snackbar('Error', 'Connection failed'); } finally { isLoading.value = false; }
    }
  }
}