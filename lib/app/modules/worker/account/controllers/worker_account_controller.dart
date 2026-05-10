import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/Services/api_services.dart';

class WorkerAccountController extends GetxController {
  // User Profile Data
  final userName = 'Marcus Johnson'.obs;
  final profession = 'Certified Plumber'.obs;
  final experienceYears = '5+'.obs;
  final location = 'New York, NY'.obs;
  final joinYear = '2021'.obs;
  
  // Additional profile fields
  final userEmail = ''.obs;
  final phoneNumber = ''.obs;
  final profilePicture = ''.obs;
  final isOnline = false.obs;
  final joinDate = ''.obs;
  final isLoading = false.obs;

  // Stats Data
  final jobsDone = 203.obs;
  final rating = 4.9.obs;
  final earnings = '4.2K'.obs;

  // Lists
  final skills = [
    'Plumbing',
    'Pipe Fitting',
    'Drain Cleaning',
    'Water Heater',
    'Faucet Repair',
    'Toilet Repair'
  ].obs;

  final serviceAreas = [
    'Manhattan',
    'Brooklyn',
    'Queens'
  ].obs;

  void signOut() {
    print("User signed out");
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        print("DEBUG: Profile Fetch Aborted - No Token Found");
        isLoading.value = false;
        return;
      }
      
      // Clean token to prevent 401
      final String cleanToken = token.trim().replaceAll('"', '');
      final String url = ApiServices.artisan_profile;

      print("DEBUG: Fetching Profile from: $url");
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      print("DEBUG: Profile Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        userName.value = data['full_name'] ?? '';
        userEmail.value = data['email'] ?? '';
        phoneNumber.value = data['phone'] ?? '';
        profilePicture.value = data['profile_picture'] ?? '';
        
        final artisan = data['artisan_profile'];
        if (artisan != null) {
          isOnline.value = artisan['is_online'] ?? false;
          if (artisan['joined_at'] != null) {
            try {
              DateTime dt = DateTime.parse(artisan['joined_at']);
              joinDate.value = "${dt.day}/${dt.month}/${dt.year}";
            } catch (e) {
              joinDate.value = '';
            }
          }
        }
      } else if (response.statusCode == 401) {
        print("DEBUG: 401 ERROR - Token rejected. Body: ${response.body}");
      }
    } catch (e) {
      print("DEBUG: Profile Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}