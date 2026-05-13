import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../core/Services/api_services.dart';
import '../../../../core/routes/app_routes.dart';

class IncomingRequestsController extends GetxController {
  final requests = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isVerified = true.obs; // Default true to prevent flicker

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null || token.isEmpty) return;

      final String cleanToken = token.toString().trim().replaceAll('"', '').replaceAll('Bearer ', '');

      final response = await http.get(
        Uri.parse(ApiServices.artisan_incoming_bookings),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = (data is List) ? data : (data['results'] ?? []);
        
        requests.assignAll(results.map((e) => e as Map<String, dynamic>).toList());

        // Also fetch verification status
        final profileResponse = await http.get(
          Uri.parse(ApiServices.artisan_profile),
          headers: {'Authorization': 'Bearer $cleanToken', 'Accept': 'application/json'},
        );
        if (profileResponse.statusCode == 200) {
          final profileData = json.decode(profileResponse.body);
          if (profileData['artisan_profile'] != null) {
            isVerified.value = profileData['artisan_profile']['is_verified'] ?? false;
          }
        }
      }
    } catch (e) {
      print("Error fetching incoming requests: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptRequest(String bookingId) async {
    await _updateBookingStatus(bookingId, 'confirmed');
  }

  Future<void> declineRequest(String bookingId) async {
    await _updateBookingStatus(bookingId, 'cancelled');
  }

  Future<void> _updateBookingStatus(String bookingId, String status) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null || token.isEmpty) return;
      final String cleanToken = token.toString().trim().replaceAll('"', '').replaceAll('Bearer ', '');

      // The status update URL usually includes the booking ID
      final String url = "${ApiServices.artisan_update_status}$bookingId/status/";
      
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'status': status}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Booking $status successfully');
        fetchRequests(); // Refresh list
        if (status == 'confirmed') {
           Get.toNamed(Routes.WORKER_JOB_DETAILS, arguments: {'bookingId': bookingId});
        }
      } else {
        Get.snackbar('Error', 'Failed to update status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection failed');
    }
  }
}

