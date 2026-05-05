import 'package:flutter/material.dart'; // widgets.dart er poriborte material.dart use kora bhalo
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final rememberMe = false.obs;

  @override
  void onClose() {
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleRememberMe(bool? value) {
    if (value != null) {
      rememberMe.value = value;
    }
  }

  void signIn() {
    if (formKey.currentState!.validate()) {
      Get.focusScope?.unfocus();
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }

  void navigateToSignUp() {
    Get.focusScope?.unfocus();
    Get.toNamed(Routes.SIGN_UP);
  }

  void navigateForgotPassword() {
    Get.focusScope?.unfocus();
    Get.toNamed(Routes.FORGOT_PASSWORD);
  }

  void onSocialLogin(String provider) {
    Get.snackbar(
      'Social Login',
      'Clicked on $provider login',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}