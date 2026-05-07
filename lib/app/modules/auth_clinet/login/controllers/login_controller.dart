import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/routes/app_routes.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

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

  Future<void> signIn() async {
    if (formKey.currentState!.validate()) {
      Get.focusScope?.unfocus();
      isLoading.value = true;

      try {
        final Map<String, dynamic> requestBody = {
          "email": emailController.text.trim(),
          "password": passwordController.text,
        };

        print("Login URL: ${ApiServices.client_login}");
        print("Payload: ${json.encode(requestBody)}");

        final response = await http.post(
          Uri.parse(ApiServices.client_login),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(requestBody),
        );

        final data = json.decode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          print("--- LOGIN SUCCESS ---");
          print("Full API Response: $data");

          String token = data['access'] ?? data['token'] ?? data['access_token'] ?? '';
          
          if (data['data'] != null && data['data'] is Map) {
            token = data['data']['access'] ?? data['data']['token'] ?? token;
          }

          print("User Token: $token");

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          Get.snackbar('Success', 'Login Successful');
          
          // ফোকাস রিমুভ করে নেভিগেট করার আগে একটু সময় নেওয়া, যাতে caret render error না আসে
          FocusManager.instance.primaryFocus?.unfocus();
          await Future.delayed(const Duration(milliseconds: 250));
          
          Get.offAllNamed(Routes.DASHBOARD);
        } else {
          Get.snackbar('Error', data['message'] ?? 'Invalid credentials');
          print("Error Response: ${response.body}");
        }
      } catch (e) {
        print("Catch Error: $e");
        Get.snackbar('Error', 'Connection failed');
      } finally {
        isLoading.value = false;
      }
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
    Get.snackbar('Social Login', 'Initiating $provider login...');
  }
}