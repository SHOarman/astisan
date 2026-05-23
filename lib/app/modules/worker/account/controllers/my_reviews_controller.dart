import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../../../core/Services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyReviewsController extends GetxController {
  final avgRating = 0.0.obs;
  final totalReviews = 0.obs;
  final isLoading = false.obs;
  
  final ratingBreakdown = {
    '5': 0,
    '4': 0,
    '3': 0,
    '2': 0,
    '1': 0,
  }.obs;

  final reviews = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.trim().replaceAll('"', '');

      final url = Uri.parse('${ApiServices.baseurl}/api/reviews/artisan/summary/');
      final response = await http.get(
        url,
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        avgRating.value = double.tryParse(data['average_rating']?.toString() ?? '0.0') ?? 0.0;
        totalReviews.value = data['review_count'] ?? 0;
        
        final reviewList = data['reviews'] as List? ?? [];
        
        // Count breakdown manually if not provided by backend
        final counts = {'5': 0, '4': 0, '3': 0, '2': 0, '1': 0};
        
        reviews.value = reviewList.map((item) {
          final rating = double.tryParse(item['rating']?.toString() ?? '0') ?? 0.0;
          final intRating = rating.round().clamp(1, 5).toString();
          counts[intRating] = (counts[intRating] ?? 0) + 1;
          
          return {
            'name': item['client_name'] ?? 'Client',
            'date': item['created_at'] != null ? item['created_at'].toString().split('T').first : 'N/A',
            'rating': rating,
            'comment': item['comment'] ?? '',
            'service': item['service_name'] ?? 'Service',
            'payment': '', // API might not return this
          };
        }).toList();
        
        ratingBreakdown.value = counts;
      }
    } catch (e) {
      Get.snackbar('Error'.tr, 'Failed to load reviews'.tr);
    } finally {
      isLoading.value = false;
    }
  }
}
