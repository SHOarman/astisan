import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedAddressesController extends GetxController {
  final savedAddresses = <Map<String, dynamic>>[
    {
      'title': 'Home',
      'address': '123 Main Street, Apt 4B, New York, NY 10001',
      'isDefault': true,
      'icon': Icons.home_rounded,
    },
    {
      'title': 'Office',
      'address': '456 Business Ave, Suite 200, New York, NY 10002',
      'isDefault': false,
      'icon': Icons.work_rounded,
    },
  ].obs;

  void addNewAddress() {
    // Navigate to add address
  }

  void saveChanges() {
    Get.back();
  }
}
