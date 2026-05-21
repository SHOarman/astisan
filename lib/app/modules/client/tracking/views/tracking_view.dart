
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/components/status_timeline_tile.dart';
import '../../../../core/components/artisan_bottom_sheet_card.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/routes/app_routes.dart';
import '../controllers/tracking_controller.dart';

class TrackingView extends GetView<TrackingController> {
  const TrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<TrackingController>()) {
      Get.put(TrackingController());
    }

    return Obx(() {
      final String lowerStatus = controller.status.value.toLowerCase();
      final bool isTrackingValid = ['on_way', 'on_the_way', 'on-the-way', 'arrived', 'working'].contains(lowerStatus);
      
      if (!isTrackingValid) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.currentRoute == Routes.TRACKING || Get.currentRoute == Routes.TRACKINGSCREEN) {
            Get.back();
            Get.snackbar(
              "Status Update",
              "Tracking is no longer available.",
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        });
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (['arrived', 'working'].contains(lowerStatus)) {
        return _buildTimelineState(context);
      } else {
        return _buildMapState(context);
      }
    });
  }

  Widget _buildTimelineState(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.tracking.tr,
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: AppColors.timelineActive.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: AppColors.timelineActive.withOpacity(0.2)),
            ),
            child: Center(
              child: Row(
                children: [
                  Container(
                    width: 6.0,
                    height: 6.0,
                    decoration: const BoxDecoration(
                      color: AppColors.timelineActive,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    AppStrings.live.tr,
                    style: GoogleFonts.poppins(
                      color: AppColors.timelineActive,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildArtisanHeader(),
                  const SizedBox(height: 16.0),
                  _buildProgressCircle(),
                  const SizedBox(height: 16.0),
                  _buildTimeline(),
                  const SizedBox(height: 16.0),
                  _buildServiceDetails(),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.viewCompletionWork,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppStrings.viewCompletionWork.tr,
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtisanHeader() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.asset(
            AppImages.placeholderAvatar,
            width: 50.0,
            height: 50.0,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'James Wilson',
                style: GoogleFonts.poppins(
                  color: AppColors.textColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: AppColors.ratingStar, size: 14.0),
                  const SizedBox(width: 4.0),
                  Text(
                    '4.9 · Plumbing Expert',
                    style: GoogleFonts.poppins(
                      color: AppColors.greyText,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: controller.goToChat,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Icon(Icons.chat_bubble_outline, color: AppColors.primary, size: 24.0),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCircle() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 120.0,
            height: 120.0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 0.6,
                  strokeWidth: 8.0,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.timelineCurrent),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.build_circle_outlined, color: AppColors.timelineCurrent, size: 32.0),
                      const SizedBox(height: 4.0),
                      Text(
                        '34 min',
                        style: GoogleFonts.poppins(
                          color: AppColors.textColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          Text(
            AppStrings.serviceInProgress.tr,
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Started at 10:18 AM · 34 min elapsed',
            style: GoogleFonts.poppins(
              color: AppColors.greyText,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.statusTimeline.tr,
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24.0),
          const StatusTimelineTile(
            title: 'Booking Confirmed',
            subtitle: 'Your booking has been accepted',
            time: '09:45 AM',
            icon: Icons.check,
            state: TimelineState.completed,
          ),
          const StatusTimelineTile(
            title: 'On the Way',
            subtitle: 'Artisan is heading to your location',
            time: '10:00 AM',
            icon: Icons.check,
            state: TimelineState.completed,
          ),
          StatusTimelineTile(
            title: 'Working',
            subtitle: 'Service in progress at your location',
            time: '10:18 AM',
            icon: Icons.build,
            state: TimelineState.current,
            trailingWidget: Row(
              children: [
                Row(
                  children: List.generate(3, (index) => Container(
                    margin: const EdgeInsets.only(right: 4.0),
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      color: AppColors.timelineCurrent.withOpacity(0.4 + (index * 0.2)),
                      shape: BoxShape.circle,
                    ),
                  )),
                ),
                const SizedBox(width: 8.0),
                Text(
                  'In progress...',
                  style: GoogleFonts.poppins(
                    color: AppColors.timelineCurrent,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const StatusTimelineTile(
            title: 'Completed',
            subtitle: 'Service has been completed',
            time: 'Pending',
            icon: Icons.celebration,
            state: TimelineState.pending,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetails() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.serviceDetails.tr,
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16.0),
          _buildDetailRow('Service', 'Pipe Repair'),
          const SizedBox(height: 12.0),
          _buildDetailRow('Location', '123 Main St, NY'),
          const SizedBox(height: 12.0),
          _buildDetailRow(AppStrings.estimatedCost.tr, controller.estimatedCost.value),
          const SizedBox(height: 12.0),
          _buildDetailRow(AppStrings.jobStart.tr, '10:18 AM'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.greyText,
            fontSize: 14.0,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMapState(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ARTISAN IS ON THE WAY',
                            style: GoogleFonts.poppins(
                              color: AppColors.white.withOpacity(0.7),
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Obx(() => Row(
                            children: [
                              Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  color: controller.isLive.value ? const Color(0xFF4CAF50) : AppColors.statusCompletedText,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                "Arriving in ${controller.etaMinutes.value} mins",
                                style: GoogleFonts.poppins(
                                  color: AppColors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.white),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Obx(() {
          final double cLat = controller.clientLatitude.value;
          final double cLng = controller.clientLongitude.value;
          final double wLat = controller.workerLatitude.value;
          final double wLng = controller.workerLongitude.value;

          if (cLat == 0.0 || cLng == 0.0 || wLat == 0.0 || wLng == 0.0 || cLat.isNaN || cLng.isNaN || wLat.isNaN || wLng.isNaN) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16),
                  Text("Acquiring live location...", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }

          return Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(
                      (cLat + wLat) / 2,
                      (cLng + wLng) / 2),
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
                          LatLng(wLat, wLng),
                          LatLng(cLat, cLng),
                        ],
                        color: AppColors.primary,
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(cLat, cLng),
                        width: 48,
                        height: 48,
                        child: PulsingMarker(
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
                        point: LatLng(wLat, wLng),
                        width: 60,
                        height: 100,
                        alignment: Alignment.topCenter,
                        child: PulsingMarker(
                          color: AppColors.primary,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black12, blurRadius: 4),
                                  ],
                                ),
                                child: Text(
                                  "${controller.etaMinutes.value} min",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                width: 2.0,
                                height: 4.0,
                                color: AppColors.primary,
                              ),
                              Container(
                                width: 44.0,
                                height: 44.0,
                                padding: const EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: controller.artisanImageUrl.value.isNotEmpty
                                      ? Image.network(
                                    controller.artisanImageUrl.value,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Image.asset(
                                      AppImages.placeholderAvatar,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : Image.asset(
                                    AppImages.placeholderAvatar,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ArtisanBottomSheetCard(
                  headerWidget: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      color: AppColors.statusCompletedText.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.near_me_outlined, color: AppColors.statusCompletedText, size: 18.0),
                        const SizedBox(width: 8.0),
                        Text(
                          'ETA: ${controller.etaMinutes.value} minutes · ${controller.distanceKm.value} km away',
                          style: GoogleFonts.poppins(color: AppColors.statusCompletedText, fontSize: 12.0, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  avatarPath: controller.artisanImageUrl.value.isNotEmpty ? controller.artisanImageUrl.value : AppImages.placeholderAvatar,
                  name: controller.artisanName.value,
                  badgeText: AppStrings.verified.tr,
                  details: '${controller.profession.value} · ${controller.serviceName.value}',
                  ratingValue: '${controller.rating.value} (Verified)',
                  isOnline: true,
                  actionWidget: const SizedBox.shrink(),
                  trailingIcon: GestureDetector(
                    onTap: controller.goToChat,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                      ),
                      child: const Icon(Icons.chat_bubble_outline, color: AppColors.primary, size: 24.0),
                    ),
                  ),
                ),
              )
            ],
          );
        })
    );
  }
}

class PulsingMarker extends StatefulWidget {
  final Widget child;
  final Color color;

  const PulsingMarker({
    super.key,
    required this.child,
    this.color = AppColors.primary,
  });

  @override
  State<PulsingMarker> createState() => _PulsingMarkerState();
}

class _PulsingMarkerState extends State<PulsingMarker> with SingleTickerProviderStateMixin {
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

