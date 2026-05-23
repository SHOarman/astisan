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
  final showAllRecommended = false.obs;
  
  void toggleShowAllRecommended() {
    showAllRecommended.value = !showAllRecommended.value;
  }
  
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
      
      if (token != null) {
        token = token.trim().replaceAll('"', '');
        if (token.isEmpty || token.toLowerCase() == 'null') {
          token = null;
        }
      }
      
      final response = await http.get(
        Uri.parse(ApiServices.popular_services),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

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
      } else {
        print("HomeController: Popular services status code ${response.statusCode}, falling back to dummy");
        _useDummyPopularServices();
      }
    } catch (e) {
      print("Error fetching popular services, falling back to dummy: $e");
      _useDummyPopularServices();
    } finally {
      isLoadingPopular.value = false;
    }
  }

  Future<void> fetchCategories() async {
    isLoadingCategories.value = true;
    try {
      final response = await http.get(
        Uri.parse(ApiServices.services_categories),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> dataList = [];
        
        if (decodedData is List) {
          dataList = decodedData;
        } else if (decodedData is Map) {
          dataList = decodedData['results'] ?? [];
        }

        forYouCategories.assignAll(dataList.map((e) => {
          'id': e['id'],
          'title': e['name'] ?? 'Category',
          'icon': ApiServices.formatImageUrl(e['icon']?.toString()),
        }).toList());
      } else {
        print("HomeController: Categories status code ${response.statusCode}, falling back to dummy");
        _useDummyCategories();
      }
    } catch (e) {
      print("Error fetching categories, falling back to dummy: $e");
      _useDummyCategories();
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
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> dataList = [];
        if (decodedData is Map) {
          dataList = decodedData['results'] ?? [];
        } else if (decodedData is List) {
          dataList = decodedData;
        }

        if (dataList.isNotEmpty) {
          dataList.sort((a, b) {
            final double distA = double.tryParse(a['distance_km']?.toString() ?? '999') ?? 999;
            final double distB = double.tryParse(b['distance_km']?.toString() ?? '999') ?? 999;
            int distComp = distA.compareTo(distB);
            if (distComp != 0) return distComp;

            final double ratA = double.tryParse(a['avg_rating']?.toString() ?? '0') ?? 0;
            final double ratB = double.tryParse(b['avg_rating']?.toString() ?? '0') ?? 0;
            return ratB.compareTo(ratA);
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
      print("HomeController: Recommended artisans empty or response fail, falling back to dummy");
      _useDummyArtisans();
    } catch (e) {
      print("Error fetching recommended artisans, falling back to dummy: $e");
      _useDummyArtisans();
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

  void _useDummyPopularServices() {
    popularServices.assignAll([
      {
        'id': 'popular_dummy_1',
        'title': 'AC Service & Repair',
        'image': AppImages.popAcService,
        'rating': 4.8,
        'reviews': 120,
        'priceRange': '\$50-\$150',
      },
      {
        'id': 'popular_dummy_2',
        'title': 'Deep House Cleaning',
        'image': AppImages.popDeepCleaning,
        'rating': 4.9,
        'reviews': 240,
        'priceRange': '\$30-\$90',
      },
      {
        'id': 'popular_dummy_3',
        'title': 'Electrical Wiring',
        'image': AppImages.popElectricalWiring,
        'rating': 4.7,
        'reviews': 95,
        'priceRange': '\$40-\$120',
      },
      {
        'id': 'popular_dummy_4',
        'title': 'Pipe Leak Repair',
        'image': AppImages.popPipeLeak,
        'rating': 4.6,
        'reviews': 80,
        'priceRange': '\$45-\$130',
      },
    ]);
  }

  void _useDummyCategories() {
    forYouCategories.assignAll([
      {
        'id': 'cat_dummy_1',
        'title': 'Cleaning',
        'icon': AppImages.iconCleaningService,
      },
      {
        'id': 'cat_dummy_2',
        'title': 'Repair',
        'icon': AppImages.iconRepairMaintenance,
      },
      {
        'id': 'cat_dummy_3',
        'title': 'Installation',
        'icon': AppImages.iconInstallationService,
      },
      {
        'id': 'cat_dummy_4',
        'title': 'Improvement',
        'icon': AppImages.iconHomeImprovement,
      },
      {
        'id': 'cat_dummy_5',
        'title': 'Moving',
        'icon': AppImages.iconMovingShifting,
      },
      {
        'id': 'cat_dummy_6',
        'title': 'Garden',
        'icon': AppImages.iconGardenCleaning,
      },
    ]);
  }

  void _useDummyArtisans() {
    recommendedArtisans.assignAll([
      {
        'id': '1',
        'name': 'Marcus Johnson',
        'role': 'Plumber',
        'avatar': AppImages.homeDanielCarter,
        'isVerified': true,
        'rating': 4.9,
        'reviews': 127,
        'price': '35',
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
        'price': '28',
        'distanceOrTime': '2.1 km',
      },
    ]);
  }

  void updateAddress(String city, String address) {
    locationController.updateLocation(city, address);
  }
}

