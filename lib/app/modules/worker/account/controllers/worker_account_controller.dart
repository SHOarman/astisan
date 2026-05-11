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
  
  // Missing fields restored
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
    profilePicture.value = prefs.getString('user_profile_pic') ?? '';
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

        userName.value = data['full_name']?.toString() ?? userName.value;
        userEmail.value = data['email']?.toString() ?? '';
        userPhone.value = data['phone']?.toString() ?? '';
        profilePicture.value = data['profile_picture']?.toString() ?? '';

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
              skills.assignAll(artisan['skills'].toString().split(',').map((e) => e.trim()).toList());
            } else if (artisan['skills'] is List) {
              skills.assignAll(List<String>.from(artisan['skills']));
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
          final first = results[0];
          
          // Store these for Edit Profile usage
          serviceId.value = first['service']?.toString() ?? '';
          registrationId.value = first['id']?.toString() ?? '';

          if (profession.value == 'Artisan' || profession.value.isEmpty) {
            final details = first['service_details'];
            if (details != null && details['name'] != null) {
              profession.value = details['name'].toString();
            } else if (first['service_name'] != null) {
              profession.value = first['service_name'].toString();
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