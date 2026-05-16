import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/global_controllers/location_controller.dart';
import '../../../../core/routes/app_routes.dart';

class WorkerAccountController extends GetxController {
  final isLoading = false.obs;

  final userName = 'Worker Name'.obs;
  final userEmail = ''.obs;
  final userPhone = ''.obs;
  final profilePicture = ''.obs;
  final joinDate = ''.obs;
  final serviceRate = '0.00'.obs;
  final isVerified = false.obs;
  final verificationStatus = 'unverified'.obs;
  
  final serviceId = ''.obs;
  final registrationId = ''.obs;
  
  final locationController = Get.find<LocationController>();
  String get currentLocation => locationController.selectedCity.value;

  final profession = 'Artisan'.obs;
  final bio = 'No bio available'.obs;
  final experienceYears = '0'.obs;
  final location = 'Location not set'.obs;
  final joinYear = '2026'.obs;

  final jobsDone = 0.obs;
  final rating = 0.0.obs;
  final earnings = '0.00'.obs;

  final skills = <String>[].obs;
  final serviceAreas = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStoredData();
    fetchProfile();
  }

  void loadStoredData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('user_name') ?? userName.value;
    String storedPic = prefs.getString('user_profile_pic') ?? '';
    profilePicture.value = ApiServices.formatImageUrl(storedPic);
    print("DEBUG: Loaded stored profile pic: ${profilePicture.value}");
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        isLoading.value = false;
        return;
      }

      final String cleanToken = token.trim().replaceAll('"', '');
      
      final response = await http.get(
        Uri.parse(ApiServices.artisan_profile),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("DEBUG: Worker Profile Fetch Success: ${response.body}");

        userName.value = data['full_name']?.toString() ?? userName.value;
        userEmail.value = data['email']?.toString() ?? '';
        userPhone.value = data['phone']?.toString() ?? '';
        
        String? picUrl = data['profile_picture']?.toString();
        print("DEBUG: Raw Profile Pic from API: $picUrl");
        
        profilePicture.value = ApiServices.formatImageUrl(picUrl);
        print("DEBUG: Formatted Profile Pic: ${profilePicture.value}");
        
        await prefs.setString('user_name', userName.value);
        await prefs.setString('user_profile_pic', profilePicture.value);

        final artisan = data['artisan_profile'];
        if (artisan != null && artisan is Map) {
          isVerified.value = artisan['is_verified'] ?? false;
          verificationStatus.value = artisan['verification_status']?.toString() ?? 'unverified';
          jobsDone.value = artisan['total_jobs_done'] ?? 0;
          earnings.value = artisan['total_earnings']?.toString() ?? '0.00';
          profession.value = artisan['occupation']?.toString() ?? 'Artisan';
          bio.value = artisan['bio']?.toString() ?? 'No bio available';
          experienceYears.value = artisan['years_of_experience']?.toString() ?? '0';
          serviceRate.value = artisan['hourly_rate']?.toString() ?? '0.00';

          if (artisan['average_rating'] != null) {
            rating.value = double.tryParse(artisan['average_rating'].toString()) ?? 0.0;
          }

          // Fetch specific service to get a better name if "Artisan"
          await fetchMyServices(cleanToken);

          if (artisan['skills'] != null) {
            if (artisan['skills'] is String) {
              skills.assignAll(artisan['skills'].toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList());
            } else if (artisan['skills'] is List) {
              skills.assignAll(List<String>.from(artisan['skills']).where((e) => e.isNotEmpty).toList());
            }
          }

          if (artisan['service_areas'] != null) {
            if (artisan['service_areas'] is String) {
              serviceAreas.assignAll(artisan['service_areas'].toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList());
            } else if (artisan['service_areas'] is List) {
              serviceAreas.assignAll(List<String>.from(artisan['service_areas']).where((e) => e.isNotEmpty).toList());
            }
          }

          if (artisan['joined_at'] != null || data['created_at'] != null) {
            try {
              DateTime dt = DateTime.parse((artisan['joined_at'] ?? data['created_at']).toString());
              joinDate.value = "${dt.day}/${dt.month}/${dt.year}";
              joinYear.value = dt.year.toString();
            } catch (e) {}
          }
        }
      }
    } catch (e) {
      print("Profile error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMyServices(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiServices.artisan_my_services),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> results = (data is List) ? data : (data['results'] ?? data['data'] ?? []);

        if (results.isNotEmpty) {
          // Collect all service names to show in Skills & Services if skills list is empty
          List<String> serviceNames = [];
          
          for (var item in results) {
            String name = '';
            final details = item['service_details'];
            if (details != null && details['name'] != null) {
              name = details['name'].toString();
            } else if (item['service_name'] != null) {
              name = item['service_name'].toString();
            }
            if (name.isNotEmpty) serviceNames.add(name);
          }

          // If profile skills are empty, use service names as skills
          if (skills.isEmpty) {
            skills.assignAll(serviceNames);
          }

          final first = results[0];
          serviceId.value = first['service']?.toString() ?? '';
          registrationId.value = first['id']?.toString() ?? '';

          String bestName = '';
          final details = first['service_details'];
          if (details != null) {
            String catName = details['category_name']?.toString() ?? '';
            String servName = details['name']?.toString() ?? '';
            if (catName.isNotEmpty && servName.isNotEmpty && servName.toLowerCase() != 'nothing') {
              bestName = "$catName - $servName";
            } else if (servName.isNotEmpty && servName.toLowerCase() != 'nothing') {
              bestName = servName;
            } else if (catName.isNotEmpty) {
              bestName = catName;
            }
          }

          if (bestName.isEmpty && serviceNames.isNotEmpty) {
            bestName = serviceNames[0];
          }

          // Force update if current profession is a placeholder or generic
          String currentProf = profession.value.toLowerCase().trim();
          if (currentProf == 'artisan' || currentProf == 'nothing' || currentProf.isEmpty) {
            if (bestName.isNotEmpty) {
              profession.value = bestName;
            }
          }

          if (serviceRate.value == '0.00' || serviceRate.value == '0') {
             serviceRate.value = first['price_override']?.toString() ?? serviceRate.value;
          }
        }
      }
    } catch (e) {}
  }

  void signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(Routes.sing_in);
  }
}