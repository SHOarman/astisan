import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/components/artisan_profile_card.dart';
import '../controllers/nearby_artisans_controller.dart';

class NearbyArtisansView extends GetView<NearbyArtisansController> {
  const NearbyArtisansView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Recommended Artisans',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Obx(() => Text(
                'Available for ${controller.serviceName}',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.greyText,
                ),
              )),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.artisans.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_search, size: 64, color: AppColors.greyText.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          "No verified artisans found nearby",
                          style: GoogleFonts.poppins(color: AppColors.greyText),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  itemCount: controller.artisans.length,
                  itemBuilder: (context, index) {
                    final artisan = controller.artisans[index];
                    return ArtisanProfileCard(
                      name: artisan['full_name'] ?? artisan['name'] ?? 'Artisan',
                      role: artisan['occupation'] ?? artisan['role'] ?? 'Specialist',
                      avatarPath: artisan['profile_picture'] ?? artisan['avatar'],
                      isVerified: artisan['is_verified'] ?? artisan['isVerified'] ?? false,
                      rating: artisan['rating'] ?? 0.0,
                      reviews: artisan['review_count'] ?? artisan['reviews'] ?? 0,
                      pricePerHour: artisan['hourly_rate']?.toString() ?? artisan['price']?.toString() ?? '25',
                      distanceOrTime: artisan['distance'] ?? artisan['distanceOrTime'] ?? 'Nearby',
                      isOnline: artisan['is_online'] ?? artisan['isOnline'] ?? true,
                      onTap: () {
                        Get.toNamed(Routes.SERVICE_DETAILS, arguments: {
                          'service': controller.serviceData.value,
                          'artisan': artisan,
                          'source': 'nearby_artisans',
                        });
                      },
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


}
