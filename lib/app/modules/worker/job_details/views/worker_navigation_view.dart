import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/constants/static/app_images.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/worker_job_details_controller.dart';
import 'cancel_order_dialog.dart';

class WorkerNavigationView extends GetView<WorkerJobDetailsController> {
  const WorkerNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final cLat = controller.clientLatitude.value;
        final cLng = controller.clientLongitude.value;
        final wLat = controller.currentLatitude.value;
        final wLng = controller.currentLongitude.value;

        // Fallback coordinates to avoid showing the loading spinner forever
        final double finalCLat = cLat == 0.0 ? 23.8103 : cLat;
        final double finalCLng = cLng == 0.0 ? 90.4125 : cLng;
        final double finalWLat = wLat == 0.0 ? 23.7561 : wLat;
        final double finalWLng = wLng == 0.0 ? 90.3871 : wLng;

        return Stack(
          children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(
                        (finalCLat + finalWLat) / 2,
                        (finalCLng + finalWLng) / 2),
                    initialZoom: 14.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=GPXbdZO7XpRukMLD8Bz1",
                      userAgentPackageName: 'com.artisan.app',
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: controller.routePoints.isNotEmpty
                              ? controller.routePoints
                              : [
                                  LatLng(finalWLat, finalWLng),
                                  LatLng(finalCLat, finalCLng),
                                ],
                          color: AppColors.primary,
                          strokeWidth: 4.0,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(finalCLat, finalCLng),
                          width: 48,
                          height: 48,
                          child: PulsingNavMarker(
                            color: const Color(0xFF2196F3),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2196F3),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: Colors.black12, blurRadius: 6),
                                ],
                              ),
                              child: const Icon(Icons.home_rounded, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                        Marker(
                          point: LatLng(finalWLat, finalWLng),
                          width: 48,
                          height: 48,
                          child: PulsingNavMarker(
                            color: AppColors.primary,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: Colors.black26, blurRadius: 8),
                                ],
                              ),
                              child: const Icon(Icons.navigation_rounded, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            
            // Custom Header (Floating over Map)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildHeader(),
            ),

            // Bottom Sheet Card
            _buildBottomSheet(),
          ],
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: Get.mediaQuery.padding.top, bottom: 16.0),
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Text(
                AppStrings.artisanIsOnTheWay.tr,
                style: GoogleFonts.poppins(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Obx(() => Text(
                    "Arriving in ${controller.arrivalTime.value}",
                    style: GoogleFonts.poppins(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                ],
              ),
            ],
          ),
          Positioned(
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () {
                controller.stopLocationSharing();
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24.0),
              
              // Client Row
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: controller.clientImage.value.startsWith('http')
                        ? NetworkImage(controller.clientImage.value)
                        : AssetImage(controller.clientImage.value.isEmpty ? AppImages.placeholderAvatar : controller.clientImage.value) as ImageProvider,
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.clientName.value,
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          controller.clientAddress.value,
                          style: GoogleFonts.poppins(
                            fontSize: 13.0,
                            color: AppColors.greyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F4F8),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary, size: 22.0),
                      onPressed: controller.chatClient,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              
              // Service Summary Box
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow("Service", controller.serviceName.value),
                    const SizedBox(height: 8.0),
                    Obx(() => _buildSummaryRow("Time", 
                      controller.bookingStatus.value.toLowerCase() == 'completed' && controller.completedTime.value.isNotEmpty
                          ? controller.completedTime.value
                          : controller.scheduledTime.value
                    )),
                    const SizedBox(height: 8.0),
                    _buildSummaryRow("Payment", "\$${controller.paymentAmount.value.toStringAsFixed(2)}", valueColor: const Color(0xFF4CAF50)),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              
              // Bottom Buttons
              ElevatedButton(
                onPressed: controller.iveArrived,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 56.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  elevation: 0,
                ),
                child: Text(
                  AppStrings.iveArrived.tr,
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              OutlinedButton(
                onPressed: () => Get.dialog(const CancelOrderDialog()),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56.0),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                child: Text(
                  AppStrings.cancel.tr,
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 13.0, color: AppColors.greyText, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.textColor,
          ),
        ),
      ],
    );
  }
}

class PulsingNavMarker extends StatefulWidget {
  final Widget child;
  final Color color;

  const PulsingNavMarker({
    super.key,
    required this.child,
    this.color = AppColors.primary,
  });

  @override
  State<PulsingNavMarker> createState() => _PulsingNavMarkerState();
}

class _PulsingNavMarkerState extends State<PulsingNavMarker> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 56 * _controller.value,
              height: 56 * _controller.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withOpacity(0.4 * (1.0 - _controller.value)),
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}



