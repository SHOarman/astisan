import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/routes/app_routes.dart';

class SavedAddressesController extends GetxController {
  final savedAddresses = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        Get.snackbar('Error', 'Session expired. Please login again.');
        return;
      }

      final response = await http.get(
        Uri.parse(ApiServices.client_addresses),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> dataList = [];
        
        if (decodedData is List) {
          dataList = decodedData;
        } else if (decodedData is Map) {
          // Check for common wrapper keys like 'results', 'data', or 'addresses'
          dataList = decodedData['results'] ?? decodedData['data'] ?? decodedData['addresses'] ?? [];
        }

        savedAddresses.assignAll(dataList.map((e) => {
          'id': e['id'],
          'title': (e['label'] == 'other' || e['label'] == null) 
              ? (e['custom_label'] ?? 'Address') 
              : e['label'].toString().capitalizeFirst,
          'address': e['address_line'] ?? 'No address line',
          'isDefault': e['is_default'] ?? false,
          'icon': _getIconForLabel(e['label']),
          'raw': e,
        }).toList());
      } else {
        Get.snackbar('Error', 'Failed to load: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  IconData _getIconForLabel(String? label) {
    switch (label?.toLowerCase()) {
      case 'home': return Icons.home_rounded;
      case 'work':
      case 'office': return Icons.work_rounded;
      default: return Icons.location_on_rounded;
    }
  }

  void addNewAddress() {
    Get.toNamed(Routes.ADD_ADDRESS);
  }

  Future<void> deleteAddress(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      final response = await http.delete(
        Uri.parse("${ApiServices.client_addresses}$id/"),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        fetchAddresses();
        Get.snackbar('Success', 'Address deleted successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete address');
    }
  }

  void saveChanges() {
    Get.back();
  }
}
