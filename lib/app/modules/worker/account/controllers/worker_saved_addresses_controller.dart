import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/global_controllers/location_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WorkerSavedAddressesController extends GetxController {
  final isLoading = false.obs;
  
  // Single active address
  final currentAddress = "".obs;
  final currentCity = "".obs;
  final currentState = "".obs;
  final currentCountry = "".obs;
  final currentLat = 0.0.obs;
  final currentLng = 0.0.obs;
  final hasSavedAddress = false.obs;

  final selectedLocation = const LatLng(0, 0).obs;
  final MapController mapController = MapController();

  @override
  void onInit() {
    super.onInit();
    fetchCurrentAddress();
  }

  Future<void> fetchCurrentAddress() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token')?.replaceAll('"', '');
      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiServices.artisan_home_address),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("====== DEBUG HOME ADDRESS GET ======");
      print("GET Status: ${response.statusCode}");
      print("GET Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['address_line'] != null) {
          currentAddress.value = data['address_line']?.toString() ?? "";
          currentCity.value = data['city']?.toString() ?? "";
          currentState.value = data['state']?.toString() ?? "";
          currentCountry.value = data['country']?.toString() ?? "";
          currentLat.value = double.tryParse(data['latitude']?.toString() ?? '0.0') ?? 0.0;
          currentLng.value = double.tryParse(data['longitude']?.toString() ?? '0.0') ?? 0.0;
          if (currentLat.value != 0.0 && currentLng.value != 0.0) {
            selectedLocation.value = LatLng(currentLat.value, currentLng.value);
            mapController.move(selectedLocation.value, 15.0);
          }
          hasSavedAddress.value = true;
        } else {
          currentAddress.value = "No address set";
          hasSavedAddress.value = false;
        }
      } else {
        currentAddress.value = "No address set";
        hasSavedAddress.value = false;
      }
    } catch (e) {
      print("Error fetching address: $e");
      currentAddress.value = "No address set";
      hasSavedAddress.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> useCurrentLocation() async {
    isLoading.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("Error", "Location services are disabled.");
        isLoading.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Error", "Location permissions are denied");
          isLoading.value = false;
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentLat.value = position.latitude;
      currentLng.value = position.longitude;
      selectedLocation.value = LatLng(position.latitude, position.longitude);
      mapController.move(selectedLocation.value, 15.0);

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
        address = address.replaceAll(RegExp(r'^,\s*'), '').replaceAll(RegExp(r',\s*,'), ',');
        currentAddress.value = address;
        currentCity.value = place.locality ?? place.subAdministrativeArea ?? "Dhaka";
        currentState.value = place.administrativeArea ?? "Dhaka Division";
        currentCountry.value = place.country ?? "Bangladesh";
        Get.snackbar("Success", "Location updated. Press Save to apply.", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error getting location: $e");
      Get.snackbar("Error", "Could not get current location");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveChanges() async {
    // If the map was moved by dragging, we should reverse geocode the selectedLocation
    if (selectedLocation.value.latitude != 0.0 && selectedLocation.value.longitude != 0.0 && 
        (selectedLocation.value.latitude != currentLat.value || selectedLocation.value.longitude != currentLng.value)) {
      currentLat.value = selectedLocation.value.latitude;
      currentLng.value = selectedLocation.value.longitude;
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(currentLat.value, currentLng.value);
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String address = "${place.street ?? ''}, ${place.subLocality ?? ''}".trim();
          if (address.endsWith(',')) address = address.substring(0, address.length - 1);
          currentAddress.value = address.isEmpty ? "Service Area" : address;
          currentCity.value = place.locality ?? place.subAdministrativeArea ?? "Dhaka";
          currentState.value = place.administrativeArea ?? "Dhaka Division";
          currentCountry.value = place.country ?? "Bangladesh";
        }
      } catch (e) {
        print("Geocoding map location failed: $e");
      }
    }

    if (currentLat.value == 0.0 || currentLng.value == 0.0) {
      Get.snackbar('Error', 'Please select a valid location first.');
      return;
    }

    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token')?.replaceAll('"', '');
      if (token == null) return;

      final payload = {
        "label": "home",
        "custom_label": "Service Area",
        "address_line": currentAddress.value,
        "city": currentCity.value.isNotEmpty ? currentCity.value : "Dhaka",
        "state": currentState.value.isNotEmpty ? currentState.value : "Dhaka Division",
        "zip_code": "1000",
        "country": currentCountry.value.isNotEmpty ? currentCountry.value : "Bangladesh",
        "latitude": double.parse(currentLat.value.toStringAsFixed(6)),
        "longitude": double.parse(currentLng.value.toStringAsFixed(6)),
        "is_default": true
      };

      print("====== DEBUG HOME ADDRESS SAVE ======");
      print("Payload sending to server: $payload");

      final response = await http.post(
        Uri.parse(ApiServices.artisan_home_address),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(payload),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar('Success', 'Address saved successfully.', backgroundColor: Colors.green, colorText: Colors.white);
        hasSavedAddress.value = true;
      } else {
        Get.snackbar('Error', 'Failed to save address: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while saving.');
    } finally {
      isLoading.value = false;
    }
  }
}
