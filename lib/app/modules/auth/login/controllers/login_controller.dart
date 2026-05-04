import 'package:flutter/widgets.dart';
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
    emailController.dispose();
    passwordController.dispose();
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
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }

  void navigateToSignUp() {
    Get.toNamed(Routes.SIGN_UP);
  }
  void navigateForgotPassword() {
    Get.toNamed(Routes.FORGOT_PASSWORD);
  }

  void onSocialLogin(String provider) {
    Get.snackbar('Social Login', 'Clicked on $provider login');
  }
}

