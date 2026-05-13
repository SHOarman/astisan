import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/global_controllers/location_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/Services/api_services.dart';

class ServiceDetailsController extends GetxController {
  final isFavorite = false.obs;
  final selectedTab = 0.obs; // 0 for Overview, 1 for Reviews

  final serviceData = RxMap<String, dynamic>();
  final artisanData = RxMap<String, dynamic>();

  final topArtisans = <Map<String, dynamic>>[].obs;
  final isLoadingTopArtisans = false.obs;

  // UI-te render korar jonno list-ti eikhane thaka dorkar
  final whatsIncluded = [
    'Professional service delivery',
    'Safety inspection & testing',
    'Post-service cleanup',
    '30-day service warranty',
  ].obs;

  final reviews = [
    {
      'name': 'Sarah Williams',
      'date': '2 days ago',
      'rating': 5,
      'comment': 'Excellent service, the plumber arrived on time and fixed the leak perfectly. Highly recommended!',
      'image': 'assets/images/home/Sarah Williams.png',
    },
    {
      'name': 'David Carter',
      'date': '1 week ago',
      'rating': 4,
      'comment': 'Great job fixing the wiring issues. Very professional and efficient.',
      'image': 'assets/images/home/Daniel Carter.png',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _handleArguments();
  }

  void _handleArguments() {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map<String, dynamic>;

      if (args.containsKey('service') || args.containsKey('artisan')) {
        serviceData.assignAll(args['service'] ?? {});
        artisanData.assignAll(args['artisan'] ?? {});
      } else {
        artisanData.assignAll(args);
        if (serviceData.isEmpty) {
          serviceData.assignAll({
            'title': args['role'] ?? args['occupation'] ?? 'Service Details',
            'rating': args['rating'],
            'reviews': args['reviews'] ?? args['review_count'],
            'priceRange': args['pricePerHour'] != null ? '\$${args['pricePerHour']}' : null,
          });
        }
      }
      _normalizeArtisanData();
      fetchTopArtisansForService();
    }
  }

  void _normalizeArtisanData() {
    artisanData['full_name'] ??= artisanData['name'];
    artisanData['profile_picture'] ??= artisanData['avatar'];
    artisanData['review_count'] ??= artisanData['reviews'];
    artisanData['hourly_rate'] ??= artisanData['pricePerHour'];
    artisanData['distance'] ??= artisanData['distanceOrTime'];
    artisanData['occupation'] ??= artisanData['role'];
  }

  Future<void> fetchTopArtisansForService() async {
    final String? categoryName = serviceData['title'] ?? artisanData['occupation'];
    if (categoryName == null) return;

    isLoadingTopArtisans.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token')?.trim().replaceAll('"', '');

      final locationController = Get.find<LocationController>();
      final pos = locationController.currentPosition.value;

      Map<String, String> queryParams = {
        'search': categoryName,
      };

      if (pos != null) {
        queryParams['lat'] = pos.latitude.toString();
        queryParams['lng'] = pos.longitude.toString();
      }

      final uri = Uri.parse(ApiServices.recommended_artisans).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> dataList = (decodedData is Map) ? (decodedData['results'] ?? []) : (decodedData ?? []);

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
        }

        topArtisans.assignAll(dataList.map((e) {
          final double dist = double.tryParse(e['distance_km']?.toString() ?? '0.0') ?? 0.0;
          return {
            'id': e['artisan_id'],
            'name': e['full_name'] ?? 'Artisan',
            'role': e['occupation'] ?? categoryName,
            'avatar': ApiServices.formatImageUrl(e['profile_picture']?.toString()),
            'isVerified': e['is_verified'] ?? true,
            'rating': double.tryParse(e['avg_rating']?.toString() ?? '0') ?? 0.0,
            'reviews': e['review_count'] ?? 0,
            'jobsDone': e['total_jobs_done'] ?? 0,
            'price': e['effective_price']?.toString() ?? '0',
            'distanceOrTime': dist < 1.0 ? 'Nearby' : '${dist.toStringAsFixed(1)} km',
          };
        }).toList());
      }
    } catch (e) {
      print("Error fetching artisans: $e");
    } finally {
      isLoadingTopArtisans.value = false;
    }
  }

  void toggleFavorite() => isFavorite.value = !isFavorite.value;
  void changeTab(int index) => selectedTab.value = index;
  void bookNow() => Get.toNamed(Routes.BOOKING, arguments: Get.arguments);
}