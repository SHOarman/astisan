import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/components/order_history_card.dart';
import '../controllers/activity_controller.dart';

class ActivityView extends GetView<ActivityController> {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ActivityController());
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: InkWell(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.socialButtonBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: AppColors.textColor, size: 20.0),
            ),
          ),
        ),
        title: Text(
          AppStrings.orderHistory.tr,
          style: GoogleFonts.poppins(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildSearchBar(),
            ),
            
            const SizedBox(height: 24.0),
            
            // Filter Horizontal Scroll
            _buildFilters(),
            
            const SizedBox(height: 24.0),
            
            // Order List
            Expanded(
              child: Obx(() {
                final filtered = controller.filteredOrders;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  itemCount: filtered.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final order = filtered[index];
                    return OrderHistoryCard(
                      title: order['title'],
                      artisanName: order['artisanName'],
                      date: order['date'],
                      price: order['price'],
                      status: order['status'],
                      imagePath: order['image'],
                      artisanAvatarPath: order['avatar'],
                      onRate: () {},
                      onRebook: () {},
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FA), // Light blueish grey search background from image
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: AppStrings.searchOrders.tr,
          hintStyle: GoogleFonts.poppins(
            color: AppColors.greyText.withOpacity(0.7),
            fontSize: 15.0,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.greyText, size: 24.0),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.tune, color: AppColors.greyText, size: 22.0), // Filter icon
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: controller.filters.map((filter) {
          final isSelected = filter == controller.selectedFilter.value;
          final count = controller.getFilterCount(filter);
          
          return GestureDetector(
            onTap: () => controller.changeFilter(filter),
            child: Container(
              margin: const EdgeInsets.only(right: 12.0),
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(30.0),
                border: isSelected ? null : Border.all(color: AppColors.border.withOpacity(0.5)),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ] : [],
              ),
              child: Row(
                children: [
                  Text(
                    filter,
                    style: GoogleFonts.poppins(
                      color: isSelected ? AppColors.white : AppColors.greyText,
                      fontSize: 14.0,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  if (count > 0) ...[
                    const SizedBox(width: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.white.withOpacity(0.2) 
                            : AppColors.greyText.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        '$count',
                        style: GoogleFonts.poppins(
                          color: isSelected ? AppColors.white : AppColors.greyText,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ));
  }
}
