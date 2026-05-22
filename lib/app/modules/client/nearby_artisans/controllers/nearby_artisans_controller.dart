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
    }
    fetchNearbyArtisans();
  }

  String get serviceName => serviceData['title'] ?? 'Service';
  String get serviceId => serviceData['id']?.toString() ?? '';

  Future<void> fetchNearbyArtisans() async {
    isLoading.value = true;
    try {
      final pos = locationController.currentPosition.value;
      String url = serviceId.isEmpty 
          ? "${ApiServices.baseurl}/api/services/client/services/recommended-artisans/"
          : "${ApiServices.baseurl}/api/services/client/services/$serviceId/nearby-artisans/";
      
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
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
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
          final isVerifiedRoot = e['is_verified'] == true;
          if (profile == null) return isVerifiedRoot;
          return isVerifiedRoot || profile['is_verified'] == true || profile['verification_status'] == 'verified';
        }).map((e) {
          final profile = e['artisan_profile'] ?? {};
          final double dist = double.tryParse(e['distance_km']?.toString() ?? '0.0') ?? 0.0;
          
          String? extractedServiceId;
          String? extractedServiceName;
          String? extractedServicePrice;

          if (e['services'] != null && e['services'] is List && e['services'].isNotEmpty) {
            final firstService = e['services'][0];
            extractedServiceId = firstService['service_id']?.toString() ?? firstService['service']?.toString() ?? firstService['id']?.toString();
            extractedServiceName = firstService['name']?.toString();
            extractedServicePrice = firstService['price']?.toString();
          }
          if (extractedServiceId == null && profile['services'] != null && profile['services'] is List && profile['services'].isNotEmpty) {
            final firstProfileService = profile['services'][0];
            extractedServiceId = firstProfileService['service_id']?.toString() ?? firstProfileService['service']?.toString() ?? firstProfileService['id']?.toString();
            extractedServiceName ??= firstProfileService['name']?.toString();
            extractedServicePrice ??= firstProfileService['price']?.toString();
          }

          // Use extracted values, fallback to route arguments or artisan root fields
          final finalOccupation = extractedServiceName ?? profile['occupation'] ?? e['occupation'] ?? serviceName;
          final finalPrice = _getValidPrice(e, profile, extractedServicePrice);

          return {
            'id': e['id'] ?? e['artisan_id'],
            'service_id': extractedServiceId,
            'service_name': extractedServiceName ?? finalOccupation,
            'full_name': e['full_name'] ?? 'Artisan',
            'profile_picture': ApiServices.formatImageUrl(e['profile_picture']?.toString()),
            'occupation': finalOccupation,
            'rating': double.tryParse(profile['average_rating']?.toString() ?? e['avg_rating']?.toString() ?? '0') ?? 0.0,
            'review_count': profile['total_reviews'] ?? e['review_count'] ?? 0,
            'distance': dist < 1.0 ? 'Nearby' : '${dist.toStringAsFixed(1)} km',
            'hourly_rate': finalPrice,
            'is_verified': true,
            'bio': profile['bio'] ?? e['bio'],
            'experience': profile['experience_years'] ?? profile['years_of_experience'] ?? profile['experience'] ?? e['experience'],
            'skills': profile['skills'] ?? e['skills'],
            'service_areas': profile['service_areas'] ?? e['service_areas'],
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

  String _getValidPrice(Map<String, dynamic> e, Map<String, dynamic> profile, String? extractedServicePrice) {
    final possibleValues = [
      extractedServicePrice,
      e['effective_price'],
      e['price_override'],
      e['hourly_rate'],
      e['base_price'],
      profile['effective_price'],
      profile['price_override'],
      profile['hourly_rate'],
      profile['base_price'],
    ];

    for (var val in possibleValues) {
      if (val != null) {
        String strVal = val.toString().trim();
        if (strVal.isNotEmpty && strVal != '0' && strVal != '0.0' && strVal != '0.00') {
          return strVal;
        }
      }
    }
    return '0';
  }
}
