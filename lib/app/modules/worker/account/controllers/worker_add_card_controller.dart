import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkerAddCardController extends GetxController {
  final isEditing = false.obs;
  
  final nameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final countryController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['isEditing'] == true) {
      isEditing.value = true;
      final card = args['card'];
      nameController.text = card['type'] ?? '';
      cardNumberController.text = card['number'] ?? '';
      expiryController.text = card['expiry']?.replaceAll('Expires ', '') ?? '';
    }
  }

  void handleAction() {
    if (isEditing.value) {
      deleteCard();
    } else {
      saveCard();
    }
  }

  void saveCard() {
    Get.back();
    Get.snackbar('Success', 'Card added successfully.');
  }

  void deleteCard() {
    Get.back();
    Get.snackbar('Success', 'Card deleted successfully.');
  }

  @override
  void onClose() {
    nameController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    countryController.dispose();
    super.onClose();
  }
}
