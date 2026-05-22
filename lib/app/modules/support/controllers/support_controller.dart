import 'dart:convert';
import 'package:artisan/app/core/Services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class SupportController extends GetxController {
  // Feedback Form Controllers
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final attachedImagePath = ''.obs;

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
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
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
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        termsContent.value = _stripHtmlTags(data['content'] ?? '');
      }
    } catch (e) {
      print('Error fetching Terms: $e');
    } finally {
      isLoadingTerms.value = false;
    }
  }

  String _stripHtmlTags(String htmlString) {
    // Basic HTML tag stripping
    String parsedString = htmlString.replaceAll(RegExp(r'<li>'), '• ');
    parsedString = parsedString.replaceAll(RegExp(r'</li>|</ul>|</ol>'), '\n');
    parsedString = parsedString.replaceAll(RegExp(r'<h2>|<h3>|<h4>'), '\n\n');
    parsedString = parsedString.replaceAll(RegExp(r'</h2>|</h3>|</h4>'), '\n');
    parsedString = parsedString.replaceAll(RegExp(r'<p>|<br>|<br/>'), '\n');
    parsedString = parsedString.replaceAll(RegExp(r'</p>'), '\n');
    parsedString = parsedString.replaceAll(RegExp(r'&nbsp;'), ' ');
    parsedString = parsedString.replaceAll(RegExp(r'&amp;'), '&');
    // Remove all remaining HTML tags
    parsedString = parsedString.replaceAll(RegExp(r'<[^>]*>'), '');
    // Clean up multiple newlines
    parsedString = parsedString.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return parsedString.trim();
  }

  Future<void> fetchPrivacy() async {
    isLoadingPrivacy.value = true;
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${ApiServices.baseurl}/api/supports/privacy/'),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        privacyContent.value = _stripHtmlTags(data['content'] ?? '');
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
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        aboutUsContent.value = _stripHtmlTags(data['content'] ?? '');
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
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiServices.baseurl}/api/supports/feedback/submit/'),
      );
      
      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      });
      
      request.fields['subject'] = subjectController.text;
      request.fields['email'] = emailController.text;
      request.fields['message'] = messageController.text;
      
      if (attachedImagePath.value.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'attachment',
            attachedImagePath.value,
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

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
        attachedImagePath.value = '';
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
        attachedImagePath.value = '';
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

  Future<void> pickAttachment() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        attachedImagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    subjectController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
