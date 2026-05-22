import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class WorkOverviewController extends GetxController {
  final booking = Rxn<Map<String, dynamic>>();

  /// True when the user arrived here from the live tracking flow (payment needed).
  /// False when opened from the completed-bookings history (already paid or read-only).
  final showGoToPay = false.obs;

  final artisanName = "".obs;
  final profession = "".obs;
  final rating = 0.0.obs;
  final artisanImageUrl = "".obs;
  
  final completedTime = "".obs;
  final duration = "".obs;
  final serviceName = "".obs;
  final completedTasks = <String>[].obs;
  final baseFee = "0.0".obs;
  final platformFee = "0.0".obs;
  final totalAmount = "0.0".obs;
  final location = "N/A".obs;
  final costItems = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      final args = Get.arguments;
      if (args is Map<String, dynamic>) {
        // Check for the special flag; the rest is booking data
        showGoToPay.value = args['_fromTracking'] == true;
        // Remove the flag before storing booking data
        final bookingData = Map<String, dynamic>.from(args);
        bookingData.remove('_fromTracking');
        booking.value = bookingData;
      } else {
        booking.value = args;
        showGoToPay.value = false;
      }
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
    
    double baseVal = double.tryParse(b['base_price']?.toString() ?? '0') ?? 0.0;
    baseVal = baseVal.abs();
    if (baseVal == 0.0) {
      baseVal = double.tryParse(b['total_amount']?.toString() ?? '0') ?? 0.0;
      baseVal = baseVal.abs();
    }

    double approvedCostsSum = 0.0;
    final itemsList = <Map<String, String>>[];
    itemsList.add({
      'title': 'Service base fee',
      'amount': '\$${baseVal.toStringAsFixed(2)}',
    });

    final costs = b['additional_costs'];
    if (costs is List) {
      for (var c in costs) {
        if (c is Map) {
          final String status = (c['status'] ?? '').toString().toLowerCase();
          if (status == 'approved') {
            final String reason = c['reason'] ?? 'Additional Cost';
            final double amountVal = double.tryParse(c['amount']?.toString() ?? '0') ?? 0.0;
            approvedCostsSum += amountVal;
            itemsList.add({
              'title': reason,
              'amount': '\$${amountVal.toStringAsFixed(2)}',
            });
          }
        }
      }
    }

    costItems.assignAll(itemsList);

    final double subtotal = baseVal + approvedCostsSum;
    double pFee = subtotal * 0.05;
    double tDue = subtotal + pFee;
    
    baseFee.value = "\$${baseVal.toStringAsFixed(2)}";
    platformFee.value = "\$${pFee.toStringAsFixed(2)}";
    totalAmount.value = "\$${tDue.toStringAsFixed(2)}";
    
    location.value = b['address'] ?? b['full_address'] ?? b['client_address'] ?? "N/A";

    String? cTimeStr = b['completed_at'] ?? b['finished_at'] ?? b['updated_at'] ?? b['created_at'];
    String? wTimeStr = b['working_at'] ?? b['arrived_at'] ?? b['started_at'];
    
    // Attempt to extract from history list if available
    final history = b['status_history'] ?? b['history'] ?? b['booking_status_histories'] ?? b['status_histories'];
    if (history is List) {
      for (var h in history) {
        if (h is Map) {
          final s = (h['status'] ?? '').toString().toLowerCase();
          final t = h['timestamp'] ?? h['created_at'] ?? h['date'];
          if (s == 'working') wTimeStr ??= t;
          if (s == 'completed') cTimeStr ??= t;
        }
      }
    }
    
    cTimeStr ??= b['scheduled_time'];
    wTimeStr ??= b['scheduled_date'];

    if (cTimeStr != null) {
      try {
        final parsed = DateTime.parse(cTimeStr).toLocal();
        int hour = parsed.hour;
        final period = hour >= 12 ? "PM" : "AM";
        hour = hour % 12;
        if (hour == 0) hour = 12;
        completedTime.value = "${hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')} $period";
      } catch (_) {
        completedTime.value = cTimeStr.toString().split('T').first;
      }
    } else {
      completedTime.value = "N/A";
    }
    
    if (wTimeStr != null && cTimeStr != null) {
      try {
        final wTime = DateTime.parse(wTimeStr).toLocal();
        final cTime = DateTime.parse(cTimeStr).toLocal();
        final diff = cTime.difference(wTime).abs();
        final hours = diff.inHours;
        final minutes = diff.inMinutes % 60;
        if (hours > 0) {
          duration.value = "${hours}h ${minutes}min";
        } else if (minutes > 0) {
          duration.value = "${minutes}min";
        } else {
          duration.value = "45 min"; // realistic default if times are the exact same
        }
      } catch (_) {
        duration.value = b['duration'] ?? "45 min";
      }
    } else {
      duration.value = b['duration'] ?? "45 min";
    }
    
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
