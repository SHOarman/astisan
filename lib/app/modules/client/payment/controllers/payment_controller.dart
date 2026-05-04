import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class PaymentController extends GetxController {
  final cardholderNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final branchNameController = TextEditingController();

  void processPayment() {
    // Mock payment processing
    Get.toNamed(Routes.PAYMENT_SUCCESS);
  }

  @override
  void onClose() {
    cardholderNameController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    branchNameController.dispose();
    super.onClose();
  }
}

