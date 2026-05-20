import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/global_controllers/location_controller.dart';
import '../../../../core/Services/api_services.dart';

class HomeController extends GetxController {
  final locationController = Get.find<LocationController>();
  final isLoadingPopular = false.obs;
  final isLoadingCategories = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchPopularServices();
    fetchRecommendedArtisans();
  }

  Future<void> fetchPopularServices() async {
    isLoadingPopular.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      
      // Robust token cleaning
      if (token != null) {
        token = token.trim().replaceAll('"', '');
        if (token.isEmpty || token.toLowerCase() == 'null') {
          token = null;
        }
      }
      
      final response = await http.get(
        Uri.parse(ApiServices.popular_services),
        headers: {
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> dataList = [];
        
        if (decodedData is List) {
          dataList = decodedData;
        } else if (decodedData is Map) {
          dataList = decodedData['results'] ?? [];
        }

        popularServices.assignAll(dataList.map((e) => {
          'id': e['id'],
          'title': e['name'] ?? 'Service',
          'image': ApiServices.formatImageUrl(e['image']?.toString()),
          'rating': double.tryParse(e['avg_rating'].toString()) ?? 0.0,
          'reviews': e['review_count'] ?? 0,
          'priceRange': '\$${e['price_range_min'] ?? '0'}-\$${e['price_range_max'] ?? '0'}',
        }).toList());
      }
    } catch (e) {
      print("Error fetching popular services: $e");
    } finally {
      isLoadingPopular.value = false;
    }
  }

  Future<void> fetchCategories() async {
    isLoadingCategories.value = true;
    try {
      final response = await http.get(
        Uri.parse(ApiServices.services_categories),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> dataList = [];
        
        if (decodedData is List) {
          dataList = decodedData;
        } else if (decodedData is Map) {
          dataList = decodedData['results'] ?? [];
        }

        // Map API categories to the format expected by the UI
        forYouCategories.assignAll(dataList.map((e) => {
          'id': e['id'],
          'title': e['name'] ?? 'Category',
          'icon': ApiServices.formatImageUrl(e['icon']?.toString()),
        }).toList());
      }
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      isLoadingCategories.value = false;
    }
  }
  
  final forYouCategories = <Map<String, dynamic>>[].obs;

  final popularServices = <Map<String, dynamic>>[].obs;

  final recommendedArtisans = <Map<String, dynamic>>[].obs;
  final isLoadingArtisans = false.obs;

  Future<void> fetchRecommendedArtisans() async {
    isLoadingArtisans.value = true;
    try {
      final pos = locationController.currentPosition.value;
      
      Map<String, String> queryParams = {
        'radius_km': '5',
      };
      
      if (pos != null) {
        queryParams['lat'] = pos.latitude.toString();
        queryParams['lng'] = pos.longitude.toString();
      }

      final uri = Uri.parse("${ApiServices.baseurl}/api/services/client/services/recommended-artisans/").replace(queryParameters: queryParams);
      
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.trim().replaceAll('"', '');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> dataList = [];
        if (decodedData is Map) {
          dataList = decodedData['results'] ?? [];
        } else if (decodedData is List) {
          dataList = decodedData;
        }

        if (dataList.isNotEmpty) {
          // Client-side sorting: Nearest first, then highest rating
          dataList.sort((a, b) {
            final double distA = double.tryParse(a['distance_km']?.toString() ?? '999') ?? 999;
            final double distB = double.tryParse(b['distance_km']?.toString() ?? '999') ?? 999;
            int distComp = distA.compareTo(distB);
            if (distComp != 0) return distComp;

            final double ratA = double.tryParse(a['avg_rating']?.toString() ?? '0') ?? 0;
            final double ratB = double.tryParse(b['avg_rating']?.toString() ?? '0') ?? 0;
            return ratB.compareTo(ratA); // Higher rating first
          });

          final verifiedList = dataList.where((e) {
            return e['is_verified'] == true || (e['artisan_profile'] != null && e['artisan_profile']['is_verified'] == true);
          }).toList();

          recommendedArtisans.assignAll(verifiedList.map((e) {
            final double dist = double.tryParse(e['distance_km']?.toString() ?? '0.0') ?? 0.0;
            
            String? extractedServiceId = e['service']?.toString() ?? e['service_id']?.toString() ?? e['category']?.toString();
            String? extractedServiceName;
            String? extractedServicePrice;

            if (e['services'] != null && e['services'] is List && e['services'].isNotEmpty) {
              final firstService = e['services'][0];
              extractedServiceId ??= firstService['service_id']?.toString() ?? firstService['service']?.toString() ?? firstService['id']?.toString();
              extractedServiceName = firstService['name']?.toString();
              extractedServicePrice = firstService['price']?.toString();
            }
            if (extractedServiceId == null && e['artisan_profile'] is Map) {
              final profServices = e['artisan_profile']['services'];
              if (profServices != null && profServices is List && profServices.isNotEmpty) {
                final firstProfService = profServices[0];
                extractedServiceId = firstProfService['service_id']?.toString() ?? firstProfService['service']?.toString() ?? firstProfService['id']?.toString();
                extractedServiceName ??= firstProfService['name']?.toString();
                extractedServicePrice ??= firstProfService['price']?.toString();
              }
            }

            final finalOccupation = extractedServiceName ?? e['occupation'] ?? 'Specialist';

            return {
              'id': e['artisan_id'],
              'service_id': extractedServiceId,
              'name': e['full_name'] ?? 'Artisan',
              'role': finalOccupation,
              'occupation': finalOccupation,
              'avatar': ApiServices.formatImageUrl(e['profile_picture']?.toString()),
              'isVerified': e['is_verified'] == true || (e['artisan_profile'] != null && e['artisan_profile']['is_verified'] == true),
              'isOnline': e['is_online'] ?? true,
              'rating': double.tryParse(e['avg_rating']?.toString() ?? '0') ?? 0.0,
              'reviews': e['review_count'] ?? 0,
              'jobsDone': e['total_jobs_done'] ?? 0,
              'price': _getValidPrice(e, extractedServicePrice),
              'distanceOrTime': dist < 1.0 ? 'Nearby' : '${dist.toStringAsFixed(1)} km',
              'bio': e['bio'] ?? (e['artisan_profile'] != null ? e['artisan_profile']['bio'] : null),
              'experience': e['experience_years'] ?? e['years_of_experience'] ?? (e['artisan_profile'] != null ? e['artisan_profile']['experience_years'] : null),
              'skills': e['skills'] ?? (e['artisan_profile'] != null ? e['artisan_profile']['skills'] : null),
              'service_areas': e['service_areas'] ?? (e['artisan_profile'] != null ? e['artisan_profile']['service_areas'] : null),
            };
          }).toList());
          return;
        }
      }
    } catch (e) {
      print("Error fetching recommended artisans: $e");
    } finally {
      isLoadingArtisans.value = false;
    }
  }

  String _getValidPrice(Map<String, dynamic> e, String? extractedServicePrice) {
    final possibleValues = [
      extractedServicePrice,
      e['effective_price'],
      e['price_override'],
      e['hourly_rate'],
      e['base_price'],
      if (e['artisan_profile'] is Map) ...[
        e['artisan_profile']['effective_price'],
        e['artisan_profile']['price_override'],
        e['artisan_profile']['hourly_rate'],
        e['artisan_profile']['base_price'],
        e['artisan_profile']['effective_price'],
      ]
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

  void _useDummyArtisans() {
    recommendedArtisans.assignAll([
      {
        'id': '1',
        'name': 'Marcus Johnson',
        'role': 'Plumber',
        'avatar': AppImages.homeMarcusJohnson,
        'isVerified': true,
        'rating': 4.9,
        'reviews': 127,
        'pricePerHour': '35',
        'distanceOrTime': 'Nearby',
      },
      {
        'id': '2',
        'name': 'Sarah Williams',
        'role': 'Cleaner',
        'avatar': AppImages.homeSarahWilliams,
        'isVerified': true,
        'rating': 4.8,
        'reviews': 89,
        'pricePerHour': '28',
        'distanceOrTime': '2.1 km',
      },
    ]);
  }

  void updateAddress(String city, String address) {
    locationController.updateLocation(city, address);
  }
}

