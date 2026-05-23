import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/global_controllers/location_controller.dart';

// ─── Model ───────────────────────────────────────────────────────────────────
class ScheduleBooking {
  final String id;
  final String bookingId;
  final String clientName;
  final String clientPicture;
  final String serviceName;
  final String clientAvgRating;
  final String status;
  final String distanceKm;
  final String scheduledDate;
  final String scheduledTime;
  final String fullAddress;
  final String basePrice;
  final String completionTime;
  final String createdAt;

  ScheduleBooking({
    required this.id,
    required this.bookingId,
    required this.clientName,
    required this.clientPicture,
    required this.serviceName,
    required this.clientAvgRating,
    required this.status,
    required this.distanceKm,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.fullAddress,
    required this.basePrice,
    required this.completionTime,
    required this.createdAt,
  });

  factory ScheduleBooking.fromJson(Map<String, dynamic> json) {
    // Parse base_price - may be null, "-", or a number string
    String price = '0';
    final rawPrice = json['base_price'];
    if (rawPrice != null &&
        rawPrice.toString().isNotEmpty &&
        rawPrice.toString() != '-' &&
        rawPrice.toString() != 'null') {
      final parsed = double.tryParse(rawPrice.toString());
      if (parsed != null) {
        price = parsed % 1 == 0
            ? parsed.toInt().toString()
            : parsed.toStringAsFixed(2);
      } else {
        price = rawPrice.toString();
      }
    }

    return ScheduleBooking(
      id: json['id']?.toString() ?? '',
      bookingId: json['booking_id']?.toString() ?? '',
      clientName: json['client_name']?.toString() ?? 'Client',
      clientPicture: ApiServices.formatImageUrl(
        json['client_picture']?.toString(),
      ),
      serviceName: json['service_name']?.toString() ?? '',
      clientAvgRating: json['client_avg_rating']?.toString() ?? '0',
      status: json['status']?.toString() ?? '',
      distanceKm: json['distance_km']?.toString() ?? '',
      scheduledDate: json['scheduled_date']?.toString() ?? '',
      scheduledTime: json['scheduled_time']?.toString() ?? '',
      fullAddress: json['full_address']?.toString() ?? '',
      basePrice: price,
      completionTime: json['completion_time']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  /// Derives a display-friendly card status label matching the UI mockups
  String get cardStatus {
    final s = status.toLowerCase();
    if (s == 'working') return 'Working';
    if (s == 'on_way' || s == 'on_the_way' || s == 'on-the-way')
      return 'On the Way';
    if (s == 'arrived') return 'Arrived';
    if (s == 'completed') return 'Completed';
    if (s == 'cancelled') return 'Cancelled';
    if (s == 'rejected') return 'Rejected';
    if (s == 'requested' || s == 'confirmed' || s == 'accepted')
      return 'Accept by you';
    return 'Upcoming';
  }

  /// Formats scheduled_time ("17:39:08.455Z") into "5:39 PM"
  String get formattedTime {
    try {
      final parts = scheduledTime.split(':');
      if (parts.length < 2) return scheduledTime;
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      return '${hour}:${minute.toString().padLeft(2, '0')} $period';
    } catch (_) {
      return scheduledTime;
    }
  }
}
// ─────────────────────────────────────────────────────────────────────────────

class WorkerHomeController extends GetxController {
  final isOnline = true.obs;
  final isScheduleLoading = false.obs;

  // Real Data from API
  final userName = 'Loading...'.obs;
  final userEmail = '...'.obs;
  final phoneNumber = '...'.obs;
  final profilePicture = ''.obs;

  // Today's schedule from API
  final scheduleBookings = <ScheduleBooking>[].obs;

  /// How often to silently re-poll the schedule endpoint (real-time feel)
  static const _pollInterval = Duration(seconds: 30);
  Timer? _scheduleTimer;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentStatus();
    // First load — show spinner
    fetchTodaySchedule();
    // Subsequent silent polls every 30 s — cards update without flash
    _scheduleTimer = Timer.periodic(
      _pollInterval,
      (_) => _silentRefreshSchedule(),
    );
  }

  @override
  void onClose() {
    _scheduleTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchCurrentStatus() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return;

      final String cleanToken = token.trim().replaceAll('"', '');

      final response = await http.get(
        Uri.parse(ApiServices.artisan_profile),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
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
        profilePicture.value = ApiServices.formatImageUrl(
          data['profile_picture']?.toString(),
        );

        final artisan = data['artisan_profile'];
        if (artisan != null) {
          isOnline.value = artisan['is_online'] ?? true;
        }
      }
    } catch (e) {
      print("DEBUG: Dashboard status fetch error: $e");
    }
  }

  /// Fetches today's scheduled bookings (shows loading spinner — for first load / pull-to-refresh).
  Future<void> fetchTodaySchedule() async {
    isScheduleLoading.value = true;
    await _doFetchSchedule();
    isScheduleLoading.value = false;
  }

  /// Silent background refresh — does NOT touch isScheduleLoading so UI never flashes.
  Future<void> _silentRefreshSchedule() async {
    await _doFetchSchedule();
  }

  /// Core fetch logic shared by both the initial load and the periodic timer.
  Future<void> _doFetchSchedule() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null || token.isEmpty) {
        print("DEBUG: No token found for schedule fetch");
        return;
      }

      final String cleanToken = token
          .trim()
          .replaceAll('"', '')
          .replaceAll('Bearer ', '');
      
      // Use artisan_bookings to get all bookings and filter manually for today's accepted ones
      final url = ApiServices.artisan_bookings;
      print("DEBUG: Fetching bookings from: $url");

      final response = await http
          .get(
            Uri.parse(url),
            headers: { 'Accept-Language': ApiServices.currentLanguage, 
              'Authorization': 'Bearer $cleanToken',
              'Accept': 'application/json',
              'X-Tunnel-Skip-Anti-Phishing-Threshold': 'true',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = (data is List)
            ? data
            : (data['results'] as List? ?? []);

        final DateTime now = DateTime.now();
        final String todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

        final newBookings = results
            .map((e) => ScheduleBooking.fromJson(e as Map<String, dynamic>))
            .where((b) {
              final status = b.status.toLowerCase();
              // Statuses that count as "accepted" or "in progress"
              final bool isAcceptedOrInProgress = [
                'confirmed', 
                'accepted', 
                'on_way', 
                'on_the_way', 
                'on-the-way', 
                'arrived', 
                'working'
              ].contains(status);
              
              if (!isAcceptedOrInProgress) return false;
              
              // Filter by today's date
              if (b.scheduledDate.isEmpty) return false;
              final String bookingDate = b.scheduledDate.contains('T') 
                  ? b.scheduledDate.split('T')[0] 
                  : b.scheduledDate;
                  
              return bookingDate == todayStr;
            })
            .toList();

        if (_hasChanges(newBookings)) {
          scheduleBookings.assignAll(newBookings);
        }
      }
else {
        print(
          "DEBUG: fetchTodaySchedule non-200: ${response.statusCode} ${response.body}",
        );
      }
    } catch (e) {
      print("DEBUG: fetchTodaySchedule error: $e");
    }
  }

  /// Compares current list with newly fetched list by id+status to skip redundant rebuilds.
  bool _hasChanges(List<ScheduleBooking> incoming) {
    if (incoming.length != scheduleBookings.length) return true;
    for (int i = 0; i < incoming.length; i++) {
      if (incoming[i].id != scheduleBookings[i].id ||
          incoming[i].status != scheduleBookings[i].status) {
        return true;
      }
    }
    return false;
  }

  void updateBookingStatusLocally(String targetId, String newStatus) {
    int index = scheduleBookings.indexWhere((b) => b.id == targetId || b.bookingId == targetId);
    if (index != -1) {
      final old = scheduleBookings[index];
      scheduleBookings[index] = ScheduleBooking(
        id: old.id,
        bookingId: old.bookingId,
        clientName: old.clientName,
        clientPicture: old.clientPicture,
        serviceName: old.serviceName,
        clientAvgRating: old.clientAvgRating,
        status: newStatus,
        distanceKm: old.distanceKm,
        scheduledDate: old.scheduledDate,
        scheduledTime: old.scheduledTime,
        fullAddress: old.fullAddress,
        basePrice: old.basePrice,
        completionTime: old.completionTime,
        createdAt: old.createdAt,
      );
      scheduleBookings.refresh();
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
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
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

  void handleJobTap(ScheduleBooking booking) {
    final status = booking.status.toLowerCase();
    final args = {
      'bookingId': booking.id,
      'initialData': {
        'booking_id': booking.bookingId,
        'client_name': booking.clientName,
        'client_picture': booking.clientPicture,
        'service_name': booking.serviceName,
        'full_address': booking.fullAddress,
        'base_price': booking.basePrice,
      },
    };

    if (status == 'on_way' ||
        status == 'on_the_way' ||
        status == 'on-the-way') {
      Get.toNamed(Routes.WORKER_NAVIGATION, arguments: args);
    } else if (status == 'arrived' || status == 'working') {
      Get.toNamed(Routes.WORKER_TRACKING, arguments: args);
    } else {
      Get.toNamed(Routes.WORKER_JOB_DETAILS, arguments: args);
    }
  }

  void goToChat() {
    Get.toNamed(Routes.WORKER_CHAT);
  }

  final weeklySummary = [
    {'icon': '💰', 'value': '\$425', 'label': 'Earnings'},
    {'icon': '✅', 'value': '8', 'label': 'Jobs Done'},
    {'icon': '⭐', 'value': '4.9★', 'label': 'Avg Rating'},
  ].obs;
}
