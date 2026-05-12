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

class FindingArtisanController extends GetxController {
  final isFound = false.obs;
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
        // Fallback for demo if no service context
        await Future.delayed(const Duration(seconds: 3));
        isFound.value = true;
        return;
      }

      final pos = locationController.currentPosition.value;
      String url = "${ApiServices.baseurl}/api/services/client/services/$serviceId/nearby-artisans/";
      Map<String, String> queryParams = {'radius_km': '15'};
      
      if (pos != null) {
        queryParams['lat'] = pos.latitude.toString();
        queryParams['lng'] = pos.longitude.toString();
      }

      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.trim().replaceAll('"', '');

      // Simulate a bit of searching time for better UX
      await Future.delayed(const Duration(seconds: 2));

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> dataList = [];
        if (decodedData is List) {
          dataList = decodedData;
        } else if (decodedData is Map) {
          dataList = decodedData['results'] ?? [];
        }

        if (dataList.isNotEmpty) {
          final best = dataList.first;
          final profile = best['artisan_profile'] ?? {};
          
          foundArtisan.value = {
            'id': best['id'],
            'name': best['full_name'] ?? 'Artisan',
            'role': profile['occupation'] ?? service['title'] ?? 'Professional',
            'avatar': ApiServices.formatImageUrl(best['profile_picture']?.toString()),
            'distance': best['distance_km'] != null ? '${best['distance_km']} km' : 'Nearby',
            'rating': profile['average_rating']?.toString() ?? '4.9',
          };
          
          isFound.value = true;
          return;
        }
      }
    } catch (e) {
      print("Error finding artisan: $e");
    }

    // Final fallback if nothing found
    await Future.delayed(const Duration(seconds: 1));
    isFound.value = true;
  }

  void trackArtisan() {
    // Pass the found artisan to the confirm/history flow
    Get.toNamed(Routes.CONFIRM_BOOKING, arguments: {
      'service': Get.arguments['service'],
      'artisan': foundArtisan.value,
      'image_path': Get.arguments['image'],
    });
  }
}

