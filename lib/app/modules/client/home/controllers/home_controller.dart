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
  
  @override
  void onInit() {
    super.onInit();
    fetchPopularServices();
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
          'image': e['image'] ?? '',
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
  
  final forYouCategories = <Map<String, dynamic>>[
    {
      'title': AppStrings.repairMaintenance,
      'icon': AppImages.forYouRepair,
    },
    {
      'title': AppStrings.cleaning,
      'icon': AppImages.forYouCleaning,
    },
    {
      'title': AppStrings.installation,
      'icon': AppImages.forYouInstallation,
    },
    {
      'title': AppStrings.homeImprovement,
      'icon': AppImages.forYouHomeImprovement,
    },
  ].obs;

  final popularServices = <Map<String, dynamic>>[].obs;

  final recommendedArtisans = <Map<String, dynamic>>[
    {
      'name': 'Marcus Johnson',
      'role': 'Plumber',
      'avatar': AppImages.homeMarcusJohnson,
      'isVerified': true,
      'rating': 4.9,
      'reviews': 127,
      'pricePerHour': '\$35/hr',
      'distanceOrTime': '1.2 km',
    },
    {
      'name': 'Sarah Williams',
      'role': 'Cleaner',
      'avatar': AppImages.homeSarahWilliams,
      'isVerified': true,
      'rating': 4.8,
      'reviews': 89,
      'pricePerHour': '\$28/hr',
      'distanceOrTime': '2.1 km',
    },
    {
      'name': 'Daniel Carter',
      'role': 'Electrician',
      'avatar': AppImages.homeDanielCarter,
      'isVerified': true,
      'rating': 4.7,
      'reviews': 203,
      'pricePerHour': '\$45/hr',
      'distanceOrTime': '3.4 km',
    },
  ].obs;

  void updateAddress(String city, String address) {
    locationController.updateLocation(city, address);
  }
}

