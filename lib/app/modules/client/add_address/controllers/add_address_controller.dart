import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/global_controllers/location_controller.dart';
import '../../saved_addresses/controllers/saved_addresses_controller.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as geo;

class AddAddressController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final label = 'home'.obs; 
  final customLabelController = TextEditingController();
  final isDefault = false.obs;
  final isLoading = false.obs;

  final selectedLocation = const LatLng(0, 0).obs;
  final MapController mapController = MapController();

  final locationController = Get.find<LocationController>();

  @override
  void onInit() {
    super.onInit();
    if (locationController.currentPosition.value != null) {
      selectedLocation.value = LatLng(
        locationController.currentPosition.value!.latitude,
        locationController.currentPosition.value!.longitude,
      );
    }
  }

  void setLabel(String value) {
    label.value = value;
  }

  Future<void> saveAddress() async {
    // Only validate the form for custom label
    if (label.value == 'other' && customLabelController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a custom label');
      return;
    }

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.trim().replaceAll('"', '');

      // Reverse geocode to get the textual address data
      String addressLine = "";
      String city = "";
      String state = "";
      String zip = "";
      String country = "";

      try {
        List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
          selectedLocation.value.latitude,
          selectedLocation.value.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          addressLine = "${place.street ?? ''}, ${place.subLocality ?? ''}".trim();
          if (addressLine.endsWith(',')) addressLine = addressLine.substring(0, addressLine.length - 1);
          city = place.locality ?? place.subAdministrativeArea ?? '';
          state = place.administrativeArea ?? '';
          zip = place.postalCode ?? '';
          country = place.country ?? '';
        }
      } catch (e) {
        print("Geocoding failed: $e");
      }

      final body = {
        "label": label.value,
        "custom_label": label.value == 'other' ? customLabelController.text.trim() : "",
        "address_line": addressLine.isEmpty ? "Unknown Address" : addressLine,
        "city": city.isEmpty ? "Unknown City" : city,
        "state": state.isEmpty ? "Unknown State" : state,
        "zip_code": zip.isEmpty ? "0000" : zip,
        "country": country.isEmpty ? "Unknown Country" : country,
        "latitude": double.parse(selectedLocation.value.latitude.toStringAsFixed(6)),
        "longitude": double.parse(selectedLocation.value.longitude.toStringAsFixed(6)),
        "is_default": isDefault.value
      };

        print("DEBUG: Saving address with lat=${selectedLocation.value.latitude}, lng=${selectedLocation.value.longitude}");
        print("DEBUG: Address body: $body");

        final response = await http.post(
          Uri.parse(ApiServices.client_addresses),
          headers: { 'Accept-Language': ApiServices.currentLanguage, 
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Ac'
                'cept': 'application/json',
          },
          body: json.encode(body),
        );

        print("====== DEBUG ADDRESS CREATION ======");
        print("Response Status: ${response.statusCode}");
        print("Response Body: ${response.body}");

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

