import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
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
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  itemCount: controller.artisans.length,
                  itemBuilder: (context, index) {
                    final artisan = controller.artisans[index];
                    return _buildArtisanCard(artisan);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtisanCard(Map<String, dynamic> artisan) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.SERVICE_DETAILS, arguments: {
          'service': controller.serviceData.value,
          'artisan': artisan,
          'source': 'nearby_artisans',
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: artisan['profile_picture'].isNotEmpty
                      ? Image.network(
                          artisan['profile_picture'],
                          width: 70.0,
                          height: 70.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildAvatarPlaceholder(),
                        )
                      : _buildAvatarPlaceholder(),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.onlineGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16.0),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          artisan['full_name'],
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.statusCompletedBg.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'VERIFIED',
                          style: GoogleFonts.poppins(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w700,
                            color: AppColors.statusCompletedText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    artisan['occupation'],
                    style: GoogleFonts.poppins(
                      fontSize: 13.0,
                      color: AppColors.greyText,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      if (artisan['rating'] > 0) ...[
                        const Icon(Icons.star, color: AppColors.ratingStar, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          artisan['rating'].toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          ' (${artisan['review_count']})',
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                            color: AppColors.greyText,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      const Icon(Icons.access_time, color: AppColors.greyText, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        artisan['distance'],
                        style: GoogleFonts.poppins(
                          fontSize: 12.0,
                          color: AppColors.greyText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${artisan['hourly_rate']}',
                  style: GoogleFonts.poppins(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '/hr',
                  style: GoogleFonts.poppins(
                    fontSize: 12.0,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      width: 70.0,
      height: 70.0,
      color: AppColors.primary.withOpacity(0.1),
      child: const Icon(Icons.person, color: AppColors.primary),
    );
  }
}
