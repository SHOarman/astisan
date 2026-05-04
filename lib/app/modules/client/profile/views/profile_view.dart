import 'package:flutter/material.dart';
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
    Get.put(ProfileController());
    return Scaffold(
      backgroundColor: Colors.white, // Overall background is white for the content area
      body: Stack(
        children: [
          // 1. Blue Header Background
          Container(
            height: 320.0,
            width: double.infinity,
            color: AppColors.primary,
          ),

          // 2. Main Content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header Title & Edit Action
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                            child: const Icon(Icons.edit_outlined, color: AppColors.white, size: 22.0),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Alex Thompson Section (on Blue)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: AppColors.white.withOpacity(0.5), width: 1),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset(
                              AppImages.homeMarcusJohnson, // Using a consistent avatar
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.userName.value,
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

                  const SizedBox(height: 24.0),

                  // Stats Row (on Blue, wide pill)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(controller.stats['bookings'].toString(), AppStrings.bookings.tr),
                          _buildStatItem(controller.stats['reviews'].toString(), AppStrings.reviews.tr),
                          _buildStatItem('${controller.stats['rating']} ★', 'Rating Given'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // White Card Section (raised)
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Menu List Card
                          Container(
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
                            child: _buildMenuTiles(),
                          ),

                          const SizedBox(height: 32.0),

                          // Recent Bookings Title
                          Row(
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
                              Text(
                                AppStrings.seeAll.tr,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.0,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20.0),

                          // Recent Bookings List
                          _buildRecentBookings(),

                          const SizedBox(height: 40.0),

                          // Sign Out Button
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

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.white.withOpacity(0.6),
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTiles() {
    return Obx(() => ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: controller.menuItems.length,
      separatorBuilder: (context, index) => Divider(color: Colors.grey.withOpacity(0.08), height: 1.0),
      itemBuilder: (context, index) {
        final item = controller.menuItems[index];
        return ProfileMenuTile(
          title: item['title'] as String,
          subtitle: item['subtitle'] as String?,
          icon: item['icon'],
          iconBgColor: item['color'] as Color,
          onTap: () => controller.navigateTo(item['title'] as String),
        );
      },
    ));
  }

  Widget _buildRecentBookings() {
    return Obx(() => Column(
      children: controller.recentBookings.map((order) {
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
                      order['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      order['date'],
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Completed',
                      style: GoogleFonts.poppins(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    order['price'],
                    style: GoogleFonts.poppins(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    ));
  }

  Widget _renderBookingIcon(dynamic iconData) {
    if (iconData is String) {
      if (iconData.endsWith('.svg')) {
        return SvgPicture.asset(iconData, colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn));
      }
      return Image.asset(iconData);
    }
    return Icon(iconData as IconData, color: AppColors.primary);
  }

  Widget _buildSignOutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: controller.signOut,
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFFFEBEB),
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
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
