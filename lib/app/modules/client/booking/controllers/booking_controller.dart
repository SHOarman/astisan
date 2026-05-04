import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class BookingController extends GetxController {
  final currentStep = 1.obs;
  final capturedImagePath = ''.obs;

  // Date & Time
  final dates = [
    {'day': 'Mon', 'date': '6', 'month': 'Apr'},
    {'day': 'Tue', 'date': '7', 'month': 'Apr'},
    {'day': 'Wed', 'date': '8', 'month': 'Apr'},
    {'day': 'Thu', 'date': '9', 'month': 'Apr'},
    {'day': 'Fri', 'date': '10', 'month': 'Apr'},
    {'day': 'Sat', 'date': '11', 'month': 'Apr'},
  ];
  final selectedDateIndex = 4.obs; // Fri 10 Apr selected in image

  final times = [
    '8:00 AM',
    '10:00 AM',
    '12:00 PM',
    '2:00 PM',
    '4:00 PM',
    '6:00 PM',
  ];
  final selectedTimeIndex = 1.obs; // 10:00 AM selected

  // Address
  final addresses = [
    {
      'title': 'Home',
      'address': '123 Main Street, Apt 4B, New York, NY 10001',
      'isDefault': true,
    },
    {
      'title': 'Office',
      'address': '456 Business Ave, Suite 200, New York, NY 10002',
      'isDefault': false,
    },
  ];
  final selectedAddressIndex = 0.obs;

  // Notes
  final notesController = TextEditingController();
  final notesLength = 0.obs;
  
  // Navigation source
  final source = ''.obs;
  
  final quickNotes = [
    '+ Urgent repair',
    '+ Bring materials',
    '+ Multiple items',
    '+ Call before arriving',
    '+ Weekend preferred',
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize source from arguments
    if (Get.arguments != null && Get.arguments is Map) {
      source.value = Get.arguments['source'] ?? '';
    }
    
    notesController.addListener(() {
      notesLength.value = notesController.text.length;
    });
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    } else if (currentStep.value == 3) {
      Get.toNamed(Routes.CAMERA);
    } else if (currentStep.value == 5) {
      // In a real app, this would submit the payload to an API
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  void addQuickNote(String note) {
    final cleanNote = note.replaceAll('+ ', '');
    final currentText = notesController.text;
    if (currentText.isEmpty) {
      notesController.text = cleanNote;
    } else {
      notesController.text = '$currentText, $cleanNote';
    }
  }
}

