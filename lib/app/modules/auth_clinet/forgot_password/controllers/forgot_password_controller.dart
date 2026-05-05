import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void sendCode() {
    if (formKey.currentState!.validate()) {
      Get.toNamed(Routes.VERIFICATION, arguments: {'email': emailController.text});
    }
  }
}

