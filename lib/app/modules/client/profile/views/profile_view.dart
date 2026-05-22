import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/components/profile_menu_tile.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller-ke initialize kora holo jodi binding e na thake
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Blue Header Background
          Container(
            height: 350.0,
            width: double.infinity,
            color: AppColors.primary,
          ),

          // 2. Main Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildHeaderActions(),
                  _buildUserInfo(),
                  _buildStatsRow(),
                  // const SizedBox(height: 16.0),

                  // White Card Section (raised)
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: Get.height * 0.6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 32.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Menu List Card
                          _buildMenuCard(),
                          const SizedBox(height: 32.0),
                          _buildRecentBookingsHeader(),
                          const SizedBox(height: 20.0),
                          _buildRecentBookingsList(),
                          const SizedBox(height: 40.0),
                          _buildSignOutButton(),
                          const SizedBox(height: 40.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.myProfile.tr,
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            onTap: controller.editProfile,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: AppColors.white,
                size: 22.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Obx(
        () => Row(
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: AppColors.white.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Obx(() {
                  final imagePath = controller.userProfileImage.value;
                  if (imagePath.isEmpty) {
                    return Image.asset(AppImages.homeMarcusJohnson, fit: BoxFit.cover);
                  }
                  if (imagePath.startsWith('http')) {
                    return Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(AppImages.homeMarcusJohnson, fit: BoxFit.cover),
                    );
                  } else if (imagePath.contains('/') || imagePath.contains('\\')) {
                    return Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(AppImages.homeMarcusJohnson, fit: BoxFit.cover),
                    );
                  }
                  return Image.asset(AppImages.homeMarcusJohnson, fit: BoxFit.cover);
                }),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.userName.value.isEmpty
                        ? "User Name"
                        : controller.userName.value,
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    controller.userEmail.value,
                    style: GoogleFonts.poppins(
                      color: AppColors.white.withOpacity(0.7),
                      fontSize: 14.0,
                    ),
                  ),
                  if (controller.userPhone.value.isNotEmpty && controller.userPhone.value != '...')
                    Text(
                      controller.userPhone.value,
                      style: GoogleFonts.poppins(
                        color: AppColors.white.withOpacity(0.7),
                        fontSize: 14.0,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Obx(() {
          final bookings = controller.stats['bookings']?.toString() ?? '0';
          final reviews = controller.stats['reviews']?.toString() ?? '0';
          final rating = double.tryParse(controller.stats['rating']?.toString() ?? '0.0') ?? 0.0;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(bookings, 'Bookings'),
              _buildStatItem(reviews, 'Reviews'),
              _buildStatItem('${rating.toStringAsFixed(1)} ★', 'Rating Given'),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.05)),
      ),
      child: Obx(() {
        final items = controller.menuItems;
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: items.length,
          separatorBuilder: (_, __) =>
              Divider(color: Colors.grey.withOpacity(0.08), height: 1.0),
          itemBuilder: (context, index) {
            final item = items[index];
            return ProfileMenuTile(
              title: item['title']?.toString() ?? 'Unknown',
              subtitle: item['subtitle']?.toString(),
              icon: item['icon'],
              iconBgColor: (item['color'] as Color?) ?? AppColors.primary,
              onTap: () =>
                  controller.navigateTo(item['title']?.toString() ?? ''),
            );
          },
        );
      }),
    );
  }

  Widget _buildRecentBookingsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.recentBookings.tr,
          style: GoogleFonts.poppins(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
        TextButton(
          onPressed: () {}, // Navigate to all bookings
          child: Text(
            AppStrings.seeAll.tr,
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentBookingsList() {
    return Obx(() {
      if (controller.recentBookings.isEmpty) {
        return Center(
          child: Text(
            "No recent bookings",
            style: GoogleFonts.poppins(color: AppColors.greyText),
          ),
        );
      }
      return Column(
        children: controller.recentBookings.map((order) {
          return _buildBookingTile(order);
        }).toList(),
      );
    });
  }

  Widget _buildBookingTile(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 54.0,
            height: 54.0,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5FA),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: _renderBookingIcon(order['icon']),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['title'] ?? 'Service',
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                Text(
                  order['date'] ?? '',
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
                order['price'] ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Completed',
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


  Widget _renderBookingIcon(dynamic iconData) {
    if (iconData is String) {
      if (iconData.endsWith('.svg')) {
        return SvgPicture.asset(
          iconData,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        );
      }
      return Image.asset(iconData);
    }
    return Icon(iconData as IconData? ?? Icons.build, color: AppColors.primary);
  }

  Widget _buildSignOutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: controller.signOut,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: Color(0xFFF87171), size: 24.0),
            const SizedBox(width: 12.0),
            Text(
              'Sign Out',
              style: GoogleFonts.poppins(
                color: const Color(0xFFF87171),
                fontSize: 17.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
