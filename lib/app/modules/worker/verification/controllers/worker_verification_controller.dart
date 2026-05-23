import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';
import '../../account/controllers/worker_account_controller.dart';

class WorkerVerificationController extends GetxController {
  final currentStep = 0.obs;
  final pageController = PageController();
  final isLoading = false.obs;

  // Step 1: Document Selection
  final selectedDocType = 'ID Card'.obs; // 'ID Card' or 'Passport'

  // Step 2: Information
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final idNumberController = TextEditingController();

  // Step 3: Image
  final pickedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  @override
  void onClose() {
    pageController.dispose();
    nameController.dispose();
    dobController.dispose();
    idNumberController.dispose();
    super.onClose();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null) {
        pickedImage.value = File(image.path);
        nextStep(); // Move to preview/camera frame step
      }
    } catch (e) {
      Get.snackbar('Error'.tr, 'Failed to pick image'.tr);
    }
  }

  void nextStep() {
    if (currentStep.value < 4) {
      // Validate Step 2 before moving
      if (currentStep.value == 1) {
        if (nameController.text.isEmpty || dobController.text.isEmpty || idNumberController.text.isEmpty) {
          Get.snackbar('Required'.tr, 'Please fill all fields'.tr);
          return;
        }
      }
      
      currentStep.value++;
      if (currentStep.value < 4) {
        pageController.animateToPage(
          currentStep.value,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      Get.back();
    }
  }

  Future<void> submitVerification() async {
    if (pickedImage.value == null) {
      Get.snackbar('Error'.tr, 'Please capture or select a document image'.tr);
      return;
    }

    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.trim().replaceAll('"', '');

      print("DEBUG: Starting AI Verification...");
      var request = http.MultipartRequest('POST', Uri.parse(ApiServices.ai_verify));
      
      // Headers
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';

      // Fields
      request.fields['document_type'] = selectedDocType.value == 'ID Card' ? 'id_card' : 'passport';
      request.fields['full_name'] = nameController.text.trim();
      request.fields['document_number'] = idNumberController.text.trim();
      request.fields['date_of_birth'] = dobController.text.trim(); // Should be DD/MM/YYYY or YYYY-MM-DD

      // Image File
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        pickedImage.value!.path,
      ));

      var streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      var response = await http.Response.fromStream(streamedResponse);

      print("DEBUG: AI Verification Status: ${response.statusCode}");
      print("DEBUG: AI Verification Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['verified'] == true) {
          // Success
          showSuccess();
          // Refresh Profile Data
          if (Get.isRegistered<WorkerAccountController>()) {
            Get.find<WorkerAccountController>().fetchProfile();
          }
        } else {
          // AI Rejected or pending
          Get.snackbar('Verification Update', data['summary'] ?? 'Information mismatch found.');
          showFailure();
        }
      } else {
        Get.snackbar('Error'.tr, 'Server Error (${response.statusCode})'.tr);
        showFailure();
      }
    } catch (e) {
      print("DEBUG: Verification Exception: $e");
      Get.snackbar('Error'.tr, 'Connection failed. Please try again.'.tr);
      showFailure();
    } finally {
      isLoading.value = false;
    }
  }

  void previousStep() {
    if (currentStep.value > 0 && currentStep.value < 4) {
      currentStep.value--;
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  void showSuccess() {
    currentStep.value = 4;
  }

  void showFailure() {
    currentStep.value = 5;
  }

  void selectDocType(String type) {
    selectedDocType.value = type;
  }
}
