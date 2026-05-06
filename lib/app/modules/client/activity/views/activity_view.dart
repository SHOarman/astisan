import 'package:artisan/app/modules/client/activity/views/cancelle.dart';
import 'package:artisan/app/modules/client/activity/views/completed.dart';
import 'package:artisan/app/modules/client/activity/views/rejected.dart';
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
          // Search Bar ebong TabBar eikhane PreferredSize-e rakha hoyeche
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(130.0),
            child: Column(
              children: [
                // 1. Search Bar Design (Image er moto)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F5FA), // Light blueish grey
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search orders...",
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

                // 2. TabBar Design (Image er moto Capsule style)
                TabBar(
                  isScrollable: true,
                  dividerColor: Colors.transparent,

                  labelColor: Colors.white,
                  indicator: BoxDecoration(
                    color: const Color(0xFF2E5B8E), // Deep blue for active tab
                  ),
                  tabs: [
                    _buildTab("Upcoming", "2"),
                    _buildTab("Completed", "1"),
                    _buildTab("Cancelle", "3"),
                    _buildTab("Rejected", "1"),
                  ],
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [Upcoming(), Completed(), Cancelle(), Rejected()],
        ),
      ),
    );
  }

  Widget _buildTab(String text, String count) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color(0xFFE0E0E0),
                shape: BoxShape.circle,
              ),
              child: Text(
                count,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
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
