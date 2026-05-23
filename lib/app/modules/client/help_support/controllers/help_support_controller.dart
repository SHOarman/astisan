import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../support/views/faqs_view.dart' as support_faqs;
import '../../../support/views/feedback_view.dart' as support_feedback;
import '../../../support/views/terms_of_service_view.dart' as support_terms;
import '../../../support/views/privacy_policy_view.dart' as support_privacy;

class HelpSupportController extends GetxController {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  void goToFaqs() {
    Get.to(() => const support_faqs.FaqsView());
  }

  void goToFeedback() {
    Get.to(() => const support_feedback.FeedbackView());
  }

  void goToTermsOfService() {
    Get.to(() => const support_terms.TermsOfServiceView());
  }

  void goToPrivacyPolicy() {
    Get.to(() => const support_privacy.PrivacyPolicyView());
  }

  void submitFeedback() {
    if (subjectController.text.isEmpty || emailController.text.isEmpty || messageController.text.isEmpty) {
      Get.snackbar('Oops'.tr, 'Please fill all fields'.tr);
      return;
    }
    Get.back();
    Get.snackbar('Success'.tr, 'Feedback submitted successfully.'.tr);
  }

  @override
  void onClose() {
    subjectController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}

