import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/components/request_card.dart';
import '../../../../core/global_controllers/location_controller.dart';
import '../controllers/incoming_requests_controller.dart';

class IncomingRequestsView extends GetView<IncomingRequestsController> {
  const IncomingRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(IncomingRequestsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Incoming Requests",
              style: GoogleFonts.poppins(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            Text(
              "${controller.requests.length} active requests",
              style: GoogleFonts.poppins(
                fontSize: 13.0,
                color: AppColors.greyText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Center(
              child: Obx(() => Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.urgentRed,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "${controller.requests.length}",
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.requests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text(
                  "No incoming requests at the moment",
                  style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 16),
                ),
                const SizedBox(height: 10),
                TextButton(
                   onPressed: controller.fetchRequests,
                   child: const Text("Refresh"),
                )
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchRequests,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => controller.isVerified.value 
                    ? const SizedBox.shrink() 
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: _buildVerificationWarning(),
                      )
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.requests.length,
                    itemBuilder: (context, index) {
                      final req = controller.requests[index];
                      final String bookingId = req['id']?.toString() ?? '';
                      
                      // Extremely robust client parsing from flat or nested server response
                      String clientName = "Client";
                      String? clientPicture;
                      String clientRating = "4.8";

                      if (req['client'] != null) {
                        if (req['client'] is Map) {
                          final clientData = req['client'];
                          clientName = clientData['full_name']?.toString() ?? clientData['name']?.toString() ?? 'Client';
                          clientPicture = ApiServices.formatImageUrl(clientData['profile_picture']?.toString());
                          clientRating = clientData['avg_rating']?.toString() ?? 
                                         clientData['rating']?.toString() ?? 
                                         clientData['avg_rating_client']?.toString() ?? 
                                         '4.8';
                        } else {
                          clientName = req['client'].toString();
                        }
                      } else {
                        clientName = req['client_name']?.toString() ?? 'Client';
                        clientPicture = ApiServices.formatImageUrl(req['client_picture']?.toString());
                      }

                      // If client rating is still fallback 4.8, check flat keys
                      if (clientRating == "4.8") {
                        final String parsedRating = req['client_rating']?.toString() ?? 
                                                    req['client_avg_rating']?.toString() ?? 
                                                    req['avg_rating']?.toString() ?? 
                                                    req['rating']?.toString() ?? 
                                                    "";
                        if (parsedRating.isNotEmpty && parsedRating.toLowerCase() != "null") {
                          clientRating = parsedRating;
                        }
                      }

                      final String serviceTitle = req['service_name'] ?? 'Service';
                      final String address = req['full_address'] ?? 'Address not set';
                      
                      final String tag = req['urgency']?.toString().toUpperCase() ?? 
                                         ((req['is_urgent'] == true) ? 'URGENT' : 'NORMAL');
                      
                      final String timeAgo = getTimeAgo(req['requested_at']?.toString());
                      final String distance = getDistanceString(req);

                      return RequestCard(
                        clientName: clientName,
                        clientPictureUrl: clientPicture,
                        clientRating: clientRating,
                        serviceTitle: serviceTitle,
                        address: address,
                        distance: distance,
                        timeAgo: timeAgo,
                        tag: tag,
                        onAccept: () => controller.acceptRequest(req),
                        onDecline: () => controller.declineRequest(req),
                        onCall: () {},
                        onChat: () => Get.toNamed(Routes.CHAT, arguments: {'bookingId': bookingId}),
                      );
                    },
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  String getTimeAgo(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return 'Just now';
    try {
      final DateTime? parsed = DateTime.tryParse(timeStr);
      if (parsed == null) return 'Just now';
      final DateTime localParsed = parsed.toLocal();
      final Duration diff = DateTime.now().difference(localParsed);
      if (diff.inSeconds < 60) {
        return '${diff.inSeconds}s ago';
      } else if (diff.inMinutes < 60) {
        return '${diff.inMinutes}m ago';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}h ago';
      } else {
        return '${diff.inDays}d ago';
      }
    } catch (e) {
      return 'Just now';
    }
  }

  String getDistanceString(Map<String, dynamic> req) {
    try {
      if (Get.isRegistered<LocationController>()) {
        final locCtrl = Get.find<LocationController>();
        final Position? currentPos = locCtrl.currentPosition.value;
        
        double? destLat;
        double? destLng;

        // Extremely robust coordinate key checks
        final rawLat = req['address_lat'] ?? req['lat'] ?? req['latitude'] ?? req['client_lat'] ?? req['client_latitude'];
        final rawLng = req['address_lng'] ?? req['lng'] ?? req['longitude'] ?? req['client_lng'] ?? req['client_longitude'];

        if (rawLat != null) destLat = double.tryParse(rawLat.toString());
        if (rawLng != null) destLng = double.tryParse(rawLng.toString());

        if (destLat == null || destLng == null) return "1.2 km";

        if (currentPos != null) {
          final double distanceInMeters = Geolocator.distanceBetween(
            currentPos.latitude,
            currentPos.longitude,
            destLat,
            destLng,
          );
          final double distanceInKm = distanceInMeters / 1000.0;
          return "${distanceInKm.toStringAsFixed(1)} km";
        } else {
          // If the worker's position is null/loading, trigger background location fetch
          locCtrl.getUserLocation();
        }
      }
      return "1.2 km";
    } catch (e) {
      print("Error calculating distance: $e");
      return "1.2 km";
    }
  }

  Widget _buildVerificationWarning() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FA),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.primary.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_rounded, color: AppColors.urgentRed, size: 36),
          const SizedBox(height: 16.0),
          Text(
            "Your account isn't verified yet. To send work requests and get hired, please complete your verification.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              color: AppColors.textColor.withOpacity(0.9),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.WORKER_VERIFICATION),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
              ),
              child: Text(
                "Verify now",
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
