import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkerSavedAddressesController extends GetxController {
  final savedAddresses = <Map<String, dynamic>>[
    {
      'title': 'Home',
      'address': '2468 Westheimer Rd. Santa Ana, Illinois',
      'isDefault': true,
      'icon': Icons.home_outlined,
    },
    {
      'title': 'Office',
      'address': '8522 Preston Rd. Inglewood, Maine',
      'isDefault': false,
      'icon': Icons.work_outline,
    },
  ].obs;

  void addNewAddress() {
    // Navigate to add address screen or open dialog
    Get.snackbar('Coming Soon', 'Feature to add new address is in development.');
  }

  void saveChanges() {
    Get.back();
    Get.snackbar('Success', 'Address changes saved successfully.');
  }
}
