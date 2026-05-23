import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/Services/api_services.dart';
import '../../../../core/global_controllers/role_controller.dart';
import '../../../../core/routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> sendCode() async {
    if (formKey.currentState!.validate()) {
      Get.focusScope?.unfocus();
      isLoading.value = true;
      try {
        final roleController = Get.find<RoleController>();
        final response = await http.post(
          Uri.parse(ApiServices.forgot_password_init),
          headers: { 'Accept-Language': ApiServices.currentLanguage, 'Content-Type': 'application/json', 'Accept': 'application/json'},
          body: json.encode({
            "email": emailController.text.trim(),
            "role": roleController.currentRole.value
          }),
        );
        final data = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.snackbar('Success'.tr, 'OTP sent to your email'.tr);
          
          FocusManager.instance.primaryFocus?.unfocus();
          await Future.delayed(const Duration(milliseconds: 250));
          
          Get.toNamed(Routes.restverifcationemail, arguments: {'email': emailController.text.trim()});
        } else {
          String errorMsg = 'Failed to send code';
          if (data is Map) {
            errorMsg = data['message'] ?? data['detail'] ?? data['error'] ?? 'User with this email not found';
          }
          Get.snackbar('Error', errorMsg);
        }
      } catch (e) {
        Get.snackbar('Error'.tr, 'Connection failed'.tr);
      } finally {
        isLoading.value = false;
      }
    }
  }
}