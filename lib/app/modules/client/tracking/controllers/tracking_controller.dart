import 'dart:convert';
import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:geolocator/geolocator.dart';
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

  // Live Tracking coordinates and calculations
  final workerLatitude = 0.0.obs;
  final workerLongitude = 0.0.obs;
  final clientLatitude = 0.0.obs;
  final clientLongitude = 0.0.obs;
  final etaMinutes = 0.obs;
  final distanceKm = 0.0.obs;
  final isLive = false.obs;

  WebSocketChannel? _wsChannel;
  StreamSubscription<Position>? _gpsSubscription;
  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      booking.value = Get.arguments;
      _updateFields();
      _startTracking();
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

    // Set times based on availability or current status using real-time dates
    if (isStatusAtLeast('confirmed')) {
      confirmationTime.value = _formatRealTime(
        b['confirmed_at'] ?? b['accepted_at'] ?? b['updated_at'],
        defaultTime: confirmationTime.value == "Pending" ? _formatDateTime(DateTime.now()) : confirmationTime.value,
      );
    }
    if (isStatusAtLeast('on_way')) {
      onWayTime.value = _formatRealTime(
        b['on_way_at'] ?? b['started_navigation_at'],
        defaultTime: onWayTime.value == "Pending" ? _formatDateTime(DateTime.now()) : onWayTime.value,
      );
    }
    if (isStatusAtLeast('working') || isStatusAtLeast('arrived')) {
      workingTime.value = _formatRealTime(
        b['working_at'] ?? b['arrived_at'],
        defaultTime: workingTime.value == "Pending" ? _formatDateTime(DateTime.now()) : workingTime.value,
      );
    }
    if (isStatusAtLeast('completed')) {
      completedTime.value = _formatRealTime(
        b['completed_at'] ?? b['finished_at'],
        defaultTime: completedTime.value == "Pending" ? _formatDateTime(DateTime.now()) : completedTime.value,
      );
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

  String _formatRealTime(dynamic rawDateTime, {String? defaultTime}) {
    if (rawDateTime == null || rawDateTime.toString().isEmpty || rawDateTime.toString().toLowerCase() == 'null') {
      if (defaultTime != null) return defaultTime;
      return _formatDateTime(DateTime.now());
    }
    
    try {
      final parsed = DateTime.tryParse(rawDateTime.toString());
      if (parsed != null) {
        return _formatDateTime(parsed.toLocal());
      }
    } catch (e) {
      print("TrackingController: Error parsing timestamp: $e");
    }
    return defaultTime ?? _formatDateTime(DateTime.now());
  }

  String _formatDateTime(DateTime dt) {
    int hour = dt.hour;
    final period = hour >= 12 ? "PM" : "AM";
    hour = hour % 12;
    if (hour == 0) hour = 12;
    final minuteStr = dt.minute.toString().padLeft(2, '0');
    return "${hour.toString().padLeft(2, '0')}:$minuteStr $period";
  }

  bool isStatusAtLeast(String targetStatus) {
    final statuses = ['requested', 'confirmed', 'on_way', 'arrived', 'working', 'completed'];
    int currentIndex = statuses.indexOf(status.value);
    int targetIndex = statuses.indexOf(targetStatus);
    return currentIndex >= targetIndex;
  }

  // Live Tracking Logic
  Future<void> _startTracking() async {
    final b = booking.value;
    if (b == null) return;

    final bookingId = (b['id'] ?? b['booking_id'] ?? '').toString();
    if (bookingId.isEmpty) return;

    // 1. Get client's current location via GPS if enabled
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        clientLatitude.value = position.latitude;
        clientLongitude.value = position.longitude;
      }
    } catch (e) {
      print("TrackingController: Error getting client location: $e");
    }

    // 2. Fetch initial location fallback from API
    await _fetchInitialLocation(bookingId);

    // 3. Connect to Tracking WebSocket
    _connectWebSocket(bookingId);

    // 4. Start periodic background polling timer to pull fresh booking details & transition times
    await _refreshBookingDetails(bookingId);
    _refreshTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
      _refreshBookingDetails(bookingId);
    });
  }

  Future<void> _refreshBookingDetails(String bookingId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? rawToken = prefs.getString('token');
      if (rawToken == null) return;
      final String token = rawToken.trim().replaceAll('"', '').replaceAll('Bearer ', '');

      final url = "${ApiServices.client_booking_detail}$bookingId/";
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        booking.value = data;
        _updateFields();
      }
    } catch (e) {
      print("TrackingController: Error refreshing booking: $e");
    }
  }

  Future<void> _fetchInitialLocation(String bookingId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? rawToken = prefs.getString('token');
      if (rawToken == null) return;
      final String token = rawToken.trim().replaceAll('"', '').replaceAll('Bearer ', '');

      final url = "${ApiServices.tracking_location}$bookingId/location/";
      print("TrackingController: Fetching initial location from $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['lat'] != null && data['lng'] != null) {
          workerLatitude.value = double.tryParse(data['lat'].toString()) ?? workerLatitude.value;
          workerLongitude.value = double.tryParse(data['lng'].toString()) ?? workerLongitude.value;
          _calculateDistanceAndETA();
        }
      }
    } catch (e) {
      print("TrackingController: Error fetching initial location: $e");
    }
  }

  void _connectWebSocket(String bookingId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? rawToken = prefs.getString('token');
      if (rawToken == null) return;
      final String token = rawToken.trim().replaceAll('"', '').replaceAll('Bearer ', '');

      final wsBaseUrl = ApiServices.baseurl.replaceFirst('https://', 'wss://').replaceFirst('http://', 'ws://');
      final wsUrl = "$wsBaseUrl/ws/tracking/$bookingId/?token=$token";

      print("TrackingController: Connecting to WebSocket: $wsUrl");

      _wsChannel = IOWebSocketChannel.connect(
        Uri.parse(wsUrl),
        headers: {
          'X-Tunnel-Skip-Anti-Phishing-Threshold': 'true',
        },
      );
      _wsChannel!.stream.listen((event) {
        print("TrackingController: Received live coordinates: $event");
        try {
          final data = json.decode(event);
          
          if (data['type'] == 'connection_established') {
            print("TrackingController: WebSocket connection established successfully: role=${data['role']}");
            isLive.value = true;
          } else if (data['type'] == 'location_update') {
            if (data['lat'] != null && data['lng'] != null) {
              workerLatitude.value = double.tryParse(data['lat'].toString()) ?? workerLatitude.value;
              workerLongitude.value = double.tryParse(data['lng'].toString()) ?? workerLongitude.value;
              isLive.value = true;
              _calculateDistanceAndETA();
            }
          } else if (data['type'] == 'session_ended') {
            print("TrackingController: WebSocket session ended.");
            isLive.value = false;
          } else if (data['type'] == 'error') {
            print("TrackingController: WebSocket Error message: ${data['message']}");
          } else {
            // Legacy / Direct coordinates fallback
            if (data['lat'] != null && data['lng'] != null) {
              workerLatitude.value = double.tryParse(data['lat'].toString()) ?? workerLatitude.value;
              workerLongitude.value = double.tryParse(data['lng'].toString()) ?? workerLongitude.value;
              isLive.value = true;
              _calculateDistanceAndETA();
            }
          }

          if (data['status'] != null) {
            status.value = data['status'].toString().toLowerCase();
            _updateFields();
          }
        } catch (err) {
          print("TrackingController: Error parsing WebSocket event: $err");
        }
      }, onError: (err) {
        print("TrackingController: WebSocket Error: $err");
        isLive.value = false;
      }, onDone: () {
        print("TrackingController: WebSocket Closed");
        isLive.value = false;
      });
    } catch (e) {
      print("TrackingController: WebSocket exception: $e");
    }
  }

  void _calculateDistanceAndETA() {
    try {
      double distanceInMeters = Geolocator.distanceBetween(
        clientLatitude.value,
        clientLongitude.value,
        workerLatitude.value,
        workerLongitude.value,
      );

      distanceKm.value = double.parse((distanceInMeters / 1000.0).toStringAsFixed(2));

      // Assume average driving speed in city traffic is about 20 km/h (approx 5.5 m/s)
      double durationInMinutes = (distanceInMeters / 5.5) / 60.0;
      etaMinutes.value = durationInMinutes.round();
      if (etaMinutes.value < 1) etaMinutes.value = 1;

      print("TrackingController: Calculated distance: ${distanceKm.value} km, ETA: ${etaMinutes.value} minutes");
    } catch (e) {
      print("TrackingController: Error calculating distance/ETA: $e");
    }
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

  @override
  void onClose() {
    _wsChannel?.sink.close();
    _gpsSubscription?.cancel();
    _refreshTimer?.cancel();
    super.onClose();
  }
}


