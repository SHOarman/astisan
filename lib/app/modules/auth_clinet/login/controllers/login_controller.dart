import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/global_controllers/role_controller.dart';
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
          "password": passwordController.text.trim(),
        };

        print("Login URL: ${ApiServices.client_login}");
        print("Payload: ${json.encode(requestBody)}");

        final response = await http.post(
          Uri.parse(ApiServices.client_login),
          headers: { 'Accept-Language': ApiServices.currentLanguage, 
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(requestBody),
        );

        final data = json.decode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          print("--- LOGIN SUCCESS ---");
          print("Full API Response Body: ${response.body}");

          // Robust token extraction
          String token = '';
          
          // Check top level
          token = data['access']?.toString() ?? 
                  data['token']?.toString() ?? 
                  data['access_token']?.toString() ?? '';
          
          // Check nested 'data' object
          if (token.isEmpty && data['data'] != null && data['data'] is Map) {
            final nested = data['data'];
            token = nested['access']?.toString() ?? 
                    nested['token']?.toString() ?? 
                    nested['access_token']?.toString() ?? '';
          }
          
          // Check nested 'tokens' object (common in some frameworks)
          if (token.isEmpty && data['tokens'] != null && data['tokens'] is Map) {
            token = data['tokens']['access']?.toString() ?? '';
          }

          if (token.isEmpty) {
            print("WARNING: Login successful but NO TOKEN found in response keys");
            Get.snackbar('Warning'.tr, 'Login success, but session token missing'.tr);
          } else {
            String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
            print("Extracted Clean Token: $cleanToken");
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', cleanToken);
            await prefs.setString('role', 'client');
            
            // Sync RoleController
            if (Get.isRegistered<RoleController>()) {
              Get.find<RoleController>().setRole('client');
            }
            
            print("Token and Role saved to SharedPreferences");
          }

          Get.snackbar('Success'.tr, 'Login Successful'.tr);
          
          FocusManager.instance.primaryFocus?.unfocus();
          await Future.delayed(const Duration(milliseconds: 250));
          
          Get.offAllNamed(Routes.DASHBOARD);
        } else {
          Get.snackbar('Error', data['message'] ?? 'Invalid credentials');
          print("Error Response: ${response.body}");
        }
      } catch (e) {
        print("Catch Error: $e");
        Get.snackbar('Error'.tr, 'Connection failed'.tr);
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
    Get.snackbar('Social Login'.tr, 'Initiating $provider login...'.tr);
  }
}