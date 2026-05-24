import 'dart:convert';
import 'dart:async';
import 'dart:ui';
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

  final booking = Rxn<Map<String, dynamic>>();

  // Dynamic artisan/worker info
  final artisanName = "".obs;
  final rating = 0.0.obs;
  final profession = "".obs;
  final artisanImageUrl = "".obs;

  // Dynamic service info
  final serviceName = "".obs;
  final location = "".obs;
  final estimatedCost = "".obs;
  final jobStartTime = "".obs;
  final status = "".obs;

  final elapsedMinutes = 0.obs;
  final progressPercent = 0.0.obs;

  // Timeline times
  final acceptedTime = "Pending".obs;
  final onWayTime = "Pending".obs;
  final workingTime = "Pending".obs;
  final completedTime = "Pending".obs;

  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['bookingId'] != null) {
      bookingId.value = args['bookingId'];
      fetchBookingDetails();
      _refreshTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
        fetchBookingDetails();
      });
    }
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchBookingDetails() async {
    if (bookingId.value.isEmpty) return;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return;

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
      final String url = "${ApiServices.artisan_booking_detail}${bookingId.value}/";

      final response = await http.get(
        Uri.parse(url),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Authorization': 'Bearer $cleanToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        booking.value = data;
        _updateFields();
      }
    } catch (e) {
      print("Error fetching worker booking details: $e");
    }
  }

  void _updateFields() {
    final b = booking.value;
    if (b == null) return;

    final client = b['client'] is Map ? b['client'] : {};
    
    artisanName.value = client['full_name'] ?? client['name'] ?? b['client_name'] ?? "Client";
    
    final rawRating = client['avg_rating'] ?? client['rating'] ?? b['client_rating'] ?? "5.0";
    rating.value = double.tryParse(rawRating.toString()) ?? 5.0;
    
    profession.value = "Client";
    
    final String rawImageUrl = client['profile_picture'] ?? client['avatar'] ?? b['client_picture'] ?? "";
    artisanImageUrl.value = ApiServices.formatImageUrl(rawImageUrl);

    serviceName.value = b['service_name'] ?? b['category_name'] ?? "Service";
    location.value = b['address'] ?? b['full_address'] ?? "N/A";
    estimatedCost.value = "\$${b['total_amount'] ?? b['base_price'] ?? '0'}";
    
    jobStartTime.value = b['scheduled_time'] ?? b['scheduled_date'] ?? "N/A";
    
    status.value = (b['status'] ?? "").toString().toLowerCase();

    final s = status.value;
    if (s == 'completed') {
      currentStep.value = 3;
      progressPercent.value = 1.0;
      // Calculate total elapsed from start to completion
      if (b['completed_at'] != null && (b['working_at'] != null || b['arrived_at'] != null)) {
        try {
          final start = DateTime.parse(b['working_at'] ?? b['arrived_at']);
          final end = DateTime.parse(b['completed_at']);
          elapsedMinutes.value = end.difference(start).inMinutes;
        } catch (_) {
          elapsedMinutes.value = 0;
        }
      }
    } else if (s == 'working') {
      currentStep.value = 2;
      progressPercent.value = 0.75;
      
      if (b['working_at'] != null || b['started_work_at'] != null || b['arrived_at'] != null) {
        try {
          final start = DateTime.parse(b['working_at'] ?? b['started_work_at'] ?? b['arrived_at']);
          elapsedMinutes.value = DateTime.now().difference(start).inMinutes;
          if (elapsedMinutes.value < 0) elapsedMinutes.value = 0;
          // Dynamic progress based on estimated 60 min job
          progressPercent.value = (elapsedMinutes.value / 60).clamp(0.1, 0.95);
        } catch (_) {
          elapsedMinutes.value = 0;
        }
      }
    } else if (s == 'arrived') {
      currentStep.value = 2;
      progressPercent.value = 0.5;
      
      if (b['arrived_at'] != null) {
        try {
          final start = DateTime.parse(b['arrived_at']);
          elapsedMinutes.value = DateTime.now().difference(start).inMinutes;
          if (elapsedMinutes.value < 0) elapsedMinutes.value = 0;
        } catch (_) {
          elapsedMinutes.value = 0;
        }
      }
    } else if (s == 'on_way' || s == 'on_the_way' || s == 'on-the-way') {
      currentStep.value = 1;
      progressPercent.value = 0.25;
      elapsedMinutes.value = 0;
    } else {
      currentStep.value = 0;
      progressPercent.value = 0.0;
      elapsedMinutes.value = 0;
    }

    if (currentStep.value >= 0) {
      acceptedTime.value = _formatRealTime(b['accepted_at'] ?? b['confirmed_at'] ?? b['created_at']);
    }
    if (currentStep.value >= 1) {
      onWayTime.value = _formatRealTime(b['on_way_at'] ?? b['started_navigation_at']);
    }
    if (currentStep.value >= 2) {
      workingTime.value = _formatRealTime(b['arrived_at'] ?? b['working_at']);
    }
    if (currentStep.value >= 3) {
      completedTime.value = _formatRealTime(b['completed_at'] ?? b['finished_at']);
    }
  }

  String _formatRealTime(dynamic rawDateTime, {String? defaultTime}) {
    if (rawDateTime == null || rawDateTime.toString().isEmpty || rawDateTime.toString().toLowerCase() == 'null') {
      if (defaultTime != null) return defaultTime;
      return "Pending";
    }
    
    try {
      final parsed = DateTime.tryParse(rawDateTime.toString());
      if (parsed != null) {
        return _formatDateTime(parsed.toLocal());
      }
    } catch (e) {
      print("WorkerTrackingController: Error parsing timestamp: $e");
    }
    return defaultTime ?? "Pending";
  }

  String _formatDateTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour >= 12 ? "PM" : "AM";
    final minute = dt.minute.toString().padLeft(2, '0');
    return "$hour:$minute $ampm";
  }

  Future<bool> updateStatus(String newStatus) async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return false;

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
      final String url = "${ApiServices.artisan_update_status}${bookingId.value}/status/";

      print("DEBUG: Tracking - Updating status to $newStatus via POST to $url");

      final response = await http.post(
        Uri.parse(url),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Authorization': 'Bearer $cleanToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          "new_status": newStatus,
          "status": newStatus,
          "note": "",
        }),
      ).timeout(const Duration(seconds: 15));

      print("DEBUG: Tracking Response: ${response.statusCode} ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success".tr, "Status updated successfully".tr,
            backgroundColor: const Color(0xFF4CAE79),
            colorText: const Color(0xFFFFFFFF));
        fetchBookingDetails();
        return true;
      } else {
        Get.snackbar("Error".tr, "${'Failed:'.tr} ${response.body}",
            backgroundColor: const Color(0xFFFF0000),
            colorText: const Color(0xFFFFFFFF));
        return false;
      }
    } catch (e) {
      print("Error in tracking status update: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void startWorking() async {
    final success = await updateStatus("working");
    if (success) {
      status.value = 'working';
      currentStep.value = 2;
      fetchBookingDetails();
    }
  }

  void markAsComplete() {
    Get.toNamed(Routes.JOB_COMPLETION, arguments: {
      'bookingId': bookingId.value,
      'jobTitle': serviceName.value,
      'clientName': artisanName.value,
      'jobPrice': double.tryParse(estimatedCost.value.replaceAll('\$', '')) ?? 0.0,
      'jobDate': jobStartTime.value,
      'tasks': booking.value?['tasks'] ?? [],
    });
  }

  void goToChat() {
    Get.toNamed(Routes.WORKER_CHAT, arguments: {
      'id': bookingId.value,
      'name': artisanName.value,
      'profile': artisanImageUrl.value,
      'isClient': false,
    });
  }

  Future<bool> requestAdditionalCost(String reason, double amount) async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return false;

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
      final String url = "${ApiServices.baseurl}/api/bookings/artisan/${bookingId.value}/costs/";

      print("DEBUG: Requesting additional cost of $amount for reason: $reason to $url");

      final response = await http.post(
        Uri.parse(url),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Authorization': 'Bearer $cleanToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          "reason": reason,
          "amount": amount.toString(),
        }),
      ).timeout(const Duration(seconds: 15));

      print("DEBUG: Request Additional Cost Response: ${response.statusCode} ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success".tr, "Additional cost requested successfully".tr,
            backgroundColor: const Color(0xFF4CAE79),
            colorText: const Color(0xFFFFFFFF));
        fetchBookingDetails();
        return true;
      } else {
        Get.snackbar("Error".tr, "${'Failed to request additional cost:'.tr} ${response.body}",
            backgroundColor: const Color(0xFFFF0000),
            colorText: const Color(0xFFFFFFFF));
        return false;
      }
    } catch (e) {
      print("Error in requesting additional cost: $e");
      Get.snackbar("Error".tr, "An error occurred: $e".tr,
          backgroundColor: const Color(0xFFFF0000),
          colorText: const Color(0xFFFFFFFF));
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
