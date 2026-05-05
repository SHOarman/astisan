import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/global_controllers/role_controller.dart';

class AuthWorkerController extends GetxController {
  // --- Form Keys ---
  final formKey = GlobalKey<FormState>();
  final loginFormKey = GlobalKey<FormState>();

  // --- Controllers ---
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // --- Reactive States (.obs) ---
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final agreeToTerms = false.obs;
  final rememberMe = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void toggleTermsAgreement(bool? value) {
    if (value != null) agreeToTerms.value = value;
  }

  void toggleRememberMe(bool? value) {
    if (value != null) rememberMe.value = value;
  }

  // --- Authentication Actions ---

  // লগইন ফাংশন
  void signIn() {
    if (loginFormKey.currentState?.validate() ?? true) {
      Get.focusScope?.unfocus();
      Get.find<RoleController>().setRole('worker');
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }

  void signUp() {
    if (formKey.currentState!.validate()) {
      if (agreeToTerms.value) {
        Get.focusScope?.unfocus();
        Get.find<RoleController>().setRole('worker');
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.snackbar(
          'Terms & Privacy',
          'You must agree to the terms and privacy policy',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    }
  }

  // --- Navigation Methods ---
  void navigateToSignUp() {
    Get.focusScope?.unfocus();
    Get.toNamed(Routes.SIGN_UP);
  }

  void navigateToLogin() {
    Get.focusScope?.unfocus();
    Get.back();
  }

  void navigateForgotPassword() {
    Get.focusScope?.unfocus();
    Get.toNamed(Routes.FORGOT_PASSWORD);
  }

  void onSocialLogin(String provider) {
    Get.snackbar(
      'Social Login',
      'Clicked on $provider',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}