import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportController extends GetxController {
  // Feedback Form Controllers
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // FAQ State
  final expandedIndex = (-1).obs;

  void toggleFAQ(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1;
    } else {
      expandedIndex.value = index;
    }
  }

  void submitFeedback() {
    if (subjectController.text.isEmpty || emailController.text.isEmpty || messageController.text.isEmpty) {
      Get.snackbar(
        'Oops', 
        'Please fill all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Simulate API call
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      Get.back(); // Close loading
      Get.back(); // Go back from Feedback screen
      Get.snackbar(
        'Success', 
        'Feedback submitted successfully.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Clear controllers
      subjectController.clear();
      emailController.clear();
      messageController.clear();
    });
  }

  void pickAttachment() {
    // Logic to pick image/document
    Get.snackbar('Info', 'Attachment feature coming soon!');
  }

  @override
  void onClose() {
    subjectController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
