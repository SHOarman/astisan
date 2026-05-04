import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Text(
          'Notification',
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('TODAY', controller.unreadTodayCount),
              const SizedBox(height: 16.0),
              Obx(() => Column(
                children: controller.todayNotifications.map((notif) => _buildNotificationCard(notif)).toList(),
              )),
              const SizedBox(height: 32.0),
              _buildSectionHeader('EARLIER', 0),
              const SizedBox(height: 16.0),
              Obx(() => Column(
                children: controller.earlierNotifications.map((notif) => _buildNotificationCard(notif)).toList(),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
            letterSpacing: 0.5,
          ),
        ),
        if (count > 0) ...[
          const SizedBox(width: 12.0),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color: AppColors.errorText, // Assuming red from screenshot
              shape: BoxShape.circle,
            ),
            child: Text(
              '$count',
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notif) {
    final bool isUnread = notif['isUnread'] ?? false;
    final bool isTracking = notif['type'] == 'tracking';

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isUnread ? AppColors.primary.withOpacity(0.05) : AppColors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isUnread ? AppColors.primary.withOpacity(0.1) : AppColors.border.withOpacity(0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColors.greyText.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Image.asset(
              notif['icon'],
              width: 32.0,
              height: 32.0,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.notifications),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notif['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Row(
                      children: [
                        Text(
                          notif['time'],
                          style: GoogleFonts.poppins(
                            fontSize: 11.0,
                            color: AppColors.greyText,
                          ),
                        ),
                        if (isUnread) ...[
                          const SizedBox(width: 8.0),
                          Container(
                            width: 8.0,
                            height: 8.0,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  notif['subtitle'],
                  style: GoogleFonts.poppins(
                    fontSize: 13.0,
                    color: AppColors.greyText,
                  ),
                ),
                if (isTracking) ...[
                  const SizedBox(height: 12.0),
                  InkWell(
                    onTap: () => Get.toNamed(Routes.TRACKING),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Track Now',
                            style: GoogleFonts.poppins(
                              color: AppColors.primary.withOpacity(0.6), // Matching the light green style from image with blue tint
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Icon(Icons.arrow_forward, size: 14.0, color: AppColors.primary.withOpacity(0.6)),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
