import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/Services/api_services.dart';

class ServicesController extends GetxController {
  final categories = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    print("DEBUG: ServicesController - Fetching categories from ${ApiServices.services_categories}");
    try {
      final response = await http.get(
        Uri.parse(ApiServices.services_categories),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 'Accept': 'application/json'},
      );

      print("DEBUG: ServicesController - Status Code: ${response.statusCode}");
      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        print("DEBUG: ServicesController - Data received: $decodedData");
        
        List<dynamic> dataList = [];
        if (decodedData is List) {
          dataList = decodedData;
        } else if (decodedData is Map) {
          dataList = decodedData['results'] ?? [];
        }

        categories.assignAll(dataList.map((e) => {
          'id': e['id'],
          'title': e['name'] ?? 'Category',
          'icon': ApiServices.formatImageUrl(e['icon']?.toString()),
        }).toList());
        print("DEBUG: ServicesController - Parsed ${categories.length} categories");
      } else {
        print("DEBUG: ServicesController - Error Response: ${response.body}");
      }
    } catch (e) {
      print("DEBUG: ServicesController - Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

