import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../payment_method/controllers/payment_method_controller.dart';

class AddCardController extends GetxController {
  final nameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final addressController = TextEditingController();
  final isLoading = false.obs;

  void saveCard() {
    if (nameController.text.isEmpty || cardNumberController.text.isEmpty || expiryController.text.isEmpty) {
      Get.snackbar('Error'.tr, 'Please fill all card details'.tr);
      return;
    }

    try {
      final paymentController = Get.find<PaymentMethodController>();
      
      // Basic logic to detect card type
      String type = 'Visa';
      String image = 'assets/images/visa_logo.png';
      if (cardNumberController.text.startsWith('5')) {
        type = 'Master';
        image = 'assets/images/master_logo.png';
      }

      paymentController.savedCards.add({
        'type': type,
        'number': '•••••${cardNumberController.text.substring(cardNumberController.text.length >= 4 ? cardNumberController.text.length - 4 : 0)}',
        'expiry': 'Expires ${expiryController.text}',
        'image': image,
      });

      Get.back();
      Get.snackbar('Success'.tr, 'Card added successfully'.tr);
    } catch (e) {
      Get.snackbar('Error'.tr, 'Failed to add card'.tr);
    }
  }

  void deleteCard() {
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
