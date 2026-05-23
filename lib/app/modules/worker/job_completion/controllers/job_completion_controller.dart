import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';

import '../../../../core/Services/api_services.dart';
import '../../../../core/components/success_dialog.dart';
import '../../../../core/routes/app_routes.dart';

class JobCompletionController extends GetxController {
  final signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: const Color(0xFF0F172A),
    exportBackgroundColor: Colors.white,
  );

  final bookingId = "".obs;
  final newItemController = TextEditingController();

  // States
  final isLoading = false.obs;
  final isSignatureEmpty = true.obs;

  // Mock data
  final jobTitle = "Pipe Leak Repair".obs;
  final clientName = "Jennifer Martinez".obs;
  final jobDate = "Today".obs;
  final jobPrice = 75.00.obs;

  final checklist = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    
    final args = Get.arguments;
    if (args != null) {
      if (args['bookingId'] != null) bookingId.value = args['bookingId'].toString();
      if (args['jobTitle'] != null) jobTitle.value = args['jobTitle'];
      if (args['clientName'] != null) clientName.value = args['clientName'];
      if (args['jobDate'] != null) jobDate.value = args['jobDate'];
      if (args['jobPrice'] != null) jobPrice.value = args['jobPrice'];
      
      final tasks = args['tasks'];
      if (tasks != null && tasks is List && tasks.isNotEmpty) {
        checklist.assignAll(tasks.map((t) => {
          'id': '',
          'title': t.toString(),
          'checked': true,
          'order': 1,
        }).toList());
      }
    }

    fetchChecklist();

    // Listen to signature changes
    signatureController.addListener(() {
      if (signatureController.isEmpty != isSignatureEmpty.value) {
        isSignatureEmpty.value = signatureController.isEmpty;
      }
    });
  }

  Future<void> fetchChecklist() async {
    if (bookingId.value.isEmpty) return;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return;

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
      final String url = "${ApiServices.artisan_booking_detail}${bookingId.value}/";

      final response = await http.get(
        Uri.parse(url),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Authorization': 'Bearer $cleanToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['checklist_items'] != null) {
          checklist.assignAll((data['checklist_items'] as List).map((e) => {
            'id': e['id']?.toString() ?? '',
            'title': e['label'] ?? '',
            'checked': e['is_done'] == true,
            'order': e['order'] ?? 1,
          }).toList());
        }
      }
    } catch (e) {
      print("Error fetching job completion checklist: $e");
    }
  }

  Future<void> addChecklistItem(String label) async {
    if (label.trim().isEmpty || bookingId.value.isEmpty) return;
    try {
      isLoading.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return;

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
      final String url = "${ApiServices.baseurl}/api/bookings/artisan/${bookingId.value}/checklist/";

      final response = await http.post(
        Uri.parse(url),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Authorization': 'Bearer $cleanToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'label': label.trim(),
          'is_done': false,
          'order': checklist.length + 1,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success".tr, "Checklist item added".tr,
            backgroundColor: const Color(0xFF4CAE79),
            colorText: Colors.white);
        fetchChecklist();
      } else {
        Get.snackbar("Error".tr, "Failed to add checklist item: ${response.body}".tr);
      }
    } catch (e) {
      print("Error adding checklist item: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleCheck(int index) async {
    final item = checklist[index];
    final String itemId = item['id'] ?? '';
    if (itemId.isEmpty || bookingId.value.isEmpty) return;

    final bool newChecked = !item['checked'];
    checklist[index]['checked'] = newChecked;
    checklist.refresh();

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return;

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
      final String url = "${ApiServices.baseurl}/api/bookings/artisan/${bookingId.value}/checklist/$itemId/";

      final response = await http.patch(
        Uri.parse(url),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Authorization': 'Bearer $cleanToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'label': item['title'],
          'is_done': newChecked,
          'order': item['order'] ?? (index + 1),
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        checklist[index]['checked'] = !newChecked;
        checklist.refresh();
        Get.snackbar("Error".tr, "Failed to update item status".tr);
      }
    } catch (e) {
      checklist[index]['checked'] = !newChecked;
      checklist.refresh();
      print("Error toggling checklist item: $e");
    }
  }

  void clearSignature() {
    signatureController.clear();
    isSignatureEmpty.value = true;
  }

  Future<void> completeJob() async {
    // 1. Validation check
    if (signatureController.isEmpty) {
      Get.snackbar("Signature Required".tr, "Please get the client's signature before completing the job.".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
      );
      return;
    }

    final signatureBytes = await signatureController.toPngBytes();
    if (signatureBytes == null) {
      Get.snackbar("Error".tr, "Failed to capture signature image.".tr);
      return;
    }

    isLoading.value = true;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return;

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
      final String url = "${ApiServices.artisan_update_status}${bookingId.value}/status/";

      print("DEBUG: Completion - Updating status to completed via POST to $url");

      final response = await http.post(
        Uri.parse(url),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Authorization': 'Bearer $cleanToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          "new_status": "completed",
          "note": "Job completed and signed",
        }),
      ).timeout(const Duration(seconds: 15));

      print("DEBUG: Completion Response: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final sigUrl = "${ApiServices.artisan_upload_signature}${bookingId.value}/signature/";
        final sigRequest = http.MultipartRequest('POST', Uri.parse(sigUrl));
        sigRequest.headers['Authorization'] = 'Bearer $cleanToken';
        sigRequest.files.add(http.MultipartFile.fromBytes(
          'signature',
          signatureBytes,
          filename: 'signature.png',
        ));
        
        final sigResponse = await sigRequest.send();
        print("DEBUG: Signature Upload Response: ${sigResponse.statusCode}");

        if (sigResponse.statusCode == 200 || sigResponse.statusCode == 201) {
          Get.snackbar("Success".tr, "Job completed and signature uploaded successfully!".tr,
            backgroundColor: const Color(0xFF4CAE79),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
          );

          await Future.delayed(const Duration(milliseconds: 1500));
          Get.offAllNamed(Routes.WORKER_ACTIVE_JOB, arguments: {'bookingId': bookingId.value});
        } else {
          Get.snackbar("Warning".tr, "Job marked as completed, but signature upload failed.".tr,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          await Future.delayed(const Duration(milliseconds: 1500));
          Get.offAllNamed(Routes.WORKER_ACTIVE_JOB, arguments: {'bookingId': bookingId.value});
        }
      } else {
        Get.snackbar("Error".tr, "Failed to complete job: ${response.statusCode}".tr);
      }

    } catch (e) {
      print("Error completing job: $e");
      Get.snackbar("Error".tr, "Something went wrong. Please try again.".tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    signatureController.dispose();
    newItemController.dispose();
    super.onClose();
  }
}

