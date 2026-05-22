import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/constants/static/app_images.dart';

class PopularServicesController extends GetxController {
  final popularServices = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPopularServices();
  }

  Future<void> fetchPopularServices() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
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
        print("PopularServicesController: Status code ${response.statusCode}, falling back to dummy");
        _useDummyPopularServices();
      }
    } catch (e) {
      print("Error fetching popular services, falling back to dummy: $e");
      _useDummyPopularServices();
    } finally {
      isLoading.value = false;
    }
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
}

