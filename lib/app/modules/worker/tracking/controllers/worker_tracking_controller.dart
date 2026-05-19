import 'dart:convert';
import 'dart:async';
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
        headers: {
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
      elapsedMinutes.value = 34;
    } else if (s == 'working') {
      currentStep.value = 2;
      progressPercent.value = 0.75;
      
      if (b['started_work_at'] != null || b['working_at'] != null) {
        try {
          final start = DateTime.parse(b['started_work_at'] ?? b['working_at']);
          elapsedMinutes.value = DateTime.now().difference(start).inMinutes;
          if (elapsedMinutes.value < 0) elapsedMinutes.value = 0;
        } catch (_) {
          elapsedMinutes.value = 34;
        }
      } else {
        elapsedMinutes.value = 34;
      }
    } else if (s == 'on_way' || s == 'on_the_way' || s == 'on-the-way' || s == 'arrived') {
      currentStep.value = 1;
      progressPercent.value = 0.30;
      elapsedMinutes.value = 10;
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
      workingTime.value = _formatRealTime(b['working_at'] ?? b['arrived_at']);
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
        fetchBookingDetails();
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
    Get.toNamed(Routes.WORKER_CHAT, arguments: {
      'id': bookingId.value,
      'name': artisanName.value,
      'profile': artisanImageUrl.value,
      'isClient': false,
    });
  }
}
