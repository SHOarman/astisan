import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/global_controllers/location_controller.dart';
import '../../saved_addresses/controllers/saved_addresses_controller.dart';

class AddAddressController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final label = 'home'.obs; 
  final customLabelController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final countryController = TextEditingController();
  final isDefault = false.obs;
  final isLoading = false.obs;

  final locationController = Get.find<LocationController>();

  @override
  void onInit() {
    super.onInit();
    // Auto-fill from current location if available
    addressController.text = locationController.selectedAddress.value;
    cityController.text = locationController.selectedCity.value;
  }

  void setLabel(String value) {
    label.value = value;
  }

  Future<void> saveAddress() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

        final body = {
          "label": label.value,
          "custom_label": label.value == 'other' ? customLabelController.text.trim() : "",
          "address_line": addressController.text.trim(),
          "city": cityController.text.trim(),
          "state": stateController.text.trim(),
          "zip_code": zipController.text.trim(),
          "country": countryController.text.trim(),
          "latitude": locationController.currentPosition.value?.latitude.toString() ?? "0.0",
          "longitude": locationController.currentPosition.value?.longitude.toString() ?? "0.0",
          "is_default": isDefault.value
        };

        final response = await http.post(
          Uri.parse(ApiServices.client_addresses),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(body),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          Get.find<SavedAddressesController>().fetchAddresses();
          Get.back();
          Get.snackbar('Success', 'Address added successfully');
        } else {
          final data = json.decode(response.body);
          Get.snackbar('Error', data['message'] ?? 'Failed to add address');
        }
      } catch (e) {
        Get.snackbar('Error', 'Connection failed');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
