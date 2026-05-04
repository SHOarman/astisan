import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/faqs_view.dart';
import '../views/feedback_view.dart';
import '../views/terms_of_service_view.dart';
import '../views/privacy_policy_view.dart';

class HelpSupportController extends GetxController {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  void goToFaqs() {
    Get.to(() => const FaqsView());
  }

  void goToFeedback() {
    Get.to(() => const FeedbackView());
  }

  void goToTermsOfService() {
    Get.to(() => const TermsOfServiceView());
  }

  void goToPrivacyPolicy() {
    Get.to(() => const PrivacyPolicyView());
  }

  void submitFeedback() {
    if (subjectController.text.isEmpty || emailController.text.isEmpty || messageController.text.isEmpty) {
      Get.snackbar('Oops', 'Please fill all fields');
      return;
    }
    Get.back();
    Get.snackbar('Success', 'Feedback submitted successfully.');
  }

  @override
  void onClose() {
    subjectController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}

