import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/Services/api_services.dart';

class SubCategoryController extends GetxController {
  final categoryData = <String, dynamic>{}.obs;
  final services = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final categoryDescription = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      categoryData.value = Map<String, dynamic>.from(Get.arguments);
      fetchCategoryDetail();
      fetchServicesByCategory();
    }
  }

  String get title => categoryData['title'] ?? 'Services';
  String get categoryId => categoryData['id']?.toString() ?? '';

  Future<void> fetchCategoryDetail() async {
    if (categoryId.isEmpty) return;
    try {
      final response = await http.get(
        Uri.parse("${ApiServices.category_services}$categoryId/"),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        categoryDescription.value = data['description'] ?? '';
      }
    } catch (e) {
      print("Error fetching category detail: $e");
    }
  }

  Future<void> fetchServicesByCategory() async {
    if (categoryId.isEmpty) return;
    
    isLoading.value = true;
    try {
      String url = "${ApiServices.category_services}$categoryId/services/";
      print("DEBUG: Fetching services for category $categoryId from $url");
      
      final response = await http.get(
        Uri.parse(url),
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

          if (dataList.isNotEmpty) {
            print("DEBUG: API Service Data Keys: ${dataList[0].keys}");
            print("DEBUG: API Service Sample Data: ${dataList[0]}");
          }

        services.assignAll(dataList.map((e) {
          String iconUrl = e['icon']?.toString() ?? e['image']?.toString() ?? '';
          String desc = e['description']?.toString() ?? e['about']?.toString() ?? '';
          
          print("DEBUG: Service Mapping -> Name: ${e['name']}, Icon: $iconUrl, Desc: $desc");
          
          return {
            'id': e['id'],
            'title': e['name'] ?? 'Service',
            'description': desc,
            'image': ApiServices.formatImageUrl(iconUrl),
            'rating': double.tryParse(e['avg_rating']?.toString() ?? '0') ?? 0.0,
            'reviews': e['review_count'] ?? 0,
            'price_range_min': e['price_range_min'],
            'price_range_max': e['price_range_max'],
          };
        }).toList());
        
        print("DEBUG: Successfully loaded ${services.length} services");
      }
    } catch (e) {
      print("Error fetching sub-category services: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
