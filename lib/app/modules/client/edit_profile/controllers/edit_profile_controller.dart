import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final fullNameController = TextEditingController(text: 'Alex Johnson');
  final emailController = TextEditingController(text: 'alex.johnson@email.com');
  final phoneController = TextEditingController(text: '+01 (500) 000-0000');

  void saveChanges() {
    Get.back();
  }

  void pickImage() {
    // Open image picker
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}

