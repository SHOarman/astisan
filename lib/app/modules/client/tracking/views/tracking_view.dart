import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/components/status_timeline_tile.dart';
import '../../../../core/components/map_placeholder.dart';
import '../../../../core/components/artisan_bottom_sheet_card.dart';
import '../controllers/tracking_controller.dart';

class TrackingView extends GetView<TrackingController> {
  const TrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TrackingController());
    return Obx(() {
      if (!controller.isArrived.value) {
        return _buildMapState(context);
      } else {
        return _buildTimelineState(context);
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
          icon: Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: AppColors.timelineActive.withAlpha(20),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: AppColors.timelineActive.withAlpha(50)),
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
                  SizedBox(width: 4.0),
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
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildArtisanHeader(),
                  SizedBox(height: 16.0),
                  _buildProgressCircle(),
                  SizedBox(height: 16.0),
                  _buildTimeline(),
                  SizedBox(height: 16.0),
                  _buildServiceDetails(),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: controller.viewCompletionWork,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
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
        SizedBox(width: 16.0),
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
                  Icon(Icons.star, color: AppColors.ratingStar, size: 14.0),
                  SizedBox(width: 4.0),
                  Text(
                    '4.9 Â· Plumbing Expert',
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
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(10),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(Icons.chat_bubble_outline, color: AppColors.primary, size: 24.0),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCircle() {
    return Container(
      padding: EdgeInsets.all(24.0),
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
                  backgroundColor: AppColors.primary.withAlpha(20),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.timelineCurrent),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.build_circle_outlined, color: AppColors.timelineCurrent, size: 32.0),
                      SizedBox(height: 4.0),
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
          SizedBox(height: 24.0),
          Text(
            AppStrings.serviceInProgress.tr,
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            'Started at 10:18 AM Â· 34 min elapsed',
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
      padding: EdgeInsets.all(24.0),
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
          SizedBox(height: 24.0),
          const StatusTimelineTile(
            title: 'Booking Confirmed',
            subtitle: 'Your booking has been accepted',
            time: '09:45 AM',
            icon: Icons.check, // Using standard icon as placeholder for custom SVG
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
                    margin: EdgeInsets.only(right: 4.0),
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      color: AppColors.timelineCurrent.withAlpha(100 + (index * 50)),
                      shape: BoxShape.circle,
                    ),
                  )),
                ),
                SizedBox(width: 8.0),
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
      padding: EdgeInsets.all(24.0),
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
          SizedBox(height: 16.0),
          _buildDetailRow('Service', 'Pipe Repair'),
          SizedBox(height: 12.0),
          _buildDetailRow('Location', '123 Main St, NY'),
          SizedBox(height: 12.0),
          _buildDetailRow(AppStrings.estimatedCost.tr, '\$65 - \$120'),
          SizedBox(height: 12.0),
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
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ARTISAN IS ON THE WAY',
                          style: GoogleFonts.poppins(
                            color: AppColors.white.withAlpha(150),
                            fontSize: 10.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Row(
                          children: [
                            Container(
                              width: 8.0,
                              height: 8.0,
                              decoration: const BoxDecoration(
                                color: AppColors.statusCompletedText,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6.0),
                            Text(
                              AppStrings.arrivingIn.tr,
                              style: GoogleFonts.poppins(
                                color: AppColors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.white),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          MapPlaceholder(
             child: Stack(
                children: [
                  Positioned(
                    top: 100.0,
                    left: 50.0,
                    child: CustomPaint(
                      size: Size(150.0, 150.0),
                      painter: RouteLinePainter(),
                    ),
                  ),
                  Positioned(
                    top: 250.0,
                    left: 140.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 44.0,
                          height: 44.0,
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: AppColors.primary.withAlpha(50), blurRadius: 10)
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22.0),
                            child: Image.asset(AppImages.placeholderAvatar, fit: BoxFit.cover),
                          ),
                        ),
                        Container(
                          width: 2.0,
                          height: 12.0,
                          color: AppColors.primary,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            '12 min',
                            style: GoogleFonts.poppins(color: AppColors.white, fontSize: 10.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 150.0,
                    right: 80.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.redAccent.withAlpha(50), blurRadius: 10)],
                          ),
                          child: Icon(Icons.home, color: AppColors.white, size: 16.0),
                        ),
                        Container(
                          width: 2.0,
                          height: 12.0,
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                  ),
                ],
             ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ArtisanBottomSheetCard(
              headerWidget: Container(
                 width: double.infinity,
                 padding: EdgeInsets.symmetric(vertical: 12.0),
                 decoration: BoxDecoration(
                   color: AppColors.statusCompletedText.withAlpha(20),
                   borderRadius: BorderRadius.circular(8.0),
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(Icons.near_me_outlined, color: AppColors.statusCompletedText, size: 18.0),
                     SizedBox(width: 8.0),
                     Text(
                       'ETA: 12 minutes Â· 1.2 km away',
                       style: GoogleFonts.poppins(color: AppColors.statusCompletedText, fontSize: 12.0, fontWeight: FontWeight.w600),
                     ),
                   ],
                 ),
              ),
              avatarPath: AppImages.homeMarcusJohnson,
              name: 'Marcus Johnson',
              badgeText: AppStrings.verified.tr,
              details: 'Plumber · Pipe Leak Repair',
              ratingValue: '4.9 (127 jobs)',
              isOnline: true,
              actionWidget: const SizedBox.shrink(),
              trailingIcon: GestureDetector(
                onTap: controller.goToChat,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(10),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: AppColors.primary.withAlpha(20)),
                  ),
                  child: const Icon(Icons.chat_bubble_outline, color: AppColors.primary, size: 24.0),
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}

class RouteLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;
    
    // Simulating a route line
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.5);
    path.lineTo(size.width * 0.5, size.height * 0.5);
    path.lineTo(size.width * 0.5, 0);

    // Draw dotted line
    Path dashPath = Path();
    double dashWidth = 8.0;
    double dashSpace = 6.0;
    double distance = 0.0;
    
    for (var pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

