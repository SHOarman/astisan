import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

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

      final String cleanToken = token
          .trim()
          .replaceAll('"', '')
          .replaceAll('Bearer ', '');

      final response = await http
          .get(
            Uri.parse(ApiServices.artisan_incoming_bookings),
            headers: { 'Accept-Language': ApiServices.currentLanguage, 
              'Authorization': 'Bearer $cleanToken',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = (data is List)
            ? data
            : (data['results'] ?? []);

        final List<Map<String, dynamic>> processedRequests = [];

        for (var req in results) {
          final mapReq = req as Map<String, dynamic>;
          
          // Fallback: If backend sends full_address but misses lat/lng, geocode it!
          if (mapReq['address_lat'] == null && mapReq['full_address'] != null) {
             try {
                final locations = await locationFromAddress(mapReq['full_address'].toString());
                if (locations.isNotEmpty) {
                  mapReq['address_lat'] = locations.first.latitude.toString();
                  mapReq['address_lng'] = locations.first.longitude.toString();
                  print("DEBUG: Geocoded missing coordinates for ${mapReq['id']}: ${mapReq['address_lat']}, ${mapReq['address_lng']}");
                }
             } catch (e) {
                print("DEBUG: Could not geocode address ${mapReq['full_address']} - $e");
             }
          }
          processedRequests.add(mapReq);
        }

        requests.assignAll(processedRequests);

        // Update verification status
        final profileResponse = await http.get(
          Uri.parse(ApiServices.artisan_profile),
          headers: { 'Accept-Language': ApiServices.currentLanguage, 
            'Authorization': 'Bearer $cleanToken',
            'Accept': 'application/json',
          },
        );
        if (profileResponse.statusCode == 200) {
          final profileData = json.decode(profileResponse.body);
          if (profileData['artisan_profile'] != null) {
            isVerified.value =
                profileData['artisan_profile']['is_verified'] ?? false;
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
    await _updateBookingStatus(req, 'rejected');
  }

  Future<void> _updateBookingStatus(
    Map<String, dynamic> req,
    String status,
  ) async {
    final String id = req['id']?.toString() ?? '';
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null || token.isEmpty) return;

      final String cleanToken = token
          .trim()
          .replaceAll('"', '')
          .replaceAll('Bearer ', '');
      final String url = "${ApiServices.artisan_update_status}$id/status/";

      String currentStatus = status;
      // Rejection notes are often required in REST APIs to satisfy validation schemas.
      final String note =
          (currentStatus == 'rejected' ||
              currentStatus == 'cancelled' ||
              currentStatus == 'declined')
          ? 'Declined by artisan'
          : '';

      final Map<String, dynamic> payload = {
        'new_status': currentStatus,
        'note': note,
      };

      print("DEBUG: Status Update Request");
      print("DEBUG: URL: $url");
      print("DEBUG: Payload: $payload");

      var response = await http
          .post(
            Uri.parse(url),
            headers: { 'Accept-Language': ApiServices.currentLanguage, 
              'Authorization': 'Bearer $cleanToken',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(payload),
          )
          .timeout(const Duration(seconds: 15));

      print(
        "DEBUG: Status Update Response for '$currentStatus': ${response.statusCode} - ${response.body}",
      );

      // Cascade Fallback 1: If 'rejected' fails with 400 Bad Request, fall back and try 'cancelled'
      if (response.statusCode == 400 && currentStatus == 'rejected') {
        currentStatus = 'cancelled';
        payload['new_status'] = currentStatus;
        payload['note'] = 'Declined by artisan';

        print("DEBUG: Rejection failed. Trying fallback status 'cancelled'...");
        response = await http
            .post(
              Uri.parse(url),
              headers: { 'Accept-Language': ApiServices.currentLanguage, 
                'Authorization': 'Bearer $cleanToken',
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              body: json.encode(payload),
            )
            .timeout(const Duration(seconds: 15));

        print(
          "DEBUG: Status Update Response for 'cancelled': ${response.statusCode} - ${response.body}",
        );
      }

      // Cascade Fallback 2: If 'cancelled' also fails with 400, try 'declined'
      if (response.statusCode == 400 && currentStatus == 'cancelled') {
        currentStatus = 'declined';
        payload['new_status'] = currentStatus;
        payload['note'] = 'Declined by artisan';

        print(
          "DEBUG: Cancellation failed. Trying fallback status 'declined'...",
        );
        response = await http
            .post(
              Uri.parse(url),
              headers: { 'Accept-Language': ApiServices.currentLanguage, 
                'Authorization': 'Bearer $cleanToken',
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              body: json.encode(payload),
            )
            .timeout(const Duration(seconds: 15));

        print(
          "DEBUG: Status Update Response for 'declined': ${response.statusCode} - ${response.body}",
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Booking ${status == 'confirmed' ? 'Accepted' : 'Declined'} successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        await fetchRequests();

        if (status == 'confirmed') {
          Get.toNamed(
            Routes.WORKER_JOB_DETAILS,
            arguments: {'bookingId': id, 'initialData': req},
          );
        }
      } else {
        print("ERROR: Status update failed. Response: ${response.body}");
        Get.snackbar(
          'Error',
          'Update failed (${response.statusCode}): ${response.body}',
        );
      }
    } catch (e) {
      print("Error in status update: $e");
      Get.snackbar('Error', 'Connection error or timeout');
    } finally {
      isLoading.value = false;
    }
  }
}
