import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/Services/api_services.dart';

class TrackingController extends GetxController {
  final booking = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;

  // Observable fields for UI
  final artisanName = "".obs;
  final rating = 0.0.obs;
  final profession = "".obs;
  final artisanImageUrl = "".obs;
  final serviceName = "".obs;
  final location = "".obs;
  final estimatedCost = "".obs;
  final jobStartTime = "".obs;
  final status = "".obs;
  final confirmationTime = "Pending".obs;
  final onWayTime = "Pending".obs;
  final workingTime = "Pending".obs;
  final completedTime = "Pending".obs;

  final elapsedMinutes = 0.obs;
  final progressPercent = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      booking.value = Get.arguments;
      _updateFields();
    }
  }

  void _updateFields() {
    final b = booking.value;
    if (b == null) return;

    // Check if artisan data is nested or flat
    final artisan = b['artisan'] is Map ? b['artisan'] : b;

    artisanName.value = b['artisan_name'] ?? artisan['name'] ?? artisan['full_name'] ?? "Artisan";
    
    // Improved rating retrieval
    final rawRating = b['artisan_rating'] ?? artisan['rating'] ?? artisan['average_rating'] ?? "0";
    rating.value = double.tryParse(rawRating.toString()) ?? 0.0;
    
    profession.value = b['artisan_occupation'] ?? artisan['occupation'] ?? artisan['category_name'] ?? "Specialist";
    
    // Robust image retrieval
    String rawImageUrl = b['artisan_picture'] ?? 
                           artisan['profile_picture'] ?? 
                           artisan['artisan_picture'] ?? 
                           artisan['avatar'] ?? "";
    artisanImageUrl.value = ApiServices.formatImageUrl(rawImageUrl);
                           
    serviceName.value = b['service_name'] ?? "Service";
    location.value = b['address'] ?? "N/A";
    estimatedCost.value = "\$${b['total_amount'] ?? '0'}";
    jobStartTime.value = b['scheduled_time'] ?? b['scheduled_date'] ?? "N/A";
    status.value = (b['status'] ?? "").toString().toLowerCase();

    // Set times based on availability or current status
    if (isStatusAtLeast('confirmed')) {
      confirmationTime.value = b['confirmed_at'] ?? "09:45 AM"; // Fallback placeholder
    }
    if (isStatusAtLeast('on_way')) {
      onWayTime.value = b['on_way_at'] ?? "10:00 AM";
    }
    if (isStatusAtLeast('working')) {
      workingTime.value = b['working_at'] ?? "10:18 AM";
    }
    if (isStatusAtLeast('completed')) {
      completedTime.value = b['completed_at'] ?? "11:00 AM";
    }

    // Mock progress based on status
    if (status.value == 'working') {
      progressPercent.value = 0.75;
      elapsedMinutes.value = 34;
    } else if (status.value == 'on_way' || status.value == 'arrived') {
      progressPercent.value = 0.3;
      elapsedMinutes.value = 10;
    } else if (status.value == 'completed') {
      progressPercent.value = 1.0;
    } else {
      progressPercent.value = 0.0;
    }
  }

  bool isStatusAtLeast(String targetStatus) {
    final statuses = ['requested', 'confirmed', 'on_way', 'arrived', 'working', 'completed'];
    int currentIndex = statuses.indexOf(status.value);
    int targetIndex = statuses.indexOf(targetStatus);
    return currentIndex >= targetIndex;
  }

  void goToChat() {
    final b = booking.value ?? {};
    Get.toNamed(Routes.CHAT, arguments: {
      'id': b['booking_id'] ?? b['id'] ?? '',
      'name': artisanName.value,
      'profile': artisanImageUrl.value,
      'isClient': true,
      'isOnline': true,
    });
  }

  void viewCompletionWork() {
    Get.toNamed(Routes.WORK_OVERVIEW);
  }
}

