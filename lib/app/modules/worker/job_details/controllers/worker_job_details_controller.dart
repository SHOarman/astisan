import 'package:flutter/material.dart'; // Added for Colors/Icons if needed
import 'package:get/get.dart';
import '../../../../core/components/success_dialog.dart';
import '../../../../core/routes/app_routes.dart';
import '../views/worker_image_view.dart';
import '../views/start_work_dialog.dart';

class WorkerJobDetailsController extends GetxController {
  // --- States ---
  final isLoading = false.obs; // Added this missing variable

  // Client Info
  final clientName = "Alex Thompson".obs;
  final clientAddress = "142 Oak Street, Apt 5B".obs;
  final clientRating = 4.8.obs;
  final clientImage = "assets/images/home/Sarah Williams.png".obs;

  // Service Info
  final serviceName = "Pipe Leak Repair".obs;
  final paymentAmount = 75.00.obs;
  final bookingId = "#J1".obs;

  // Schedule & Location
  final scheduledTime = "April 8, 2026 at 10:00 AM".obs;
  final distance = "2.5 km away".obs;
  final arrivalTime = "12 min".obs;

  // Notes & Attachment
  final clientNotes = "Leaking pipe under the kitchen sink. Water pooling on floor. Needs urgent attention.".obs;
  final attachmentName = "Pipe leak Image".obs;
  final attachmentImage = "assets/images/pipe_leak.png".obs;

  final checklist = <Map<String, dynamic>>[
    {'title': 'Arrive at location', 'checked': true},
    {'title': 'Greet client & inspect issue', 'checked': true},
    {'title': 'Complete the repair', 'checked': false},
    {'title': 'Clean up workspace', 'checked': false},
    {'title': 'Get client signature', 'checked': false},
  ].obs;

  // --- Logic Methods ---

  void toggleCheck(int index) {
    checklist[index]['checked'] = !checklist[index]['checked'];
    checklist.refresh();
  }

  void startNavigation() => Get.toNamed(Routes.WORKER_NAVIGATION);

  void viewAttachment() => Get.to(() => WorkerImageView(imagePath: attachmentImage.value));

  void callClient() {
    // Logic for URL launcher or Phone call
  }

  void chatClient() => Get.toNamed(Routes.WORKER_CHAT);

  void iveArrived() => Get.dialog(const StartWorkDialog());

  void reportIssue() => Get.toNamed(Routes.REPORT_ISSUE);

  // --- Fixed Complete Job Logic ---
  Future<void> completeJob() async {
    // Checklist check bad deya hoyeche
    isLoading.value = true;

    try {
      // 1. Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // 2. Show Success Dialog
      Get.dialog(
        const SuccessDialog(
          message: "Job completed successfully!",
        ),
        barrierDismissible: false,
      );

      // 3. Pause for user to see the success
      await Future.delayed(const Duration(milliseconds: 2000));

      // 4. Navigate back to Dashboard
      Get.offAllNamed(Routes.DASHBOARD);

    } catch (e) {
      Get.snackbar("Error", "Could not complete job. Try again.");
    } finally {
      isLoading.value = false;
    }
  }

  void showCancellationDialog() {
    // Implementation for cancellation
  }

  void confirmCancellation() {
    Get.back(); // Close dialog
    Get.back(); // Go back
  }
}