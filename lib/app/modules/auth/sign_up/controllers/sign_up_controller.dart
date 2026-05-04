import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final agreeToTerms = false.obs;

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
    if (value != null) {
      agreeToTerms.value = value;
    }
  }

  void signUp() {
    if (formKey.currentState!.validate() && agreeToTerms.value) {
      Get.offAllNamed(Routes.LOGIN);
    } else if (!agreeToTerms.value) {
      Get.snackbar('Terms & Privacy', 'You must agree to the terms and privacy policy');
    }
  }

  void navigateToLogin() {
    Get.back();
  }

  void onSocialLogin(String provider) {
    Get.snackbar('Social Login', 'Clicked on $provider signup');
  }
}

