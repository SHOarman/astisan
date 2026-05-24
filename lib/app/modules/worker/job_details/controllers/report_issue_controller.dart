import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/Services/api_services.dart';
import '../../../../core/components/success_dialog.dart';
import '../views/report_problem_dialog.dart';

class ReportIssueController extends GetxController {
  final issueTypeController = TextEditingController();
  final descriptionController = TextEditingController();

  final bookingId = "".obs;
  final serviceName = "".obs;

  final issueTypes = ["Broken Equipment", "Safety Concern", "Client Disagreement", "Schedule Conflict", "Other"].obs;
  final selectedIssueType = "".obs;

  final urgencyLevel = "Medium".obs; // Low, Medium, High

  final characterCount = 0.obs;

  // Attached images/documents
  final attachedFiles = <XFile>[].obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      if (args['bookingId'] != null) {
        bookingId.value = args['bookingId'].toString();
      }
      if (args['serviceName'] != null) {
        serviceName.value = args['serviceName'].toString();
      }
    }
    descriptionController.addListener(() {
      characterCount.value = descriptionController.text.length;
    });
  }

  void setUrgency(String level) {
    urgencyLevel.value = level;
  }

  void selectIssue(String? value) {
    if (value != null) {
      selectedIssueType.value = value;
    }
  }

  String _mapIssueType(String selected) {
    switch (selected) {
      case "Broken Equipment":
        return "broken_equipment";
      case "Safety Concern":
        return "safety_concern";
      case "Client Disagreement":
        return "client_disagreement";
      case "Schedule Conflict":
        return "schedule_conflict";
      default:
        return "other";
    }
  }

  Future<void> pickImage() async {
    final source = await _showImageSourceDialog();
    if (source == null) return;
    try {
      final XFile? file = await _picker.pickImage(source: source, imageQuality: 80);
      if (file != null) {
        attachedFiles.add(file);
      }
    } catch (e) {
      Get.snackbar("Error".tr, "${'Could not pick image:'.tr} $e");
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return await Get.dialog<ImageSource>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Select Source"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text("Camera"),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text("Gallery"),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  void removeFile(int index) {
    if (index >= 0 && index < attachedFiles.length) {
      attachedFiles.removeAt(index);
    }
  }

  void submitReport() {
    if (selectedIssueType.isEmpty) {
      Get.snackbar("Error".tr, "Please select an issue type".tr, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar("Error".tr, "Please provide a description".tr, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    Get.dialog(
      ReportProblemDialog(
        onConfirm: () {
          Get.back(); // Close dialog
          _processSubmission();
        },
      ),
    );
  }

  Future<void> _processSubmission() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) {
        Get.back();
        Get.snackbar("Error".tr, "Authorization token not found".tr);
        return;
      }

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
      final String url = "${ApiServices.artisan_report_issue}${bookingId.value}/issues/";

      http.Response response;

      if (attachedFiles.isNotEmpty) {
        // Use multipart if there are attachments
        final request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers['Authorization'] = 'Bearer $cleanToken';
        request.headers['Accept'] = 'application/json';
        request.fields['issue_type'] = _mapIssueType(selectedIssueType.value);
        request.fields['description'] = descriptionController.text.trim();

        for (int i = 0; i < attachedFiles.length; i++) {
          final file = attachedFiles[i];
          request.files.add(await http.MultipartFile.fromPath(
            'attachments',
            file.path,
          ));
        }

        final streamed = await request.send();
        response = await http.Response.fromStream(streamed);
      } else {
        // Plain JSON if no attachments
        response = await http.post(
          Uri.parse(url),
          headers: { 'Accept-Language': ApiServices.currentLanguage, 
            'Authorization': 'Bearer $cleanToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({
            'issue_type': _mapIssueType(selectedIssueType.value),
            'description': descriptionController.text.trim(),
          }),
        );
      }

      Get.back(); // Dismiss loading

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.dialog(
          const SuccessDialog(
            message: "Your report has been sent to support for review.",
          ),
          barrierDismissible: false,
        );
        await Future.delayed(const Duration(milliseconds: 2000));
        Get.back(); // Success Dialog
        Get.back(); // Report screen
      } else {
        print("ReportIssue error ${response.statusCode}: ${response.body}");
        String errorMsg = "Failed (${response.statusCode})";
        try {
          final errData = json.decode(response.body);
          if (errData is Map) {
            errorMsg = errData.entries.map((e) => "${e.key}: ${e.value}").join(", ");
          }
        } catch (_) {
          errorMsg = response.body;
        }
        Get.snackbar("Error".tr, errorMsg.tr,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 6));
      }
    } catch (e) {
      Get.back(); // Dismiss loading
      print("Error reporting issue: $e");
      Get.snackbar("Error".tr, "Something went wrong. Please try again.".tr);
    }
  }

  @override
  void onClose() {
    descriptionController.dispose();
    issueTypeController.dispose();
    super.onClose();
  }
}
