import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import 'package:artisan/app/core/constants/static/app_images.dart';
import '../../../../core/components/fixed_bottom_action_bar.dart';
import '../../../../core/routes/app_routes.dart';
import '../controllers/service_details_controller.dart';
import 'artisan_profile_view.dart' as artisan_profile_view;

class ServiceDetailsView extends GetView<ServiceDetailsController> {
  const ServiceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: Use Bindings for production, Get.put for quick testing
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() => Text(
            controller.isArtisanSpecificFlow.value 
                ? 'Artisan Details'
                : AppStrings.serviceDetails.tr,
            style: GoogleFonts.poppins(color: AppColors.white, fontSize: 18.0, fontWeight: FontWeight.w600))),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroImage(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleSection(),
                        const SizedBox(height: 24.0),
                        _buildTabs(),
                        const SizedBox(height: 24.0),
                        Obx(() => controller.selectedTab.value == 0
                            ? _buildOverviewSection()
                            : _buildReviewsSection()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() => FixedBottomActionBar(
            leadingText: AppStrings.startingFrom.tr,
            leadingValue: '\$${controller.artisanData['price'] ?? controller.artisanData['hourly_rate'] ?? '0'}',
            buttonText: AppStrings.bookNow.tr,
            onPressed: controller.bookNow,
          )),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          children: [
            Obx(() {
              final imagePath = controller.artisanData['avatar'] ?? controller.artisanData['profile_picture'] ?? controller.serviceData['image'] ?? AppImages.popElectricalWiring;
              return imagePath.toString().startsWith('http')
                  ? Image.network(imagePath, width: double.infinity, height: 220.0, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(AppImages.popElectricalWiring, fit: BoxFit.cover))
                  : Image.asset(imagePath, width: double.infinity, height: 220.0, fit: BoxFit.cover);
            }),

            Positioned(
              bottom: 16.0, left: 16.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(color: AppColors.textColor.withAlpha(180), borderRadius: BorderRadius.circular(20.0)),
                child: Row(children: [
                  const Icon(Icons.star, color: AppColors.ratingStar, size: 16.0),
                  const SizedBox(width: 4.0),
                  Obx(() => Text('${controller.serviceData['rating'] ?? controller.artisanData['rating'] ?? '4.7'}',
                      style: GoogleFonts.poppins(color: AppColors.white, fontSize: 14.0, fontWeight: FontWeight.w600))),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, {Color color = AppColors.white}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(color: AppColors.textColor.withAlpha(100), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20.0),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Obx(() => Text(controller.serviceData['title'] ?? 'Service Details',
                  style: GoogleFonts.poppins(color: AppColors.textColor, fontSize: 22.0, fontWeight: FontWeight.w700))),
            ),
            Obx(() {
              if (controller.serviceData['is_popular'] == true || controller.serviceData['isPopular'] == true || controller.artisanData['is_popular'] == true) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                  decoration: BoxDecoration(color: AppColors.badgePopularBg, borderRadius: BorderRadius.circular(12.0)),
                  child: Row(children: [
                    const Icon(Icons.local_fire_department, color: AppColors.badgePopularText, size: 16),
                    const SizedBox(width: 4.0),
                    Text(AppStrings.popular.tr, style: GoogleFonts.poppins(color: AppColors.badgePopularText, fontSize: 10.0, fontWeight: FontWeight.w600)),
                  ]),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
        const SizedBox(height: 12.0),
        Row(
          children: [
            const Icon(Icons.access_time, color: AppColors.greyText, size: 16.0),
            const SizedBox(width: 4.0),
            Obx(() => Text(controller.serviceData['duration'] ?? '1 hr',
                style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 14.0))),
            const SizedBox(width: 16.0),
            const Icon(Icons.verified_user_outlined, color: AppColors.onlineGreen, size: 16.0),
            const SizedBox(width: 4.0),
            Text('Insured', style: GoogleFonts.poppins(color: AppColors.onlineGreen, fontSize: 14.0)),
            const SizedBox(width: 16.0),
            Expanded(
              child: Obx(() {
                final price = controller.serviceData['price'] ?? controller.serviceData['price_range'] ?? controller.artisanData['price'] ?? controller.artisanData['hourly_rate'];
                return Text(
                  price != null ? (price.toString().startsWith('\$') ? price.toString() : '\$$price') : '\$40-\$80',
                  textAlign: TextAlign.end,
                  style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 18.0, fontWeight: FontWeight.w700),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(16.0), border: Border.all(color: AppColors.border)),
      child: Obx(() => Row(
        children: [
          Expanded(child: _buildTab(AppStrings.overview.tr, controller.selectedTab.value == 0, () => controller.changeTab(0))),
          Expanded(child: _buildTab(AppStrings.reviews.tr, controller.selectedTab.value == 1, () => controller.changeTab(1))),
        ],
      )),
    );
  }

  Widget _buildTab(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(color: isSelected ? AppColors.white : Colors.transparent, borderRadius: BorderRadius.circular(12.0)),
        alignment: Alignment.center,
        child: Text(title, style: GoogleFonts.poppins(color: isSelected ? AppColors.textColor : AppColors.greyText, fontSize: 14.0, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if (controller.isArtisanSpecificFlow.value) {
            // ... (keep the artisan profile code I added earlier)
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('About Artisan'),
                const SizedBox(height: 12.0),
                Text(
                  controller.artisanBio.value.isNotEmpty
                      ? controller.artisanBio.value
                      : 'Experienced artisan with a proven track record of providing high-quality services.',
                  style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 14.0, height: 1.5),
                ),
                const SizedBox(height: 24.0),
                // (keeping experience, skills, areas...)
                if (controller.artisanExperience.value.isNotEmpty) ...[
                  _buildSectionTitle('Experience'),
                  const SizedBox(height: 8.0),
                  Text(controller.artisanExperience.value, style: GoogleFonts.poppins(color: AppColors.textColor, fontSize: 14.0, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 24.0),
                ],
                if (controller.artisanSkills.isNotEmpty) ...[
                  _buildSectionTitle('Skills & Expertise'),
                  const SizedBox(height: 12.0),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: controller.artisanSkills.map((skill) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.primary.withAlpha(50))),
                      child: Text(skill, style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                    )).toList(),
                  ),
                  const SizedBox(height: 24.0),
                ],
                if (controller.artisanServiceAreas.isNotEmpty) ...[
                  _buildSectionTitle('Service Areas'),
                  const SizedBox(height: 12.0),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: controller.artisanServiceAreas.map((area) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.onlineGreen.withAlpha(20), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.onlineGreen.withAlpha(50))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on, size: 14, color: AppColors.onlineGreen),
                          const SizedBox(width: 4),
                          Text(area, style: GoogleFonts.poppins(color: AppColors.onlineGreen, fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 24.0),
                ],
              ],
            );
          }
          
          // FOR SERVICE FLOW (Popular Services Click)
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Service Overview'),
              const SizedBox(height: 12.0),
              Text(
                controller.serviceData['description'] ?? 'High-quality professional services tailored to your needs.',
                style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 14.0, height: 1.5),
              ),
              const SizedBox(height: 32.0),
              _buildTopArtisan(), // Show top artisan for this service
            ],
          );
        }),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w700, color: AppColors.textColor),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(Icons.star_rounded, color: AppColors.ratingStar, size: 24.0),
          const SizedBox(width: 8.0),
          Text('4.7 Average Rating', style: GoogleFonts.poppins(color: AppColors.textColor, fontSize: 16.0, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 24.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.reviews.length,
          itemBuilder: (context, index) => _buildReviewCard(controller.reviews[index]),
        ),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF1F4F8)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(radius: 20.0, backgroundImage: AssetImage(review['image'])),
            const SizedBox(width: 12.0),
            Expanded(child: Text(review['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.w700))),
          ]),
          const SizedBox(height: 12.0),
          Text(review['comment'], style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 14.0)),
        ],
      ),
    );
  }

  Widget _buildTopArtisan() {
    return Obx(() {
      if (controller.isLoadingTopArtisans.value) return const Center(child: CircularProgressIndicator());
      if (controller.topArtisans.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.topArtisanForThis.tr, style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16.0),
          ...controller.topArtisans.take(1).map((artisan) => _buildArtisanCard(artisan)).toList(),
        ],
      );
    });
  }

  Widget _buildArtisanCard(Map<String, dynamic> artisan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16.0), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(10.0), child: _buildArtisanImage(artisan['avatar'])),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(artisan['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              Row(
                children: [
                  const Icon(Icons.star, color: AppColors.ratingStar, size: 14),
                  const SizedBox(width: 4),
                  Text('${artisan['rating']}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                  Text(' • ${artisan['jobsDone']} jobs', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.greyText)),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            // Save the current artisan data, then navigate.
            final previousArtisan = Map<String, dynamic>.from(controller.artisanData);
            controller.artisanData.assignAll(artisan);
            
            // Explicitly fetch the profile for the new artisan
            controller.fetchArtisanProfile();
            
            Get.to(() => const artisan_profile_view.ArtisanProfileView())?.then((_) {
              // Restore artisan data when coming back
              controller.artisanData.assignAll(previousArtisan);
            });
          },
          child: Text('View', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }

  Widget _buildArtisanImage(String? url) {
    if (url == null || url.isEmpty) return Container(width: 56, height: 56, color: Colors.grey[200]);
    return Image.network(url, width: 56.0, height: 56.0, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(width: 56, height: 56, color: Colors.grey[200]));
  }
}