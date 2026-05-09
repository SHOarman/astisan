import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/Services/api_services.dart';
import '../../../../core/routes/app_routes.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final referralController = TextEditingController();

  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final agreeToTerms = false.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    referralController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.value = !obscureConfirmPassword.value;

  void toggleTermsAgreement(bool? value) {
    if (value != null) agreeToTerms.value = value;
  }

  Future<void> signUp() async {
    if (formKey.currentState!.validate() && agreeToTerms.value) {
      Get.focusScope?.unfocus();
      isLoading.value = true;

      try {
        final Map<String, dynamic> requestBody = {
          "full_name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
          "password": passwordController.text,
        };

        if (referralController.text.trim().isNotEmpty) {
          requestBody["referral_code"] = referralController.text.trim();
        }

        print("API URL: ${ApiServices.client_sendotp}");
        print("Request Payload: ${json.encode(requestBody)}");

        final response = await http.post(
          Uri.parse(ApiServices.client_sendotp),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(requestBody),
        );

        print("Response Status: ${response.statusCode}");
        print("Response Body: ${response.body}");

        final data = json.decode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.snackbar('Success', 'OTP sent to your email/phone');

          FocusManager.instance.primaryFocus?.unfocus();
          await Future.delayed(const Duration(milliseconds: 250));

          Get.toNamed(
            Routes.VERIFICATION,
            arguments: {
              'full_name': nameController.text.trim(),
              'email': emailController.text.trim(),
              'phone': phoneController.text.trim(),
              'password': passwordController.text,
              'referral_code': referralController.text.trim(),
            },
          );
        } else {
          String errorMsg = data['message'] ?? response.body.toString();
          Get.snackbar(
            'Registration Failed',
            errorMsg,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
          );
        }
      } catch (e) {
        print("Connection Error: $e");
        Get.snackbar(
          'Error',
          'Could not connect to server. Check your internet.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    } else if (!agreeToTerms.value) {
      Get.snackbar(
        'Terms & Privacy',
        'You must agree to the terms and privacy policy',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> onSocialLogin(String provider) async {
    Get.snackbar('Social Login', 'Initiating $provider login...');
  }

  void navigateToLogin() {
    Get.focusScope?.unfocus();
    Get.back();
  }
}