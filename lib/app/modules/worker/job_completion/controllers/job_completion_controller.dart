import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

import '../../../../core/components/success_dialog.dart';
import '../../../../core/routes/app_routes.dart';

class JobCompletionController extends GetxController {
  final signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: const Color(0xFF0F172A),
    exportBackgroundColor: Colors.white,
  );

  // States
  final isLoading = false.obs;
  final isSignatureEmpty = true.obs;

  // Mock data
  final jobTitle = "Pipe Leak Repair".obs;
  final clientName = "Jennifer Martinez".obs;
  final jobDate = "Today".obs;
  final jobPrice = 75.00.obs;

  final checklist = <Map<String, dynamic>>[
    {'title': 'Pipe inspection & diagnosis', 'checked': true},
    {'title': 'PVC pipe replacement', 'checked': true},
    {'title': 'Sealant & waterproofing', 'checked': true},
    {'title': 'Area cleaned up', 'checked': true},
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to signature changes
    signatureController.addListener(() {
      if (signatureController.isEmpty != isSignatureEmpty.value) {
        isSignatureEmpty.value = signatureController.isEmpty;
      }
    });
  }

  void toggleCheck(int index) {
    checklist[index]['checked'] = !checklist[index]['checked'];
    checklist.refresh();
  }

  void clearSignature() {
    signatureController.clear();
    isSignatureEmpty.value = true;
  }

  Future<void> completeJob() async {
    // 1. Validation check
    if (signatureController.isEmpty) {
      Get.snackbar(
        "Signature Required",
        "Please get the client's signature before completing the job.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
      );
      return;
    }

    isLoading.value = true;

    try {
      // 2. Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // 3. Show the Success Dialog properly
      // Using your imported SuccessDialog component
      Get.dialog(
        const SuccessDialog(
          message: "Client Signature added successfully.",
        ),
        barrierDismissible: false,
      );

      // 4. Wait for the user to see the success message
      await Future.delayed(const Duration(milliseconds: 2000));

      // 5. Navigate away
      // Get.offAllNamed will automatically close any open dialogs/snackbars
      Get.offAllNamed(Routes.WORKER_ACTIVE_JOB);

    } catch (e) {
      // Always good to handle potential errors
      Get.snackbar("Error", "Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    signatureController.dispose();
    super.onClose();
  }
}
