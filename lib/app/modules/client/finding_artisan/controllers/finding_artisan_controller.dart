import 'dart:convert';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/global_controllers/location_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../booking/controllers/booking_controller.dart';

class FindingArtisanController extends GetxController {
  final isFound = false.obs;
  final isSubmitting = false.obs;
  final foundArtisan = Rxn<Map<String, dynamic>>();
  final locationController = Get.find<LocationController>();

  @override
  void onInit() {
    super.onInit();
    
    // Check if we should skip the searching state (e.g., from Confirm Booking)
    if (Get.arguments != null && Get.arguments is Map && Get.arguments['skip_searching_state'] == true) {
      isFound.value = true;
      // If we skipped searching, we should have the artisan in arguments
      if (Get.arguments['artisan'] != null) {
        foundArtisan.value = Get.arguments['artisan'];
      }
    } else {
      fetchBestArtisan();
    }
  }

  Future<void> fetchBestArtisan() async {
    try {
      final service = Get.arguments != null ? Get.arguments['service'] : null;
      final String? serviceId = service?['id']?.toString();
      
      if (serviceId == null) {
        await Future.delayed(const Duration(seconds: 2));
        isFound.value = true;
        return;
      }

      final pos = locationController.currentPosition.value;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token')?.trim().replaceAll('"', '');

      // Step 1: Try finding within 15km
      bool found = await _searchArtisans(serviceId, 15, pos, token, service);
      
      // Step 2: If not found, try 30km
      if (!found) {
        found = await _searchArtisans(serviceId, 30, pos, token, service);
      }

      if (!found) {
        // Handle no artisans found case gracefully instead of hardcoded fallback
        foundArtisan.value = null;
      }
      
      isFound.value = true;
    } catch (e) {
      print("Error finding artisan: $e");
      isFound.value = true;
    }
  }

  Future<bool> _searchArtisans(String serviceId, int radius, dynamic pos, String? token, dynamic service) async {
    try {
      String url = "${ApiServices.baseurl}/api/services/client/services/$serviceId/nearby-artisans/";
      Map<String, String> queryParams = {'radius_km': radius.toString()};
      
      if (pos != null) {
        queryParams['lat'] = pos.latitude.toString();
        queryParams['lng'] = pos.longitude.toString();
      }

      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> dataList = (decodedData is Map) ? (decodedData['results'] ?? []) : (decodedData ?? []);

        if (dataList.isNotEmpty) {
          final best = dataList.first;
          final profile = best['artisan_profile'] ?? {};
          final double dist = double.tryParse(best['distance_km']?.toString() ?? '0.0') ?? 0.0;
          
          foundArtisan.value = {
            'id': best['id'],
            'name': best['full_name'] ?? 'Artisan',
            'role': profile['occupation'] ?? service?['title'] ?? 'Professional',
            'avatar': ApiServices.formatImageUrl(best['profile_picture']?.toString()),
            'distance': dist < 1.0 ? 'Nearby' : '${dist.toStringAsFixed(1)} km',
            'rating': best['avg_rating']?.toString() ?? profile['average_rating']?.toString() ?? '0.0',
            'reviews': best['review_count'] ?? profile['total_reviews'] ?? 0,
            'price': best['effective_price']?.toString() ?? profile['hourly_rate']?.toString() ?? '25',
          };
          return true;
        }
      }
    } catch (e) {
      print("Search at ${radius}km failed: $e");
    }
    return false;
  }

  void trackArtisan() async {
    try {
      isSubmitting.value = true;
      final bookingController = Get.find<BookingController>();
      bookingController.selectedArtisan.value = foundArtisan.value ?? {};
      await bookingController.submitBooking();
    } catch (e) {
      // If controller not found (e.g. direct navigation), use fallback navigation
      Get.toNamed(Routes.CONFIRM_BOOKING, arguments: {
        'service': Get.arguments != null ? Get.arguments['service'] : null,
        'artisan': foundArtisan.value,
        'image': Get.arguments != null ? Get.arguments['image'] : null,
        'skip_searching_state': true,
      });
    } finally {
      isSubmitting.value = false;
    }
  }
}

