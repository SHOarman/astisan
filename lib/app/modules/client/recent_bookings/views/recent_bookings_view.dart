import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/Services/api_services.dart';
import '../../activity/controllers/activity_controller.dart';

class RecentBookingsView extends GetView<ActivityController> {
  const RecentBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is available since we are sharing it
    if (!Get.isRegistered<ActivityController>()) {
      Get.put(ActivityController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Recent All Booking List',
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
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.completedBookings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.completedBookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: AppColors.greyText.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    "No completed bookings found",
                    style: GoogleFonts.poppins(color: AppColors.greyText),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            itemCount: controller.completedBookings.length,
            itemBuilder: (context, index) {
              final order = controller.completedBookings[index];
              return _buildBookingTile(order);
            },
          );
        }),
      ),
    );
  }

  Widget _buildBookingTile(Map<String, dynamic> order) {
    final String artisanName = order['artisan_name'] ?? order['client_name'] ?? 'Artisan';
    final String picUrl = ApiServices.formatImageUrl(order['artisan_picture'] ?? order['client_picture']);
    final String dateStr = order['scheduled_date'] ?? '';
    final String amount = order['total_amount']?.toString() ?? order['base_price']?.toString() ?? '0.00';

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: Image.network(
              picUrl,
              width: 54.0,
              height: 54.0,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 54.0,
                height: 54.0,
                color: const Color(0xFFF0F5FA),
                child: const Icon(Icons.person, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artisanName,
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  dateStr,
                  style: GoogleFonts.poppins(
                    fontSize: 13.0,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$$amount',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.completed.tr,
                style: GoogleFonts.poppins(
                  fontSize: 11.0,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
