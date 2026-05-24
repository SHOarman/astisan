
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/Services/api_services.dart';
import '../../../../core/components/request_card.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/global_controllers/location_controller.dart';
import '../../../../core/routes/app_routes.dart';
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
        title: Obx(
              () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.incomingrequest.tr,
                style: GoogleFonts.poppins(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                "${controller.requests.length} ${AppStrings.active.tr}",
                style: GoogleFonts.poppins(
                  fontSize: 13.0,
                  color: AppColors.greyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Center(
              child: Obx(
                    () => Container(
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
                ),
              ),
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
                Icon(
                  Icons.inbox_outlined,
                  size: 80,
                  color: Colors.grey.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.noIncomingRequests.tr,
                  style: GoogleFonts.poppins(
                    color: AppColors.greyText,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: controller.fetchRequests,
                  child: Text(AppStrings.refresh.tr),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchRequests,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                        () => controller.isVerified.value
                        ? const SizedBox.shrink()
                        : Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: _buildVerificationWarning(),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.requests.length,
                    itemBuilder: (context, index) {
                      final req = controller.requests[index];
                      final String bookingId = req['id']?.toString() ?? '';

                      String clientName = AppStrings.clientDefault.tr;
                      String? clientPicture;
                      String clientRating = "4.8";

                      if (req['client'] != null) {
                        if (req['client'] is Map) {
                          final clientData = req['client'];
                          clientName =
                              clientData['full_name']?.toString() ??
                                  clientData['name']?.toString() ??
                                  AppStrings.clientDefault.tr;
                          clientPicture = ApiServices.formatImageUrl(
                            clientData['profile_picture']?.toString(),
                          );
                          clientRating =
                              clientData['avg_rating']?.toString() ??
                                  clientData['rating']?.toString() ??
                                  clientData['avg_rating_client']?.toString() ??
                                  '4.8';
                        } else {
                          clientName = req['client'].toString();
                        }
                      } else {
                        clientName = req['client_name']?.toString() ?? AppStrings.clientDefault.tr;
                        clientPicture = ApiServices.formatImageUrl(
                          req['client_picture']?.toString(),
                        );
                      }

                      if (clientRating == "4.8") {
                        final String parsedRating =
                            req['client_rating']?.toString() ??
                                req['client_avg_rating']?.toString() ??
                                req['avg_rating']?.toString() ??
                                req['rating']?.toString() ??
                                "";
                        if (parsedRating.isNotEmpty &&
                            parsedRating.toLowerCase() != "null") {
                          clientRating = parsedRating;
                        }
                      }

                      final String serviceTitle =
                          req['service_name'] ?? AppStrings.serviceDefault.tr;
                      final String address =
                          req['full_address'] ?? AppStrings.addressNotSet.tr;

                      final String tag =
                          req['urgency']?.toString().toUpperCase() ??
                              ((req['is_urgent'] == true) ? AppStrings.tagUrgent.tr : AppStrings.tagNormal.tr);

                      final String timeAgo = getTimeAgo(
                        req['requested_at']?.toString(),
                      );
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
                        onChat: () => Get.toNamed(
                          Routes.CHAT,
                          arguments: {'bookingId': bookingId},
                        ),
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
    if (timeStr == null || timeStr.isEmpty) return AppStrings.justNow.tr;
    try {
      final DateTime? parsed = DateTime.tryParse(timeStr);
      if (parsed == null) return AppStrings.justNow.tr;
      final DateTime localParsed = parsed.toLocal();
      final Duration diff = DateTime.now().difference(localParsed);
      if (diff.inSeconds < 60) {
        return '${diff.inSeconds}${AppStrings.secondsAgoSuffix.tr}';
      } else if (diff.inMinutes < 60) {
        return '${diff.inMinutes}${AppStrings.minutesAgoSuffix.tr}';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}${AppStrings.hoursAgoSuffix.tr}';
      } else {
        return '${diff.inDays}${AppStrings.daysAgoSuffix.tr}';
      }
    } catch (e) {
      return AppStrings.justNow.tr;
    }
  }

  String getDistanceString(Map<String, dynamic> req) {
    try {
      final locCtrl = Get.isRegistered<LocationController>()
          ? Get.find<LocationController>()
          : Get.put(LocationController());
      final Position? currentPos = locCtrl.currentPosition.value;

      double? destLat;
      double? destLng;

      final rawLat =
          req['address_lat'] ??
              req['lat'] ??
              req['latitude'] ??
              req['client_lat'] ??
              req['client_latitude'];
      final rawLng =
          req['address_lng'] ??
              req['lng'] ??
              req['longitude'] ??
              req['client_lng'] ??
              req['client_longitude'];

      print("DEBUG GET_DISTANCE: rawLat=$rawLat, rawLng=$rawLng");

      if (rawLat != null &&
          rawLat.toString().isNotEmpty &&
          rawLat.toString() != 'null')
        destLat = double.tryParse(rawLat.toString());
      if (rawLng != null &&
          rawLng.toString().isNotEmpty &&
          rawLng.toString() != 'null')
        destLng = double.tryParse(rawLng.toString());

      print(
        "DEBUG GET_DISTANCE: destLat=$destLat, destLng=$destLng, currentPos=$currentPos",
      );

      if (destLat == null ||
          destLng == null ||
          destLat == 0.0 ||
          destLng == 0.0)
        return AppStrings.noDistance.tr;

      if (currentPos != null) {
        final double distanceInMeters = Geolocator.distanceBetween(
          currentPos.latitude,
          currentPos.longitude,
          destLat,
          destLng,
        );
        final double distanceInKm = distanceInMeters / 1000.0;
        return "${distanceInKm.toStringAsFixed(1)} ${AppStrings.kmUnit.tr}";
      } else {
        locCtrl.getUserLocation();
        return AppStrings.calculating.tr;
      }
    } catch (e) {
      print("Error calculating distance: $e");
      return AppStrings.noDistance.tr;
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
            AppStrings.verificationWarningText.tr,
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
              child: Text(
                AppStrings.verifyNow.tr,
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
