import 'package:artisan/app/modules/client/activity/views/cancelled.dart';
import 'package:artisan/app/modules/client/activity/views/completed.dart';
import 'package:artisan/app/modules/client/activity/views/confirmed.dart';
import 'package:artisan/app/modules/client/activity/views/upcoming.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/activity_controller.dart';

class ActivityView extends GetView<ActivityController> {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ActivityController());

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          leading: _buildBackButton(),
          title: Text(
            AppStrings.orderHistory.tr,
            style: GoogleFonts.poppins(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(130.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F5FA),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: AppStrings.searchOrders.tr,
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[400],
                          fontSize: 15.0,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.blueGrey,
                          size: 24.0,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Obx(() => TabBar(
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: const Color(0xFF2E5B8E),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  tabs: [
                    _buildTab(AppStrings.upcoming.tr, controller.getCount("Upcoming").toString()),
                    _buildTab(AppStrings.bookingConfirmed.tr, controller.getCount("Confirmed").toString()),
                    _buildTab(AppStrings.completed.tr, controller.getCount("Completed").toString()),
                    _buildTab(AppStrings.cancelled.tr, controller.getCount("Cancelled").toString()),
                  ],
                )),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => controller.fetchAllBookings(),
          color: const Color(0xFF2E5B8E),
          child: const TabBarView(
            children: [
              Upcoming(),
              Confirmed(),
              Completed(),
              Cancelled(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String text, String count) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Text(
                count,
                style: GoogleFonts.poppins(
                  color: Colors.black54,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: InkWell(
        onTap: () => Get.back(),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: AppColors.socialButtonBg,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.textColor,
            size: 20.0,
          ),
        ),
      ),
    );
  }
}
