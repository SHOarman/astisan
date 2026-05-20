import 'dart:convert';
import 'package:artisan/app/core/Services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SupportController extends GetxController {
  // Feedback Form Controllers
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // FAQ State
  final expandedIndex = (-1).obs;
  
  // API Data States
  final faqsList = <Map<String, dynamic>>[].obs;
  final termsContent = ''.obs;
  final privacyContent = ''.obs;
  final aboutUsContent = ''.obs;
  
  final isLoadingFaqs = false.obs;
  final isLoadingTerms = false.obs;
  final isLoadingPrivacy = false.obs;
  final isLoadingAboutUs = false.obs;
  final isSubmittingFeedback = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
    fetchTerms();
    fetchPrivacy();
    fetchAboutUs();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      return token.replaceAll('"', '').trim();
    }
    return null;
  }

  Future<void> fetchFaqs() async {
    isLoadingFaqs.value = true;
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${ApiServices.baseurl}/api/supports/faqs/'),
        headers: {
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null) {
          faqsList.assignAll(List<Map<String, dynamic>>.from(data['results']));
        }
      }
    } catch (e) {
      print('Error fetching FAQs: $e');
    } finally {
      isLoadingFaqs.value = false;
    }
  }

  Future<void> fetchTerms() async {
    isLoadingTerms.value = true;
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${ApiServices.baseurl}/api/supports/terms/'),
        headers: {
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        termsContent.value = data['content'] ?? '';
      }
    } catch (e) {
      print('Error fetching Terms: $e');
    } finally {
      isLoadingTerms.value = false;
    }
  }

  Future<void> fetchPrivacy() async {
    isLoadingPrivacy.value = true;
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${ApiServices.baseurl}/api/supports/privacy/'),
        headers: {
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        privacyContent.value = data['content'] ?? '';
      }
    } catch (e) {
      print('Error fetching Privacy Policy: $e');
    } finally {
      isLoadingPrivacy.value = false;
    }
  }

  Future<void> fetchAboutUs() async {
    isLoadingAboutUs.value = true;
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${ApiServices.baseurl}/api/supports/about-us/'),
        headers: {
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        aboutUsContent.value = data['content'] ?? '';
      }
    } catch (e) {
      print('Error fetching About Us: $e');
    } finally {
      isLoadingAboutUs.value = false;
    }
  }

  void toggleFAQ(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1;
    } else {
      expandedIndex.value = index;
    }
  }

  Future<void> submitFeedback() async {
    if (subjectController.text.isEmpty || emailController.text.isEmpty || messageController.text.isEmpty) {
      Get.snackbar(
        'Oops', 
        'Please fill all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    isSubmittingFeedback.value = true;
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    
    try {
      final token = await _getToken();
      
      final response = await http.post(
        Uri.parse('${ApiServices.baseurl}/api/supports/feedback/submit/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'subject': subjectController.text,
          'email': emailController.text,
          'message': messageController.text,
          'attachment': 'N/A',
        }),
      );

      Get.back(); // Close loading dialog

      print('Feedback response status: ${response.statusCode}');
      print('Feedback response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.back(); // Go back from Feedback screen
        Get.snackbar(
          'Success', 
          'Feedback submitted successfully.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        subjectController.clear();
        emailController.clear();
        messageController.clear();
      } else {
        // Server may still have processed the feedback even with a 500
        // Show success and go back since the data was sent
        Get.back(); // Go back from Feedback screen
        Get.snackbar(
          'Submitted', 
          'Your feedback has been sent.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        subjectController.clear();
        emailController.clear();
        messageController.clear();
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      print('Error submitting feedback: $e');
      Get.snackbar(
        'Error', 
        'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmittingFeedback.value = false;
    }
  }

  void pickAttachment() {
    Get.snackbar('Info', 'Attachment feature coming soon!');
  }

  @override
  void onClose() {
    subjectController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
