import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/components/success_dialog.dart';
import '../../../../core/routes/app_routes.dart';
import '../views/worker_image_view.dart';
import '../views/start_work_dialog.dart';

class WorkerJobDetailsController extends GetxController {
  final isLoading = false.obs;
  final bookingId = "".obs;
  final displayBookingId = "".obs;

  // Client Info
  final clientName = "Loading...".obs;
  final clientAddress = "".obs;
  final clientRating = 0.0.obs;
  final clientImage = "".obs;
  final clientBio = "No bio available".obs;

  // Service Info
  final serviceName = "".obs;
  final paymentAmount = 0.0.obs;
  final scheduledTime = "".obs;
  final distance = "".obs;
  final arrivalTime = "12 min".obs;
  final clientNotes = "".obs;
  final attachmentName = "Attachment".obs;
  final attachmentImage = "".obs;

  final checklist = <Map<String, dynamic>>[].obs;
  final bookingStatus = "".obs;

  // Location Tracking Fields
  final currentLatitude = 0.0.obs;
  final currentLongitude = 0.0.obs;
  final clientLatitude = 0.0.obs;
  final clientLongitude = 0.0.obs;
  final isSharingLocation = false.obs;
  final routePoints = <LatLng>[].obs;

  // Whether coordinates are ready and valid for the map to render
  final locationReady = false.obs;

  LatLng? _lastRouteCoords;
  bool _isFetchingRoute = false;
  LatLng? _pendingRouteFetchOrigin;

  WebSocketChannel? _trackingChannel;
  Timer? _pingTimer;
  Timer? _simulationTimer;
  StreamSubscription<Position>? _gpsStreamSubscription;

  // ─── NaN Safety Helper ────────────────────────────────────────────────────
  // Returns [fallback] if [value] is NaN, infinite, or zero (when zero is invalid)
  double _safeCoord(double? value, double fallback) {
    if (value == null) return fallback;
    if (value.isNaN || value.isInfinite) return fallback;
    return value;
  }

  bool _isValidLatLng(double lat, double lng) {
    return !lat.isNaN && !lat.isInfinite &&
        !lng.isNaN && !lng.isInfinite &&
        lat >= -90 && lat <= 90 &&
        lng >= -180 && lng <= 180;
  }
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['bookingId'] != null) {
      bookingId.value = args['bookingId'];

      if (args['initialData'] != null) {
        final data = args['initialData'];
        clientName.value = data['client_name'] ?? clientName.value;
        clientImage.value = ApiServices.formatImageUrl(data['client_picture']?.toString());
        serviceName.value = data['service_name'] ?? serviceName.value;
        clientAddress.value = data['full_address'] ?? clientAddress.value;
        paymentAmount.value = double.tryParse(data['base_price']?.toString() ?? '0.0') ?? 0.0;
        displayBookingId.value = data['booking_id'] ?? displayBookingId.value;
      }

      fetchJobDetails();
    }
  }

  Future<void> fetchJobDetails() async {
    isLoading.value = true;

    // if (clientName.value == "Loading..." || clientName.value.isEmpty) {
    //   clientName.value = "ahmed Arman";
    //   clientAddress.value = "43 Mohakhali C/A, 1212, Dhaka, Bangladesh";
    //   clientRating.value = 4.8;
    //   clientBio.value = "Professional AC servicing client requiring quick leaking check and repair.";
    //   serviceName.value = "AC Service";
    //   paymentAmount.value = 150.0;
    //   scheduledTime.value = "2026-05-18 at 10:00 AM";
    //   clientNotes.value = "Leaking issue under the main unit. Please inspect both indoor and outdoor units.";
    //   attachmentName.value = "Pipe leak Image";
    //   attachmentImage.value = "https://images.unsplash.com/photo-1584622650111-993a426fbf0a?q=80&w=1000";
    //   displayBookingId.value = bookingId.value.isNotEmpty ? bookingId.value : "FG202605167327";
    //   bookingStatus.value = "accepted";
    // }

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) {
        isLoading.value = false;
        return;
      }

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');

      final response = await http.get(
        Uri.parse("${ApiServices.artisan_booking_detail}${bookingId.value}/"),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Accept': 'application/json',
          'X-Tunnel-Skip-Anti-Phishing-Threshold': 'true',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['id'] != null) {
          bookingId.value = data['id'].toString();
        }
        final client = data['client'];
        if (client != null) {
          clientName.value = client['full_name'] ?? 'Client';
          clientRating.value = double.tryParse(client['avg_rating']?.toString() ?? '0.0') ?? 0.0;
          clientImage.value = ApiServices.formatImageUrl(client['profile_picture']);
          clientBio.value = client['bio'] ?? client['about'] ?? "No bio available";
        }

        clientAddress.value = data['full_address'] ?? '';

        // ── Safe parse client coordinates ──────────────────────────────────
        final double parsedCLat = double.tryParse(
            data['address_lat']?.toString() ?? data['client_latitude']?.toString() ?? data['latitude']?.toString() ?? ''
        ) ?? 0.0;
        final double parsedCLng = double.tryParse(
            data['address_lng']?.toString() ?? data['client_longitude']?.toString() ?? data['longitude']?.toString() ?? ''
        ) ?? 0.0;

        // Only write if valid — never let NaN into the observables
        if (_isValidLatLng(parsedCLat, parsedCLng) && parsedCLat != 0.0 && parsedCLng != 0.0) {
          clientLatitude.value = parsedCLat;
          clientLongitude.value = parsedCLng;
        } else {
          // Dhaka fallback if API gave us nothing
          clientLatitude.value = 23.8103;
          clientLongitude.value = 90.4125;
        }
        // ───────────────────────────────────────────────────────────────────

        _updateDistanceAndETA();
        serviceName.value = data['service_name'] ?? '';
        paymentAmount.value = double.tryParse(data['total_amount']?.toString() ?? '0.0') ?? 0.0;
        displayBookingId.value = data['booking_id'] ?? '';
        bookingStatus.value = (data['status'] ?? '').toString().toLowerCase();

        String date = data['scheduled_date'] ?? '';
        String time = data['scheduled_time'] ?? '';
        scheduledTime.value = "$date at ${time.split('.').first}";
        clientNotes.value = data['additional_notes'] ?? 'No notes provided';

        String foundImageUrl = "";
        if (data['image'] != null) {
          if (data['image'] is Map && data['image']['image'] != null) {
            foundImageUrl = data['image']['image'].toString();
          } else if (data['image'] is String) {
            foundImageUrl = data['image'].toString();
          }
        }
        if (foundImageUrl.isEmpty && data['booking_image'] != null) {
          foundImageUrl = data['booking_image'].toString();
        }
        if (foundImageUrl.isEmpty && data['attachment'] != null) {
          foundImageUrl = data['attachment'].toString();
        }
        if (foundImageUrl.isEmpty && data['file'] != null) {
          foundImageUrl = data['file'].toString();
        }
        if (foundImageUrl.trim().toLowerCase() == 'string') {
          foundImageUrl = "";
        }
        if (foundImageUrl.isNotEmpty) {
          attachmentImage.value = ApiServices.formatImageUrl(foundImageUrl);
          attachmentName.value = "Pipe leak Image";
        }

        if (data['checklist_items'] != null) {
          checklist.assignAll((data['checklist_items'] as List).map((e) => {
            'title': e['label'],
            'checked': e['is_done'],
            'id': e['id'],
          }).toList());
        }
      } else {
        print("WorkerJobDetailsController: Non-200 response: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching job details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateStatus(String status, {String note = ""}) async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return false;

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
      final String url = "${ApiServices.artisan_update_status}${bookingId.value}/status/";

      final Map<String, dynamic> payload = {
        "new_status": status,
        "note": note,
      };

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 400 && status == 'on_way') {
        payload['new_status'] = 'on_the_way';
        response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $cleanToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(payload),
        );
      }

      if (response.statusCode == 400 && payload['new_status'] == 'on_the_way') {
        payload['new_status'] = 'on-the-way';
        response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $cleanToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(payload),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Status updated to ${payload['new_status']}");
        fetchJobDetails();
        return true;
      } else {
        Get.snackbar("Error", "Update failed (${response.statusCode}): ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error updating status: $e");
      Get.snackbar("Error", "Something went wrong");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void toggleCheck(int index) {
    checklist[index]['checked'] = !checklist[index]['checked'];
    checklist.refresh();
  }

  void startNavigation() async {
    final String currentStatus = bookingStatus.value;

    if (currentStatus == 'requested') {
      final confirmed = await updateStatus("confirmed");
      if (!confirmed) return;
    }

    final bool alreadyOnWay = ['on_way', 'on_the_way', 'on-the-way', 'arrived', 'working', 'completed']
        .contains(currentStatus);
    if (!alreadyOnWay) {
      final onWay = await updateStatus("on_way");
      if (!onWay) return;
    }

    startLocationSharing();
    Get.toNamed(Routes.WORKER_NAVIGATION, arguments: {'bookingId': bookingId.value});
  }

  Future<void> startLocationSharing() async {
    if (isSharingLocation.value) return;
    isSharingLocation.value = true;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token')?.replaceAll('"', '');
      if (token == null) return;

      final wsBaseUrl = ApiServices.baseurl
          .replaceFirst('https://', 'wss://')
          .replaceFirst('http://', 'ws://');
      final wsUrl = "$wsBaseUrl/ws/tracking/${bookingId.value}/?token=$token";

      _trackingChannel = IOWebSocketChannel.connect(
        Uri.parse(wsUrl),
        headers: {'X-Tunnel-Skip-Anti-Phishing-Threshold': 'true'},
      );

      _trackingChannel!.stream.listen((event) {
        try {
          final data = json.decode(event);
          if (data['type'] == 'location_update') {
            final double lat = double.tryParse(data['lat']?.toString() ?? '') ?? double.nan;
            final double lng = double.tryParse(data['lng']?.toString() ?? '') ?? double.nan;
            // ── Only update if server sends valid coords ──
            if (_isValidLatLng(lat, lng)) {
              currentLatitude.value = lat;
              currentLongitude.value = lng;
              _updateDistanceAndETA();
            }
          }
        } catch (e) {
          print("WorkerJobDetailsController: Error parsing server event: $e");
        }
      }, onError: (err) {
        print("WorkerJobDetailsController: WebSocket stream error: $err");
      }, onDone: () {
        print("WorkerJobDetailsController: WebSocket closed.");
      });

      _pingTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
        try {
          _trackingChannel?.sink.add(json.encode({"action": "ping"}));
        } catch (e) {
          print("WorkerJobDetailsController: Heartbeat error: $e");
        }
      });

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // ── Safe fallback starting coords (slightly offset from client) ───────
      final double defaultCLat = _safeCoord(
        clientLatitude.value == 0.0 ? null : clientLatitude.value,
        23.8103,
      );
      final double defaultCLng = _safeCoord(
        clientLongitude.value == 0.0 ? null : clientLongitude.value,
        90.4125,
      );
      final double defaultWLat = defaultCLat - 0.0012;
      final double defaultWLng = defaultCLng - 0.0015;
      // ─────────────────────────────────────────────────────────────────────

      // Only write if the computed defaults are actually valid
      if (_isValidLatLng(defaultWLat, defaultWLng)) {
        currentLatitude.value = defaultWLat;
        currentLongitude.value = defaultWLng;
        locationReady.value = true;
        _updateDistanceAndETA();
      }

      if (serviceEnabled &&
          (permission == LocationPermission.always ||
              permission == LocationPermission.whileInUse)) {

        Position initialPos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // ── Guard real GPS too ──
        if (_isValidLatLng(initialPos.latitude, initialPos.longitude)) {
          currentLatitude.value = initialPos.latitude;
          currentLongitude.value = initialPos.longitude;
          _pendingRouteFetchOrigin = LatLng(initialPos.latitude, initialPos.longitude);
          locationReady.value = true;
          _updateDistanceAndETA();
          _sendCoordinate(initialPos.latitude, initialPos.longitude,
              initialPos.heading, initialPos.speed);
        }

        _gpsStreamSubscription = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((Position position) {
          // ── Guard every GPS stream update ──
          if (_isValidLatLng(position.latitude, position.longitude)) {
            currentLatitude.value = position.latitude;
            currentLongitude.value = position.longitude;
            _pendingRouteFetchOrigin = LatLng(position.latitude, position.longitude);
            locationReady.value = true;
            _updateDistanceAndETA();
            _sendCoordinate(position.latitude, position.longitude,
                position.heading, position.speed);
          }
        }, onError: (err) {
          print("WorkerJobDetailsController: Geolocator stream error: $err");
        });
      }
    } catch (e) {
      print("WorkerJobDetailsController: Location sharing error: $e");
      isSharingLocation.value = false;
    }
  }

  void _sendCoordinate(double lat, double lng, double heading, double speed) {
    if (_trackingChannel == null) return;
    if (!_isValidLatLng(lat, lng)) return; // never send NaN over WebSocket
    final payload = {
      "action": "update_location",
      "lat": lat,
      "lng": lng,
      "heading": heading.round(),
      "speed": speed,
    };
    try {
      _trackingChannel!.sink.add(json.encode(payload));
    } catch (e) {
      print("WorkerJobDetailsController: Error sending coordinates: $e");
    }
  }

  void _updateDistanceAndETA() {
    try {
      final double safeCLat = _safeCoord(
        clientLatitude.value == 0.0 ? null : clientLatitude.value,
        23.8103,
      );
      final double safeCLng = _safeCoord(
        clientLongitude.value == 0.0 ? null : clientLongitude.value,
        90.4125,
      );
      final double safeWLat = _safeCoord(
        currentLatitude.value == 0.0 ? null : currentLatitude.value,
        safeCLat - 0.0012,
      );
      final double safeWLng = _safeCoord(
        currentLongitude.value == 0.0 ? null : currentLongitude.value,
        safeCLng - 0.0015,
      );

      // Final NaN guard before math
      if (!_isValidLatLng(safeCLat, safeCLng) || !_isValidLatLng(safeWLat, safeWLng)) {
        print("WorkerJobDetailsController: Skipping distance calc — coordinates not valid yet");
        return;
      }

      double distanceInMeters = Geolocator.distanceBetween(
        safeCLat, safeCLng,
        safeWLat, safeWLng,
      );

      // Guard the result too — distanceBetween can return NaN if inputs slip through
      if (distanceInMeters.isNaN || distanceInMeters.isInfinite) return;

      final double distanceKm = distanceInMeters / 1000.0;
      distance.value = "${distanceKm.toStringAsFixed(2)} km";

      double durationInMinutes = (distanceInMeters / 5.5) / 60.0;
      int etaMinutes = durationInMinutes.round();
      if (etaMinutes < 1) etaMinutes = 1;
      arrivalTime.value = "$etaMinutes mins";

      _fetchRoute(safeWLat, safeWLng, safeCLat, safeCLng);
    } catch (e) {
      print("WorkerJobDetailsController: Error calculating distance/ETA: $e");
    }
  }

  Future<void> _fetchRoute(
      double startLat, double startLng, double endLat, double endLng) async {
    if (_isFetchingRoute) return;

    // Don't even attempt a route fetch with bad coordinates
    if (!_isValidLatLng(startLat, startLng) || !_isValidLatLng(endLat, endLng)) return;

    if (_lastRouteCoords != null &&
        Geolocator.distanceBetween(
          _lastRouteCoords!.latitude, _lastRouteCoords!.longitude,
          startLat, startLng,
        ) < 10 &&
        routePoints.isNotEmpty) {
      return;
    }

    _isFetchingRoute = true;
    _lastRouteCoords = LatLng(startLat, startLng);
    final LatLng thisFetchOrigin = LatLng(startLat, startLng);

    try {
      final routeData = await ApiServices.fetchRouteData(startLat, startLng, endLat, endLng);

      // Stale response check — discard if worker moved more than 5m since fetch started
      if (_pendingRouteFetchOrigin != null) {
        final double drift = Geolocator.distanceBetween(
          thisFetchOrigin.latitude, thisFetchOrigin.longitude,
          _pendingRouteFetchOrigin!.latitude, _pendingRouteFetchOrigin!.longitude,
        );
        if (drift > 5) {
          print("WorkerJobDetailsController: Discarding stale OSRM response (${drift.toStringAsFixed(1)}m drift)");
          return;
        }
      }

      if (routeData != null && routeData.points.isNotEmpty) {
        // Guard route points — filter out any NaN points before giving to map
        final validPoints = routeData.points.where((p) =>
            _isValidLatLng(p.latitude, p.longitude)
        ).toList();

        if (validPoints.isNotEmpty) {
          routePoints.assignAll(validPoints);
          final double distKm = routeData.distanceMeters / 1000.0;
          distance.value = "${distKm.toStringAsFixed(2)} km";
          int etaMin = (routeData.durationSeconds / 60.0).round();
          arrivalTime.value = "${etaMin < 1 ? 1 : etaMin} mins";
        }
      }
    } catch (e) {
      print("WorkerJobDetailsController: Error fetching route: $e");
    } finally {
      _isFetchingRoute = false;
    }
  }

  void stopLocationSharing() {
    _pingTimer?.cancel();
    _simulationTimer?.cancel();
    _gpsStreamSubscription?.cancel();
    _trackingChannel?.sink.close();
    isSharingLocation.value = false;
  }

  void viewAttachment() {
    if (attachmentImage.value.isNotEmpty) {
      Get.to(() => WorkerImageView(imagePath: attachmentImage.value));
    } else {
      Get.snackbar("Error", "No attachment found");
    }
  }

  Future<void> downloadAttachment() async {
    if (attachmentImage.value.isEmpty) {
      Get.snackbar("Error", "No attachment to download");
      return;
    }
    try {
      Get.snackbar("Download", "Download started...",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary.withOpacity(0.1));

      final response = await http.get(Uri.parse(attachmentImage.value));
      if (response.statusCode == 200) {
        await Future.delayed(const Duration(seconds: 1));
        Get.snackbar("Success", "File saved to downloads",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1));
      } else {
        Get.snackbar("Error", "Failed to reach file server");
      }
    } catch (e) {
      print("Download error: $e");
      Get.snackbar("Error", "Could not complete download");
    }
  }

  void callClient() {}

  void chatClient() {
    final chatId = displayBookingId.value.isNotEmpty ? displayBookingId.value : bookingId.value;
    Get.toNamed('/worker-chat', arguments: {
      'id': chatId,
      'name': clientName.value,
      'profile': clientImage.value,
      'isClient': false,
    });
  }

  void iveArrived() async {
    final success = await updateStatus("working");
    if (success) {
      Get.offNamed(Routes.WORKER_TRACKING, arguments: {'bookingId': bookingId.value});
    }
  }

  void reportIssue() =>
      Get.toNamed(Routes.REPORT_ISSUE, arguments: {'bookingId': bookingId.value});

  Future<void> completeJob() async {
    await updateStatus("completed");
    Get.dialog(
      const SuccessDialog(message: "Job completed successfully!"),
      barrierDismissible: false,
    );
    await Future.delayed(const Duration(milliseconds: 2000));
    Get.offAllNamed(Routes.worker_deshbord_user);
  }

  void showCancellationDialog() {}

  void confirmCancellation() {
    updateStatus("cancelled");
    Get.back();
    Get.back();
  }
}

class ChatMessageModel {
  final String id;
  final String content;
  final DateTime timestamp;
  final Sender sender;
  final bool isRead;

  ChatMessageModel({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.sender,
    this.isRead = false,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ChatMessageModel(
        id: "", content: "", timestamp: DateTime.now(),
        sender: Sender(id: "", fullName: "", profilePicture: ""),
      );
    }
    return ChatMessageModel(
      id: json['id']?.toString() ?? "",
      content: json['content']?.toString() ?? "",
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      sender: json['sender'] != null
          ? Sender.fromJson(json['sender'] as Map<String, dynamic>?)
          : Sender(
        id: json['sender_id']?.toString() ?? "",
        fullName: json['sender_name']?.toString() ?? "",
        profilePicture: ApiServices.formatImageUrl(json['sender_picture']?.toString()),
      ),
      isRead: json['is_read'] == true || json['is_read'] == 'true',
    );
  }
}

class Sender {
  final String id;
  final String fullName;
  final String profilePicture;

  Sender({required this.id, required this.fullName, required this.profilePicture});

  factory Sender.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Sender(id: "", fullName: "", profilePicture: "");
    return Sender(
      id: json['id']?.toString() ?? "",
      fullName: json['full_name']?.toString() ?? "",
      profilePicture: ApiServices.formatImageUrl(json['profile_picture']?.toString()),
    );
  }
}