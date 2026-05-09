import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/Services/api_services.dart';
import '../../../../core/global_controllers/role_controller.dart';
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

  @override
  void onClose() {
    super.onClose();
  }

  void toggleNewPasswordVisibility() => obscureNewPassword.value = !obscureNewPassword.value;
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> confirmReset() async {
    if (formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      Get.focusScope?.unfocus();
      
      await Future.delayed(const Duration(milliseconds: 150));
      
      isLoading.value = true;
      try {
        final response = await http.post(
          Uri.parse(ApiServices.forgot_password_confirm),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({
            "reset_token": resetToken,
            "new_password": newPasswordController.text.trim(),
            "confirm_new_password": confirmPasswordController.text.trim(),
          }),
        );
        
        final data = json.decode(response.body);
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.snackbar('Success', 'Password reset successfully. You can now login.');
          
          await Future.delayed(const Duration(milliseconds: 600));
          
          final roleController = Get.find<RoleController>();
          if (roleController.isWorker) {
            Get.offAllNamed(Routes.sing_in);
          } else {
            Get.offAllNamed(Routes.LOGIN);
          }
        } else {
          Get.snackbar('Error', data['message'] ?? 'Failed to reset password');
        }
      } catch (e) {
        Get.snackbar('Error', 'Connection failed. Please try again.');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
