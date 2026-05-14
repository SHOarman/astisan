import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/components/success_dialog.dart';
import '../../../../core/routes/app_routes.dart';
import '../views/worker_image_view.dart';
import '../views/start_work_dialog.dart';

class WorkerJobDetailsController extends GetxController {
  final isLoading = false.obs;
  final bookingId = "".obs;

  // Client Info
  final clientName = "Loading...".obs;
  final clientAddress = "".obs;
  final clientRating = 0.0.obs;
  final clientImage = "".obs;

  // Service Info
  final serviceName = "".obs;
  final paymentAmount = 0.0.obs;
  final scheduledTime = "".obs;
  final distance = "".obs;
  final arrivalTime = "12 min".obs;
  final clientNotes = "".obs;
  final attachmentName = "Attachment".obs;
  final attachmentImage = "".obs;

  final checklist = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['bookingId'] != null) {
      bookingId.value = args['bookingId'];
      fetchJobDetails();
    }
  }

  Future<void> fetchJobDetails() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return;

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
      final response = await http.get(
        Uri.parse("${ApiServices.artisan_booking_detail}${bookingId.value}/"),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final client = data['client'];
        if (client != null) {
          clientName.value = client['full_name'] ?? 'Client';
          clientRating.value = double.tryParse(client['avg_rating']?.toString() ?? '0.0') ?? 0.0;
          clientImage.value = ApiServices.formatImageUrl(client['profile_picture']);
        }
        clientAddress.value = data['full_address'] ?? '';
        serviceName.value = data['service_name'] ?? '';
        paymentAmount.value = double.tryParse(data['total_amount']?.toString() ?? '0.0') ?? 0.0;
        
        String date = data['scheduled_date'] ?? '';
        String time = data['scheduled_time'] ?? '';
        scheduledTime.value = "$date $time".trim();
        
        clientNotes.value = data['additional_notes'] ?? 'No notes provided';
        
        if (data['image'] != null && data['image']['image'] != null) {
          attachmentImage.value = ApiServices.formatImageUrl(data['image']['image']);
          attachmentName.value = "Job Image Attachment";
        }

        if (data['checklist_items'] != null) {
           checklist.assignAll((data['checklist_items'] as List).map((e) => {
             'title': e['label'],
             'checked': e['is_done'],
             'id': e['id'],
           }).toList());
        }
      }
    } catch (e) {
      print("Error fetching job details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(String status, {String note = ""}) async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return;

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
      final String url = "${ApiServices.artisan_update_status}${bookingId.value}/status/";

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          "new_status": status,
          "note": "",
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Status updated to $status");
        fetchJobDetails();
      } else {
        print("ERROR: Status update failed. Body: ${response.body}");
        Get.snackbar("Error", "Update failed (${response.statusCode}): ${response.body}");
      }
    } catch (e) {
      print("Error updating status: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleCheck(int index) {
    checklist[index]['checked'] = !checklist[index]['checked'];
    checklist.refresh();
  }

  void startNavigation() {
    updateStatus("on_way");
    Get.toNamed(Routes.WORKER_NAVIGATION, arguments: {'bookingId': bookingId.value});
  }

  void viewAttachment() {
    if (attachmentImage.value.isNotEmpty) {
      Get.to(() => WorkerImageView(imagePath: attachmentImage.value));
    } else {
      Get.snackbar("Error", "No attachment found");
    }
  }

  Future<void> downloadAttachment() async {
    if (attachmentImage.value.isEmpty) {
      Get.snackbar("Error", "No attachment to download");
      return;
    }

    try {
      Get.snackbar(
        "Download", 
        "Download started...", 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primary.withOpacity(0.1),
      );
      
      final response = await http.get(Uri.parse(attachmentImage.value));
      
      if (response.statusCode == 200) {
        await Future.delayed(const Duration(seconds: 1));
        Get.snackbar(
          "Success", 
          "File saved to downloads", 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
        );
      } else {
        Get.snackbar("Error", "Failed to reach file server");
      }
    } catch (e) {
      print("Download error: $e");
      Get.snackbar("Error", "Could not complete download");
    }
  }

  void callClient() {
    // Logic for URL launcher or Phone call
  }

  void chatClient() => Get.toNamed(Routes.CHAT, arguments: {'bookingId': bookingId.value});

  void iveArrived() {
    updateStatus("arrived");
    Get.dialog(const StartWorkDialog());
  }

  void reportIssue() => Get.toNamed(Routes.REPORT_ISSUE, arguments: {'bookingId': bookingId.value});

  Future<void> completeJob() async {
    await updateStatus("completed");
    Get.dialog(
      const SuccessDialog(
        message: "Job completed successfully!",
      ),
      barrierDismissible: false,
    );
    await Future.delayed(const Duration(milliseconds: 2000));
    Get.offAllNamed(Routes.worker_deshbord_user);
  }

  void showCancellationDialog() {}

  void confirmCancellation() {
    updateStatus("cancelled");
    Get.back();
    Get.back();
  }
}