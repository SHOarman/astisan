import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/components/schedule_card.dart';
import '../../../../core/routes/app_routes.dart';
import '../controllers/worker_home_controller.dart';

class WorkerDashboardView extends GetView<WorkerHomeController> {
  const WorkerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(WorkerHomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            await controller.fetchCurrentStatus();
            await controller.fetchTodaySchedule();
          },
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildTopSection(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24.0),

                      // Schedule Section
                      _buildSectionHeader(
                        "Today's Schedule",
                        "See all",
                        onActionTap: () => Get.toNamed(Routes.WORKER_ORDER_HISTORY),
                      ),
                      const SizedBox(height: 16.0),
                      _buildScheduleList(),

                      const SizedBox(height: 24.0),

                      _buildWeeklySummarySection(),

                      const SizedBox(height: 120.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 30,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: controller.profilePicture.value.isNotEmpty
                            ? (controller.profilePicture.value.startsWith('http')
                                ? DecorationImage(
                                    image: NetworkImage(controller.profilePicture.value),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: FileImage(File(controller.profilePicture.value)),
                                    fit: BoxFit.cover,
                                  ))
                            : const DecorationImage(
                                image: AssetImage(AppImages.homeMarcusJohnson),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: controller.isOnline.value
                              ? AppColors.onlineGreen
                              : AppColors.urgentRed,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back,",
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        controller.userName.value,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.NOTIFICATIONS),

                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.urgentRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24.0),

          // Online/Offline Toggle Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: controller.isOnline.value
                          ? AppColors.onlineGreen
                          : AppColors.urgentRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.isOnline.value
                              ? "You are Online"
                              : "You are Offline",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          controller.isOnline.value
                              ? "Receiving new requests"
                              : "Not accepting requests",
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 13.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 0.85,
                    child: Switch(
                      value: controller.isOnline.value,
                      onChanged: controller.toggleStatus,
                      activeTrackColor: AppColors.onlineGreen,
                      activeThumbColor: Colors.white,
                      inactiveTrackColor: Colors.white.withOpacity(0.3),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24.0),

          // Stats Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                _buildCompactStatCard(
                  "TODAY'S EARNINGS",
                  "\$130",
                  "+12% vs yesterday",
                  AppColors.onlineGreen,
                  null,
                ),
                const SizedBox(width: 16.0),
                _buildCompactStatCard(
                  "TODAY'S JOBS",
                  "2",
                  "Rating: 4.9",
                  AppColors.normalYellow,
                  Icons.star,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatCard(
    String title,
    String value,
    String subtitle,
    Color subtitleColor,
    IconData? icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.5),
                fontSize: 10.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 26.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: subtitleColor, size: 14),
                  const SizedBox(width: 4),
                ] else ...[
                  Icon(Icons.trending_up, color: subtitleColor, size: 14),
                  const SizedBox(width: 4),
                ],
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: subtitleColor,
                    fontSize: 11.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText, {VoidCallback? onActionTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 19.0,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionText,
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleList() {
    if (controller.isScheduleLoading.value) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (controller.scheduleBookings.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              "No bookings scheduled for today",
              style: GoogleFonts.poppins(
                fontSize: 14.0,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: controller.scheduleBookings.take(3).map((booking) {
        // Format distance from server
        String distanceStr = '--';
        if (booking.distanceKm.isNotEmpty) {
          final double? km = double.tryParse(booking.distanceKm);
          if (km != null) {
            distanceStr = '${km.toStringAsFixed(1)} km';
          } else {
            distanceStr = '${booking.distanceKm} km';
          }
        }

        return GestureDetector(
          onTap: () => controller.handleJobTap(booking),
          child: ScheduleCard(
            serviceTitle: booking.serviceName.isNotEmpty ? booking.serviceName : 'Service',
            clientName: booking.clientName,
            clientImage: booking.clientPicture,
            time: booking.formattedTime,
            distance: distanceStr,
            price: booking.basePrice != '0' ? '\$${booking.basePrice}' : '--',
            duration: booking.completionTime.isNotEmpty ? booking.completionTime : booking.scheduledDate,
            status: booking.cardStatus,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeeklySummarySection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "This Week",
                style: GoogleFonts.poppins(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                "Details",
                style: GoogleFonts.poppins(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: controller.weeklySummary.map((item) {
              return _buildSummaryItem(
                item['icon']!,
                item['value']!,
                item['label']!,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String icon, String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 17.0,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11.0,
                color: AppColors.greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
