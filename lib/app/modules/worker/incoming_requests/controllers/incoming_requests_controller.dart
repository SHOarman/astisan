import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../core/Services/api_services.dart';
import '../../../../core/routes/app_routes.dart';

class IncomingRequestsController extends GetxController {
  final requests = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isVerified = true.obs;

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

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');

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

        // Update verification status
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
      print("Error fetching requests: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptRequest(Map<String, dynamic> req) async {
    await _updateBookingStatus(req, 'confirmed');
  }

  Future<void> declineRequest(Map<String, dynamic> req) async {
    await _updateBookingStatus(req, 'cancelled');
  }

  Future<void> _updateBookingStatus(Map<String, dynamic> req, String status) async {
    final String id = req['id']?.toString() ?? '';
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null || token.isEmpty) return;

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
      final String url = "${ApiServices.artisan_update_status}$id/status/";

      final Map<String, dynamic> payload = {
        'new_status': status,
        'note': ''
      };

      print("DEBUG: Status Update Request");
      print("DEBUG: URL: $url");
      print("DEBUG: Payload: $payload");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(payload),
      ).timeout(const Duration(seconds: 15));

      print("DEBUG: Status Update Response Code: ${response.statusCode}");
      print("DEBUG: Status Update Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Booking ${status == 'confirmed' ? 'Accepted' : 'Declined'} successfully',
          snackPosition: SnackPosition.BOTTOM
        );

        await fetchRequests();

        if (status == 'confirmed') {
          Get.toNamed(Routes.WORKER_JOB_DETAILS, arguments: {
            'bookingId': id,
            'initialData': req,
          });
        }
      }
 else {
        print("ERROR: Status update failed. Response: ${response.body}");
        Get.snackbar('Error', 'Update failed (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print("Error in status update: $e");
      Get.snackbar('Error', 'Connection error or timeout');
    } finally {
      isLoading.value = false;
    }
  }
}
