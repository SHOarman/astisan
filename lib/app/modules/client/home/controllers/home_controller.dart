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
      );

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
      );

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
    if (popularServices.isEmpty) {
      await fetchPopularServices();
    }

    if (popularServices.isEmpty) {
      _useDummyArtisans();
      return;
    }

    isLoadingArtisans.value = true;
    try {
      final String firstServiceId = popularServices.first['id'].toString();
      final pos = locationController.currentPosition.value;
      
      String url = "${ApiServices.baseurl}/api/services/client/services/$firstServiceId/nearby-artisans/";
      Map<String, String> queryParams = {'radius_km': '10'};
      
      if (pos != null) {
        queryParams['lat'] = pos.latitude.toString();
        queryParams['lng'] = pos.longitude.toString();
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
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> dataList = [];
        if (decodedData is List) {
          dataList = decodedData;
        } else if (decodedData is Map) {
          dataList = decodedData['results'] ?? [];
        }

        if (dataList.isNotEmpty) {
          recommendedArtisans.assignAll(dataList.take(5).map((e) {
            final profile = e['artisan_profile'] ?? {};
            final double dist = double.tryParse(e['distance_km']?.toString() ?? '0.0') ?? 0.0;
            return {
              'id': e['id'],
              'name': e['full_name'] ?? 'Artisan',
              'role': profile['occupation'] ?? popularServices.first['title'],
              'avatar': ApiServices.formatImageUrl(e['profile_picture']?.toString()),
              'isVerified': profile['is_verified'] ?? true,
              'rating': double.tryParse(profile['average_rating']?.toString() ?? '0') ?? 0.0,
              'reviews': profile['total_reviews'] ?? 0,
              'pricePerHour': profile['hourly_rate']?.toString() ?? '25',
              'distanceOrTime': dist < 1.5 ? 'Nearby' : '${dist.toStringAsFixed(1)} km',
            };
          }).toList());
          return;
        }
      }
    } catch (e) {
      print("Error fetching recommended artisans: $e");
    } finally {
      isLoadingArtisans.value = false;
      if (recommendedArtisans.isEmpty) {
        _useDummyArtisans();
      }
    }
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

