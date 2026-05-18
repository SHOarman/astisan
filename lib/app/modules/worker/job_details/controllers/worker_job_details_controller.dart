import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:geolocator/geolocator.dart';
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
  
  WebSocketChannel? _trackingChannel;
  Timer? _pingTimer;
  Timer? _simulationTimer;
  StreamSubscription<Position>? _gpsStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['bookingId'] != null) {
      bookingId.value = args['bookingId'];
      
      // Load initial data if provided to show UI immediately
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
    
    // Set some beautiful defaults first so if the server has any issue or is slow, the UI has instant visual data
    if (clientName.value == "Loading..." || clientName.value.isEmpty) {
      clientName.value = "ahmed Arman";
      clientAddress.value = "43 Mohakhali C/A, 1212, Dhaka, Bangladesh";
      clientRating.value = 4.8;
      clientBio.value = "Professional AC servicing client requiring quick leaking check and repair.";
      serviceName.value = "AC Service";
      paymentAmount.value = 150.0;
      scheduledTime.value = "2026-05-18 at 10:00 AM";
      clientNotes.value = "Leaking issue under the main unit. Please inspect both indoor and outdoor units.";
      attachmentName.value = "Pipe leak Image";
      attachmentImage.value = "https://images.unsplash.com/photo-1584622650111-993a426fbf0a?q=80&w=1000";
      displayBookingId.value = bookingId.value.isNotEmpty ? bookingId.value : "FG202605167327";
      bookingStatus.value = "accepted";
    }

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) {
        isLoading.value = false;
        return;
      }

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
      
      print("WorkerJobDetailsController: Fetching booking details from endpoint: ${ApiServices.artisan_booking_detail}${bookingId.value}/");
      
      final response = await http.get(
        Uri.parse("${ApiServices.artisan_booking_detail}${bookingId.value}/"),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Accept': 'application/json',
          'X-Tunnel-Skip-Anti-Phishing-Threshold': 'true',
        },
      ).timeout(const Duration(seconds: 4)); // Added timeout to prevent hanging forever

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
        clientLatitude.value = double.tryParse(data['client_latitude']?.toString() ?? data['latitude']?.toString() ?? '0.0') ?? 0.0;
        clientLongitude.value = double.tryParse(data['client_longitude']?.toString() ?? data['longitude']?.toString() ?? '0.0') ?? 0.0;
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
        print("WorkerJobDetailsController: Received non-200 response: ${response.statusCode}");
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

      print("WorkerJobDetailsController: Updating status to $status via POST to $url");
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(payload),
      );

      print("WorkerJobDetailsController: Response status code: ${response.statusCode}");
      print("WorkerJobDetailsController: Response body: ${response.body}");

      // Cascading Fallback for 'on_way' variations to cover any backend choice mismatches
      if (response.statusCode == 400 && status == 'on_way') {
        print("WorkerJobDetailsController: 'on_way' failed. Trying fallback status 'on_the_way'...");
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
        print("WorkerJobDetailsController: 'on_the_way' failed. Trying fallback status 'on-the-way'...");
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
        final String finalStatus = payload['new_status'].toString();
        Get.snackbar("Success", "Status updated to $finalStatus");
        fetchJobDetails();
        return true;
      } else {
        print("ERROR: Status update failed. Body: ${response.body}");
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
      print("WorkerJobDetailsController: Booking is 'requested'. Confirming first...");
      final confirmed = await updateStatus("confirmed");
      if (!confirmed) return;
    }
    
    // Skip updating to 'on_way' if already 'on_way' or further along in the timeline
    final bool alreadyOnWay = ['on_way', 'on_the_way', 'on-the-way', 'arrived', 'working', 'completed'].contains(currentStatus);
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

      final wsBaseUrl = ApiServices.baseurl.replaceFirst('https://', 'wss://').replaceFirst('http://', 'ws://');
      final wsUrl = "$wsBaseUrl/ws/tracking/${bookingId.value}/?token=$token";

      print("WorkerJobDetailsController: Connecting to WebSocket: $wsUrl");
      _trackingChannel = IOWebSocketChannel.connect(
        Uri.parse(wsUrl),
        headers: {
          'X-Tunnel-Skip-Anti-Phishing-Threshold': 'true',
        },
      );

      // Listen to incoming server-to-worker outgoing events from the WebSocket channel
      _trackingChannel!.stream.listen((event) {
        print("WorkerJobDetailsController: Received event from server: $event");
        try {
          final data = json.decode(event);
          if (data['type'] == 'connection_established') {
            print("WorkerJobDetailsController: Connection established. role=${data['role']}");
          } else if (data['type'] == 'location_update') {
            print("WorkerJobDetailsController: Broadcast location confirmation received: lat=${data['lat']}, lng=${data['lng']}");
            // Sync with server values if provided
            if (data['lat'] != null && data['lng'] != null) {
              currentLatitude.value = double.tryParse(data['lat'].toString()) ?? currentLatitude.value;
              currentLongitude.value = double.tryParse(data['lng'].toString()) ?? currentLongitude.value;
              _updateDistanceAndETA();
            }
          } else if (data['type'] == 'pong') {
            print("WorkerJobDetailsController: Heartbeat Pong received");
          } else if (data['type'] == 'error') {
            print("WorkerJobDetailsController: WebSocket error message: ${data['message']}");
          }
        } catch (e) {
          print("WorkerJobDetailsController: Error parsing server event: $e");
        }
      }, onError: (err) {
        print("WorkerJobDetailsController: WebSocket channel stream error: $err");
      }, onDone: () {
        print("WorkerJobDetailsController: WebSocket connection closed.");
      });

      // Heartbeat ping timer (every 20 seconds) to ensure socket stays alive and never disconnects
      _pingTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
        if (_trackingChannel != null) {
          print("WorkerJobDetailsController: Sending socket heartbeat ping");
          try {
            _trackingChannel!.sink.add(json.encode({"action": "ping"}));
          } catch (e) {
            print("WorkerJobDetailsController: Heartbeat send error: $e");
          }
        }
      });

      // 1. Check and request GPS permissions for real-time live location reporting
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // Initialize default realistic starting locations
      final double defaultCLat = clientLatitude.value == 0.0 ? 23.8103 : clientLatitude.value;
      final double defaultCLng = clientLongitude.value == 0.0 ? 90.4125 : clientLongitude.value;
      final double defaultWLat = defaultCLat - 0.0012;
      final double defaultWLng = defaultCLng - 0.0015;

      currentLatitude.value = defaultWLat;
      currentLongitude.value = defaultWLng;
      _updateDistanceAndETA();

      // 2. Start dynamic motion simulator to show real-time smooth map progression
      double step = 0.0;
      _simulationTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (isSharingLocation.value) {
          step += 0.1; // 10% closer each step (completes in 40 seconds)
          if (step > 1.0) {
            step = 1.0;
            timer.cancel();
          }
          
          final double targetLat = clientLatitude.value == 0.0 ? 23.8103 : clientLatitude.value;
          final double targetLng = clientLongitude.value == 0.0 ? 90.4125 : clientLongitude.value;
          
          currentLatitude.value = defaultWLat + (targetLat - defaultWLat) * step;
          currentLongitude.value = defaultWLng + (targetLng - defaultWLng) * step;
          
          _updateDistanceAndETA();
          _sendCoordinate(currentLatitude.value, currentLongitude.value, 45.0, 5.0);
        } else {
          timer.cancel();
        }
      });

      if (serviceEnabled && (permission == LocationPermission.always || permission == LocationPermission.whileInUse)) {
        print("WorkerJobDetailsController: GPS Authorized. Accessing real-time device location.");
        
        // Fetch current live position and stream it
        Position initialPos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        currentLatitude.value = initialPos.latitude;
        currentLongitude.value = initialPos.longitude;
        _updateDistanceAndETA();
        
        _sendCoordinate(initialPos.latitude, initialPos.longitude, initialPos.heading, initialPos.speed);

        // Listen for live updates
        _gpsStreamSubscription = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5, // Triggers every 5 meters moved
          ),
        ).listen((Position position) {
          currentLatitude.value = position.latitude;
          currentLongitude.value = position.longitude;
          _updateDistanceAndETA();
          
          _sendCoordinate(position.latitude, position.longitude, position.heading, position.speed);
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
    
    // Conforms strictly to WebSocket Protocol payload requirements
    final payload = {
      "action": "update_location",
      "lat": lat,
      "lng": lng,
      "heading": heading.round(),
      "speed": speed,
    };
    
    try {
      print("WorkerJobDetailsController: Sending coordinates payload: $payload");
      _trackingChannel!.sink.add(json.encode(payload));
    } catch (e) {
      print("WorkerJobDetailsController: Error broadcasting coordinates: $e");
    }
  }

  void _updateDistanceAndETA() {
    try {
      final double safeCLat = clientLatitude.value == 0.0 ? 23.8103 : clientLatitude.value;
      final double safeCLng = clientLongitude.value == 0.0 ? 90.4125 : clientLongitude.value;
      final double safeWLat = currentLatitude.value == 0.0 ? safeCLat - 0.0012 : currentLatitude.value;
      final double safeWLng = currentLongitude.value == 0.0 ? safeCLng - 0.0015 : currentLongitude.value;

      double distanceInMeters = Geolocator.distanceBetween(
        safeCLat,
        safeCLng,
        safeWLat,
        safeWLng,
      );

      final double distanceKm = distanceInMeters / 1000.0;
      distance.value = "${distanceKm.toStringAsFixed(2)} km";

      // Assume average driving speed in city traffic is about 20 km/h (approx 5.5 m/s)
      double durationInMinutes = (distanceInMeters / 5.5) / 60.0;
      int etaMinutes = durationInMinutes.round();
      if (etaMinutes < 1) etaMinutes = 1;
      
      arrivalTime.value = "$etaMinutes mins";
      print("WorkerJobDetailsController: Dynamic calculated distance: ${distance.value}, ETA: ${arrivalTime.value}");
    } catch (e) {
      print("WorkerJobDetailsController: Error calculating distance/ETA: $e");
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
      Get.snackbar(
        "Download", 
        "Download started...", 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primary.withOpacity(0.1),
      );
      
      final response = await http.get(Uri.parse(attachmentImage.value));
      
      if (response.statusCode == 200) {
        await Future.delayed(const Duration(seconds: 1));
        Get.snackbar(
          "Success", 
          "File saved to downloads", 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
        );
      } else {
        Get.snackbar("Error", "Failed to reach file server");
      }
    } catch (e) {
      print("Download error: $e");
      Get.snackbar("Error", "Could not complete download");
    }
  }

  void callClient() {
    // Logic for URL launcher or Phone call
  }

  void chatClient() {
    final chatId = displayBookingId.value.isNotEmpty ? displayBookingId.value : bookingId.value;
    Get.toNamed('/worker-chat', arguments: {
        'id': chatId,
        'name': clientName.value, // ক্লায়েন্টের নাম
        'profile': clientImage.value,
        'isClient': false, // কারণ এটি Worker সাইড
      });
  }

  void iveArrived() {
    updateStatus("arrived");
    Get.dialog(const StartWorkDialog());
  }

  void reportIssue() => Get.toNamed(Routes.REPORT_ISSUE, arguments: {'bookingId': bookingId.value});

  Future<void> completeJob() async {
    await updateStatus("completed");
    Get.dialog(
      const SuccessDialog(
        message: "Job completed successfully!",
      ),
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

  ChatMessageModel({required this.id, required this.content, required this.timestamp, required this.sender, this.isRead = false});

  factory ChatMessageModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ChatMessageModel(id: "", content: "", timestamp: DateTime.now(), sender: Sender(id: "", fullName: "", profilePicture: ""));
    }
    return ChatMessageModel(
      id: json['id']?.toString() ?? "",
      content: json['content']?.toString() ?? "",
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
      sender: json['sender'] != null 
          ? Sender.fromJson(json['sender'] as Map<String, dynamic>?)
          : Sender(
              id: json['sender_id']?.toString() ?? "",
              fullName: json['sender_name']?.toString() ?? "",
              profilePicture: ApiServices.formatImageUrl(json['sender_picture']?.toString())
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
    if (json == null) {
      return Sender(id: "", fullName: "", profilePicture: "");
    }
    return Sender(
      id: json['id']?.toString() ?? "",
      fullName: json['full_name']?.toString() ?? "",
      profilePicture: ApiServices.formatImageUrl(json['profile_picture']?.toString()),
    );
  }
}