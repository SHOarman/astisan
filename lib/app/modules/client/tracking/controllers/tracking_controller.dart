import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/Services/api_services.dart';
import '../../activity/controllers/activity_controller.dart';

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
  final routePoints = <LatLng>[].obs;
  LatLng? _lastRouteCoords;
  LatLng? _lastDestinationCoords;
  bool _isFetchingRoute = false;

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

    ever(status, (currentStatus) {
      final String lowerStatus = currentStatus.toLowerCase();
      if (lowerStatus == 'completed') {
        // Timeline updates automatically via Obx.
        // "View Completion work" button becomes enabled.
        // Client will manually click it to proceed to payment.
      } else {
        final bool isOnWay = ['on_way', 'on_the_way', 'on-the-way'].contains(lowerStatus);
        if (!isOnWay) {
          final String route = Get.currentRoute;
          if (route.contains(Routes.TRACKING) && !route.contains(Routes.TRACKINGSCREEN)) {
            Get.back();
          }
        }
      }
    });
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
    location.value = b['address'] ?? b['full_address'] ?? b['client_address'] ?? "N/A";
    final String totalAmt = b['total_amount']?.toString() ?? '0';
    if (totalAmt == '0' || totalAmt == 'null' || totalAmt.isEmpty) {
      estimatedCost.value = "Pending";
    } else {
      estimatedCost.value = "\$$totalAmt";
    }
    jobStartTime.value = b['scheduled_time'] ?? b['scheduled_date'] ?? "N/A";
    status.value = (b['status'] ?? "").toString().toLowerCase();

    // Set up location asynchronously
    _resolveClientLocation();

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

    // 1. Resolve client location
    await _resolveClientLocation();

    // 2. Fetch initial location fallback from API
    await _fetchInitialLocation(bookingId);

    // 3. Connect to Tracking WebSocket
    _connectWebSocket(bookingId);

    // 4. Start periodic background polling timer to pull fresh booking details & transition times
    await _refreshBookingDetails(bookingId);
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _refreshBookingDetails(bookingId);
    });
  }

  Future<void> _resolveClientLocation() async {
    final b = booking.value;
    if (b == null) return;

    double parsedCLat = double.tryParse(b['address_lat']?.toString() ?? b['client_latitude']?.toString() ?? b['latitude']?.toString() ?? '') ?? 0.0;
    double parsedCLng = double.tryParse(b['address_lng']?.toString() ?? b['client_longitude']?.toString() ?? b['longitude']?.toString() ?? '') ?? 0.0;

    if (parsedCLat.isNaN) parsedCLat = 0.0;
    if (parsedCLng.isNaN) parsedCLng = 0.0;

    if (parsedCLat == 0.0 || parsedCLng == 0.0) {
      final addressStr = b['address']?.toString() ?? b['full_address']?.toString() ?? '';
      if (addressStr.isNotEmpty && addressStr != "N/A") {
        try {
          final locations = await locationFromAddress(addressStr);
          if (locations.isNotEmpty) {
            parsedCLat = locations.first.latitude;
            parsedCLng = locations.first.longitude;
            print("TrackingController: Geocoded client address to $parsedCLat, $parsedCLng");
          }
        } catch (e) {
          print("TrackingController: Geocoding failed: $e");
        }
      }
    }

    if (parsedCLat != 0.0 && parsedCLng != 0.0 && _isValidLatLng(parsedCLat, parsedCLng)) {
      clientLatitude.value = parsedCLat;
      clientLongitude.value = parsedCLng;
    }
    _calculateDistanceAndETA();
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
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        booking.value = data;
        _updateFields();

        // Stop polling once job is completed or cancelled
        final String newStatus = (data['status'] ?? '').toString().toLowerCase();
        if (newStatus == 'completed' || newStatus == 'cancelled') {
          _refreshTimer?.cancel();
          _refreshTimer = null;
        }
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
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['lat'] != null && data['lng'] != null) {
          double wLat = double.tryParse(data['lat'].toString()) ?? 0.0;
          double wLng = double.tryParse(data['lng'].toString()) ?? 0.0;
          if (!wLat.isNaN && wLat != 0.0) workerLatitude.value = wLat;
          if (!wLng.isNaN && wLng != 0.0) workerLongitude.value = wLng;
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
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
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
              double wLat = double.tryParse(data['lat'].toString()) ?? 0.0;
              double wLng = double.tryParse(data['lng'].toString()) ?? 0.0;
              if (!wLat.isNaN && wLat != 0.0) workerLatitude.value = wLat;
              if (!wLng.isNaN && wLng != 0.0) workerLongitude.value = wLng;
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
              double wLat = double.tryParse(data['lat'].toString()) ?? 0.0;
              double wLng = double.tryParse(data['lng'].toString()) ?? 0.0;
              if (!wLat.isNaN && wLat != 0.0) workerLatitude.value = wLat;
              if (!wLng.isNaN && wLng != 0.0) workerLongitude.value = wLng;
              isLive.value = true;
              _calculateDistanceAndETA();
            }
          }

          if (data['status'] != null) {
            String newStatus = data['status'].toString().toLowerCase();
            status.value = newStatus;
            _updateFields();
            // Immediately trigger a booking refresh to get completed_at timestamp etc.
            _refreshBookingDetails(bookingId);
            if (Get.isRegistered<ActivityController>()) {
               Get.find<ActivityController>().updateBookingStatusLocally(bookingId, newStatus);
            }
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
      if (clientLatitude.value == 0.0 || workerLatitude.value == 0.0) return;

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

      // Asynchronously fetch street routing points
      _fetchRoute(workerLatitude.value, workerLongitude.value, clientLatitude.value, clientLongitude.value);
    } catch (e) {
      print("TrackingController: Error calculating distance/ETA: $e");
    }
  }

  Future<void> _fetchRoute(double startLat, double startLng, double endLat, double endLng) async {
    if (_isFetchingRoute) return;
    if (!_isValidLatLng(startLat, startLng) || !_isValidLatLng(endLat, endLng)) return;

    if (_lastRouteCoords != null && _lastDestinationCoords != null &&
        Geolocator.distanceBetween(
          _lastRouteCoords!.latitude,
          _lastRouteCoords!.longitude,
          startLat,
          startLng,
        ) < 10 &&
        Geolocator.distanceBetween(
          _lastDestinationCoords!.latitude,
          _lastDestinationCoords!.longitude,
          endLat,
          endLng,
        ) < 10 &&
        routePoints.isNotEmpty) {
      return;
    }

    _isFetchingRoute = true;
    _lastRouteCoords = LatLng(startLat, startLng);
    _lastDestinationCoords = LatLng(endLat, endLng);

    try {
      final routeData = await ApiServices.fetchRouteData(startLat, startLng, endLat, endLng);
      if (routeData != null && routeData.points.isNotEmpty) {
        routePoints.assignAll(routeData.points);

        // Update with OSRM driving metrics if available
        distanceKm.value = double.parse((routeData.distanceMeters / 1000.0).toStringAsFixed(2));

        int etaMin = (routeData.durationSeconds / 60.0).round();
        if (etaMin < 1) etaMin = 1;
        etaMinutes.value = etaMin;
      }
    } catch (e) {
      print("TrackingController: Error fetching route: $e");
    } finally {
      _isFetchingRoute = false;
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
    final b = booking.value ?? {};
    Get.toNamed(Routes.WORK_OVERVIEW, arguments: {
      ...b,
      '_fromTracking': true,
    });
  }

  Future<void> respondToAdditionalCost(String costId, String action) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? rawToken = prefs.getString('token');
      if (rawToken == null) return;
      final String token = rawToken.trim().replaceAll('"', '').replaceAll('Bearer ', '');

      final b = booking.value;
      if (b == null) return;
      final bookingId = (b['id'] ?? b['booking_id'] ?? '').toString();

      final url = "${ApiServices.baseurl}/api/bookings/client/$bookingId/costs/$costId/respond/";
      
      final bool isApprove = action == 'approve';
      final response = await http.post(
        Uri.parse(url),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          "approve": isApprove,
        }),
      );

      print("DEBUG: Respond to cost response status=${response.statusCode} body=${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Response submitted successfully",
            backgroundColor: const Color(0xFF4CAE79),
            colorText: const Color(0xFFFFFFFF));
        _refreshBookingDetails(bookingId);
      } else {
        Get.snackbar("Error", "Failed to respond: ${response.body}",
            backgroundColor: const Color(0xFFFF0000),
            colorText: const Color(0xFFFFFFFF));
      }
    } catch (e) {
      print("Error responding to cost: $e");
      Get.snackbar("Error", "An error occurred: $e",
          backgroundColor: const Color(0xFFFF0000),
          colorText: const Color(0xFFFFFFFF));
    }
  }

  bool _isValidLatLng(double lat, double lng) {
    return !lat.isNaN && !lat.isInfinite &&
        !lng.isNaN && !lng.isInfinite &&
        lat >= -90 && lat <= 90 &&
        lng >= -180 && lng <= 180;
  }

  @override
  void onClose() {
    _wsChannel?.sink.close();
    _gpsSubscription?.cancel();
    _refreshTimer?.cancel();
    super.onClose();
  }
}


