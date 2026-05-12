import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/Services/api_services.dart';

class WorkerHomeController extends GetxController {
  final isOnline = true.obs;
  
  // Real Data from API
  final userName = 'Loading...'.obs;
  final userEmail = '...'.obs;
  final phoneNumber = '...'.obs;
  final profilePicture = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentStatus();
  }

  Future<void> fetchCurrentStatus() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return;
      
      final String cleanToken = token.trim().replaceAll('"', '');

      final response = await http.get(
        Uri.parse(ApiServices.artisan_profile),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Updating Identity Data
        userName.value = data['full_name'] ?? '';
        userEmail.value = data['email'] ?? '';
        phoneNumber.value = data['phone'] ?? '';
        profilePicture.value = ApiServices.formatImageUrl(data['profile_picture']?.toString());
        
        final artisan = data['artisan_profile'];
        if (artisan != null) {
          isOnline.value = artisan['is_online'] ?? true;
        }
      }
    } catch (e) {
      print("DEBUG: Dashboard status fetch error: $e");
    }
  }

  Future<void> toggleStatus(bool value) async {
    isOnline.value = value;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return;
      
      final String cleanToken = token.trim().replaceAll('"', '');

      final response = await http.post(
        Uri.parse(ApiServices.artisan_toggle_online),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        isOnline.value = data['is_online'] ?? value;
      }
    } catch (e) {
      print("DEBUG: Dashboard toggle error: $e");
    }
  }

  void goToJobDetails() {
    Get.toNamed(Routes.WORKER_JOB_DETAILS);
  }

  void goToChat() {
    Get.toNamed(Routes.WORKER_CHAT);
  }

  // Dummy data for list rendering
  final scheduleItems = [
    {
      'title': 'Pipe Leak Repair',
      'client': 'Alex Thompson',
      'time': '10:00 AM',
      'distance': '1.8 km',
      'price': '\$75',
      'duration': '2 hrs',
      'status': 'ONGOING',
    },
    {
      'title': 'Faucet Installation',
      'client': 'Maria Santos',
      'time': '2:00 PM',
      'distance': '3.2 km',
      'price': '\$55',
      'duration': '1 hr',
      'status': 'UPCOMING',
    },
    {
      'title': 'Bathroom Remodeling',
      'client': 'Robert Chen',
      'time': '9:00 AM',
      'distance': '5.1 km',
      'price': '\$200',
      'duration': '4 hrs',
      'status': 'UPCOMING',
    },
  ].obs;

  final weeklySummary = [
    {
      'icon': '💰',
      'value': '\$425',
      'label': 'Earnings',
    },
    {
      'icon': '✅',
      'value': '8',
      'label': 'Jobs Done',
    },
    {
      'icon': '⭐',
      'value': '4.9★',
      'label': 'Avg Rating',
    },
  ].obs;
}

