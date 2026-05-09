import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/routes/app_routes.dart';
import '../../profile/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  
  final isLoading = false.obs;
  final profileImage = Rx<File?>(null);
  final profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token not found');
        return;
      }

      final response = await http.get(
        Uri.parse(ApiServices.client_profile),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("Fetch Profile in Edit Status: ${response.statusCode}");
      print("Fetch Profile in Edit Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        fullNameController.text = data['full_name'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phone'] ?? '';
        profileImageUrl.value = data['profile_picture'] ?? '';
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveChanges() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token not found');
        return;
      }

      // Documentation says PUT/PATCH with multipart/form-data
      var request = http.MultipartRequest('PATCH', Uri.parse(ApiServices.client_profile));
      
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Clean phone number (remove spaces, dashes, parentheses)
      String rawPhone = phoneController.text.trim();
      
      // Check if it starts with a country code (+)
      if (!rawPhone.startsWith('+')) {
        Get.snackbar(
          'Validation Error', 
          'Please enter your country code (e.g., +880)',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        isLoading.value = false;
        return;
      }

      String cleanPhone = rawPhone.replaceAll(RegExp(r'[^\d+]'), '');

      request.fields['full_name'] = fullNameController.text.trim();
      request.fields['phone'] = cleanPhone;

      if (profileImage.value != null) {
        print("Adding profile picture to request: ${profileImage.value!.path}");
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          profileImage.value!.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      print("Sending Update - Name: ${fullNameController.text.trim()}, Phone: $cleanPhone");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Update Profile Status: ${response.statusCode}");
      print("Update Profile Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success', 
          'Profile updated successfully',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
        
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().fetchProfile();
        }
        
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        String errorMsg = 'Failed to update profile';
        try {
          final data = json.decode(response.body);
          if (data is Map) {
            if (data.containsKey('message')) {
              errorMsg = data['message'];
            } else if (data.containsKey('detail')) {
              errorMsg = data['detail'];
            } else if (data.containsKey('phone')) {
              errorMsg = data['phone'] is List ? data['phone'][0] : data['phone'].toString();
            } else if (data.containsKey('errors')) {
              errorMsg = data['errors'].toString();
            } else {
              // Try to find any first error in the map
              errorMsg = data.values.first.toString();
            }
          } else {
            errorMsg = "Error: ${response.statusCode}";
          }
        } catch (e) {
          errorMsg = "Error: ${response.statusCode}";
        }
        Get.snackbar('Error', errorMsg);
      }
    } catch (e) {
      print("Error updating profile: $e");
      Get.snackbar('Error', 'Connection failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      profileImage.value = File(image.path);
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}

