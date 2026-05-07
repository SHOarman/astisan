import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/Services/api_services.dart';
import '../../../../core/routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> sendCode() async {
    if (formKey.currentState!.validate()) {
      Get.focusScope?.unfocus();
      isLoading.value = true;
      try {
        final response = await http.post(
          Uri.parse(ApiServices.forgot_password_init),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
          body: json.encode({"email": emailController.text.trim()}),
        );
        final data = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.snackbar('Success', 'OTP sent to your email');
          
          FocusManager.instance.primaryFocus?.unfocus();
          await Future.delayed(const Duration(milliseconds: 250));
          
          Get.toNamed(Routes.restverifcationemail, arguments: {'email': emailController.text.trim()});
        } else {
          Get.snackbar('Error', data['message'] ?? 'Failed to send code');
        }
      } catch (e) {
        Get.snackbar('Error', 'Connection failed');
      } finally {
        isLoading.value = false;
      }
    }
  }
}