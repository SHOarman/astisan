import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/routes/app_routes.dart';

class WorkerTrackingController extends GetxController {
  final bookingId = "".obs;
  final isLoading = false.obs;
  // Timeline steps: 0: Job Accepted, 1: On the Way, 2: Working, 3: Completed
  final currentStep = 1.obs; 

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['bookingId'] != null) {
      bookingId.value = args['bookingId'];
    }
  }

  Future<void> updateStatus(String status) async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return;

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
      final String url = "${ApiServices.artisan_update_status}${bookingId.value}/status/";

      print("DEBUG: Tracking - Updating status to $status via POST to $url");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          "new_status": status,
          "note": "Updated via tracking screen",
        }),
      ).timeout(const Duration(seconds: 15));

      print("DEBUG: Tracking Response: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Status updated to $status");
        if (status == "working") {
          currentStep.value = 2;
        } else if (status == "completed") {
          currentStep.value = 3;
        }
      }
    } catch (e) {
      print("Error in tracking status update: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void startWorking() => updateStatus("working");

  void markAsComplete() {
    Get.toNamed(Routes.JOB_COMPLETION, arguments: {'bookingId': bookingId.value});
  }

  void goToChat() {
    Get.toNamed(Routes.CHAT, arguments: {'bookingId': bookingId.value});
  }
}
