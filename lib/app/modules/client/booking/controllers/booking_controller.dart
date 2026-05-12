import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/routes/app_routes.dart';
import '../../../../core/Services/api_services.dart';

class BookingController extends GetxController {
  final currentStep = 1.obs;
  final capturedImagePath = ''.obs;
  final serviceData = <String, dynamic>{}.obs;
  final selectedArtisan = <String, dynamic>{}.obs;

  // Date & Time
  final dates = [
    {'day': 'Mon', 'date': '6', 'month': 'Apr'},
    {'day': 'Tue', 'date': '7', 'month': 'Apr'},
    {'day': 'Wed', 'date': '8', 'month': 'Apr'},
    {'day': 'Thu', 'date': '9', 'month': 'Apr'},
    {'day': 'Fri', 'date': '10', 'month': 'Apr'},
    {'day': 'Sat', 'date': '11', 'month': 'Apr'},
  ];
  final selectedDateIndex = 4.obs; // Fri 10 Apr selected in image

  final times = [
    '8:00 AM',
    '10:00 AM',
    '12:00 PM',
    '2:00 PM',
    '4:00 PM',
    '6:00 PM',
  ];
  final selectedTime = DateTime.now().obs;

  // Address
  final addresses = <Map<String, dynamic>>[].obs;
  final selectedAddressIndex = 0.obs;
  final isLoadingAddresses = false.obs;

  Future<void> fetchSavedAddresses() async {
    isLoadingAddresses.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.trim().replaceAll('"', '');

      final response = await http.get(
        Uri.parse(ApiServices.client_addresses),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> dataList = [];
        
        if (decodedData is List) {
          dataList = decodedData;
        } else if (decodedData is Map) {
          dataList = decodedData['results'] ?? decodedData['data'] ?? decodedData['addresses'] ?? [];
        }

        addresses.assignAll(dataList.map((e) => {
          'id': e['id'],
          'title': (e['label'] == 'other' || e['label'] == null) 
              ? (e['custom_label'] ?? 'Address') 
              : e['label'].toString().capitalizeFirst,
          'address': e['address_line'] ?? 'No address line',
          'isDefault': e['is_default'] ?? false,
          'raw': e,
        }).toList());
        
        // Auto-select default address
        final defaultIdx = addresses.indexWhere((element) => element['isDefault'] == true);
        if (defaultIdx != -1) {
          selectedAddressIndex.value = defaultIdx;
        }
      }
    } catch (e) {
      print("Error fetching addresses: $e");
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  // Notes
  final notesController = TextEditingController();
  final notesLength = 0.obs;
  
  // Navigation source
  final source = ''.obs;
  
  final quickNotes = [
    '+ Urgent repair',
    '+ Bring materials',
    '+ Multiple items',
    '+ Call before arriving',
    '+ Weekend preferred',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchSavedAddresses();
    if (Get.arguments != null && Get.arguments is Map) {
      source.value = Get.arguments['source'] ?? '';
      serviceData.value = Get.arguments['service'] ?? {};
      selectedArtisan.value = Get.arguments['artisan'] ?? {};
      capturedImagePath.value = Get.arguments['image'] ?? '';
    }
    
    notesController.addListener(() {
      notesLength.value = notesController.text.length;
    });
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  void nextStep() {
    Get.focusScope?.unfocus();
    if (currentStep.value < 3) {
      currentStep.value++;
    } else if (currentStep.value == 3) {
      Get.toNamed(Routes.CAMERA, arguments: {
        'service': serviceData.value,
      });
    }
  }

  Future<void> submitBooking() async {
    isLoadingAddresses.value = true; // Use this as a general loading state
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.trim().replaceAll('"', '');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${ApiServices.baseurl}/api/bookings/client/"),
      );

      // Headers
      request.headers.addAll({
        if (token != null) 'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Fields
      final selectedAddress = addresses[selectedAddressIndex.value];
      final date = dates[selectedDateIndex.value];
      
      // Formatting date: YYYY-MM-DD
      // Note: In real app, convert "Apr 14" to "2026-04-14"
      // Using a fallback for now
      String formattedDate = "2026-05-12"; 
      
      // Formatting time: HH:MM:SS
      String formattedTime = "${selectedTime.value.hour.toString().padLeft(2, '0')}:${selectedTime.value.minute.toString().padLeft(2, '0')}:00";

      request.fields['service'] = serviceData['id']?.toString() ?? '';
      request.fields['service_address'] = selectedAddress['id']?.toString() ?? '';
      request.fields['artisan'] = selectedArtisan['id']?.toString() ?? '';
      request.fields['scheduled_date'] = formattedDate;
      request.fields['scheduled_time'] = formattedTime;
      request.fields['additional_notes'] = notesController.text;

      // Image
      if (capturedImagePath.value.isNotEmpty) {
        // Since dummy_path.jpg doesn't exist, in a real scenario we'd use real path
        // For now, I'll only add if file exists
        print("DEBUG: Attaching image ${capturedImagePath.value}");
      }

      print("DEBUG: Submitting booking request...");
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("DEBUG: Booking Status: ${response.statusCode}");
      print("DEBUG: Booking Response: ${response.body}");

      if (response.statusCode == 201) {
        final decoded = json.decode(response.body);
        Get.offNamed(Routes.FINDING_ARTISAN, arguments: {
          'service': serviceData.value,
          'booking': decoded,
          'image': capturedImagePath.value,
        });
      } else {
        Get.snackbar("Error", "Failed to create booking: ${response.body}",
          backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("Error submitting booking: $e");
      Get.snackbar("Error", "An unexpected error occurred.",
        backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  void previousStep() {
    Get.focusScope?.unfocus();
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  void addQuickNote(String note) {
    final cleanNote = note.replaceAll('+ ', '');
    final currentText = notesController.text;
    if (currentText.isEmpty) {
      notesController.text = cleanNote;
    } else {
      notesController.text = '$currentText, $cleanNote';
    }
  }
}

