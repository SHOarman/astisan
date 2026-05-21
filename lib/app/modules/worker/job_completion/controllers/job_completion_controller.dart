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
    
    final args = Get.arguments;
    if (args != null) {
      if (args['jobTitle'] != null) jobTitle.value = args['jobTitle'];
      if (args['clientName'] != null) clientName.value = args['clientName'];
      if (args['jobDate'] != null) jobDate.value = args['jobDate'];
      if (args['jobPrice'] != null) jobPrice.value = args['jobPrice'];
      
      final tasks = args['tasks'];
      if (tasks != null && tasks is List && tasks.isNotEmpty) {
        checklist.assignAll(tasks.map((t) => {
          'title': t.toString(),
          'checked': true,
        }).toList());
      }
    }

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

    final signatureBytes = await signatureController.toPngBytes();
    if (signatureBytes == null) {
      Get.snackbar("Error", "Failed to capture signature image.");
      return;
    }

    final args = Get.arguments;
    final bookingId = args != null ? args['bookingId'] : "";

    isLoading.value = true;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return;

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
      final String url = "${ApiServices.artisan_update_status}$bookingId/status/";

      print("DEBUG: Completion - Updating status to completed via POST to $url");

      final response = await http.post(
        Uri.parse(url),
        headers: {
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
        // Now upload the signature
        final sigUrl = "${ApiServices.artisan_upload_signature}$bookingId/signature/";
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
          Get.snackbar(
            "Success",
            "Job completed and signature uploaded successfully!",
            backgroundColor: const Color(0xFF4CAE79),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
          );

          await Future.delayed(const Duration(milliseconds: 1500));
          Get.offAllNamed(Routes.worker_deshbord_user);
        } else {
          Get.snackbar(
            "Warning",
            "Job marked as completed, but signature upload failed.",
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          await Future.delayed(const Duration(milliseconds: 1500));
          Get.offAllNamed(Routes.worker_deshbord_user);
        }
      } else {
        Get.snackbar("Error", "Failed to complete job: ${response.statusCode}");
      }

    } catch (e) {
      print("Error completing job: $e");
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
