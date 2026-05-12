import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';

import '../../../../core/global_controllers/location_controller.dart';

class NearbyArtisansController extends GetxController {
  final locationController = Get.find<LocationController>();
  final serviceData = <String, dynamic>{}.obs;
  final artisans = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      serviceData.value = Map<String, dynamic>.from(Get.arguments['service'] ?? {});
      fetchNearbyArtisans();
    }
  }

  String get serviceName => serviceData['title'] ?? 'Service';
  String get serviceId => serviceData['id']?.toString() ?? '';

  Future<void> fetchNearbyArtisans() async {
    if (serviceId.isEmpty) return;
    
    isLoading.value = true;
    try {
      final pos = locationController.currentPosition.value;
      String url = "${ApiServices.baseurl}/api/services/client/services/$serviceId/nearby-artisans/";
      
      // Add location parameters for 5km radius filtering
      Map<String, String> queryParams = {
        'radius_km': '5',
      };
      
      if (pos != null) {
        queryParams['lat'] = pos.latitude.toString();
        queryParams['lng'] = pos.longitude.toString();
        print("DEBUG: Fetching artisans near User (${pos.latitude}, ${pos.longitude}) within 5km");
      } else {
        print("DEBUG: Location not detected, fetching general artisans within 5km");
      }

      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.trim().replaceAll('"', '');

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

        // Filter and map: Only show verified artisans as requested
        final mappedArtisans = dataList.where((e) {
          final profile = e['artisan_profile'];
          if (profile == null) return false;
          // Return true only if verified
          return profile['is_verified'] == true || profile['verification_status'] == 'verified';
        }).map((e) {
          final profile = e['artisan_profile'] ?? {};
          final double dist = double.tryParse(e['distance_km']?.toString() ?? '0.0') ?? 0.0;
          
          return {
            'id': e['id'],
            'full_name': e['full_name'] ?? 'Artisan',
            'profile_picture': ApiServices.formatImageUrl(e['profile_picture']?.toString()),
            'occupation': profile['occupation'] ?? serviceName,
            'rating': double.tryParse(profile['average_rating']?.toString() ?? '0') ?? 0.0,
            'review_count': profile['total_reviews'] ?? 0,
            'distance': dist < 1.5 ? 'Nearby' : '${dist.toStringAsFixed(1)} km',
            'hourly_rate': profile['hourly_rate']?.toString() ?? '0.00',
            'is_verified': profile['is_verified'] ?? false,
          };
        }).toList();

        artisans.assignAll(mappedArtisans);
        print("DEBUG: Loaded ${artisans.length} verified artisans");
      }
    } catch (e) {
      print("Error fetching nearby artisans: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
