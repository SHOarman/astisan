import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCardController extends GetxController {
  final nameController = TextEditingController(text: 'Sarah Miller');
  final cardNumberController = TextEditingController(text: '1540 2540 3256 3593');
  final expiryController = TextEditingController(text: '12/30');
  final cvvController = TextEditingController(text: '565');
  final addressController = TextEditingController(text: '75 Wellington Street');

  void saveCard() {
    // Logic to save card
    Get.back();
  }

  void deleteCard() {
    // Logic to delete card
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
