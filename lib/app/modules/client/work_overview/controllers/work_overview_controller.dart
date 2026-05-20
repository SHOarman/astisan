import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class WorkOverviewController extends GetxController {
  final booking = Rxn<Map<String, dynamic>>();

  final artisanName = "".obs;
  final profession = "".obs;
  final rating = 0.0.obs;
  final artisanImageUrl = "".obs;
  
  final completedTime = "".obs;
  final duration = "".obs;
  final serviceName = "".obs;

  final completedTasks = <String>[].obs;
  final totalAmount = "0.0".obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      booking.value = Get.arguments;
      _parseBookingData();
    }
  }

  void _parseBookingData() {
    final b = booking.value;
    if (b == null) return;
    
    final artisan = b['artisan'] is Map ? b['artisan'] : b;
    artisanName.value = b['artisan_name'] ?? artisan['name'] ?? artisan['full_name'] ?? "Artisan";
    
    final rawRating = b['artisan_rating'] ?? artisan['rating'] ?? artisan['average_rating'] ?? "0";
    rating.value = double.tryParse(rawRating.toString()) ?? 0.0;
    
    profession.value = b['artisan_occupation'] ?? artisan['occupation'] ?? artisan['category_name'] ?? "Specialist";
    
    String rawImageUrl = b['artisan_picture'] ?? artisan['profile_picture'] ?? artisan['artisan_picture'] ?? artisan['avatar'] ?? "";
    artisanImageUrl.value = rawImageUrl;

    serviceName.value = b['service_name'] ?? "Service";
    totalAmount.value = "\$${b['total_amount'] ?? '0'}";
    
    final cTimeStr = b['completed_at'] ?? b['finished_at'] ?? b['updated_at'];
    if (cTimeStr != null) {
      try {
        final parsed = DateTime.parse(cTimeStr).toLocal();
        int hour = parsed.hour;
        final period = hour >= 12 ? "PM" : "AM";
        hour = hour % 12;
        if (hour == 0) hour = 12;
        completedTime.value = "${hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')} $period";
      } catch (_) {
        completedTime.value = cTimeStr;
      }
    } else {
      completedTime.value = "N/A";
    }
    
    duration.value = b['duration'] ?? "1h 30min";
    
    final tasks = b['tasks'] ?? b['work_completed'] ?? [];
    if (tasks is List && tasks.isNotEmpty) {
      completedTasks.assignAll(tasks.map((e) => e.toString()).toList());
    } else {
      completedTasks.assignAll([
        'Service successfully completed',
      ]);
    }
  }

  void goToHome() {
    Get.offAllNamed(Routes.DASHBOARD);
  }
}
