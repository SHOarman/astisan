import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import 'package:artisan/app/core/constants/static/app_images.dart';
import '../../../../core/components/fixed_bottom_action_bar.dart';
import '../controllers/service_details_controller.dart';

class ServiceDetailsView extends GetView<ServiceDetailsController> {
  const ServiceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ServiceDetailsController());
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.serviceDetails.tr,
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
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
                        Obx(() {
                          if (controller.selectedTab.value == 0) {
                            return _buildOverviewSection();
                          } else {
                            return _buildReviewsSection();
                          }
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          FixedBottomActionBar(
            leadingText: AppStrings.startingFrom.tr,
            leadingValue: '\$35',
            buttonText: AppStrings.bookNow.tr,
            onPressed: controller.bookNow,
          ),
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
            Image.asset(
              AppImages.popElectricalWiring,
              width: double.infinity,
              height: 220.0,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 16.0,
              right: 16.0,
              child: Row(
                children: [
                  _buildIconButton(Icons.share, () {}),
                  const SizedBox(width: 12.0),
                  Obx(() => _buildIconButton(
                        controller.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                        controller.toggleFavorite,
                        color: controller.isFavorite.value ? AppColors.errorText : AppColors.white,
                      )),
                ],
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: AppColors.textColor.withAlpha(180),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.ratingStar, size: 16.0),
                    const SizedBox(width: 4.0),
                    Text(
                      '4.7',
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '(54 reviews)',
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
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
        decoration: BoxDecoration(
          color: AppColors.textColor.withAlpha(100),
          shape: BoxShape.circle,
        ),
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
              child: Text(
                'Pipe Leak Repair',
                style: GoogleFonts.poppins(
                  color: AppColors.textColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: AppColors.badgePopularBg,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, color: AppColors.badgePopularText, size: 16),
                  const SizedBox(width: 4.0),
                  Text(
                    AppStrings.popular.tr,
                    style: GoogleFonts.poppins(
                      color: AppColors.badgePopularText,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Row(
          children: [
            const Icon(Icons.access_time, color: AppColors.greyText, size: 16.0),
            const SizedBox(width: 4.0),
            Text(
              AppStrings.hr1.tr,
              style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 14.0),
            ),
            const SizedBox(width: 16.0),
            const Icon(Icons.shield_outlined, color: AppColors.statusCompletedText, size: 16.0),
            const SizedBox(width: 4.0),
            Text(
              AppStrings.insured.tr,
              style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 14.0),
            ),
            const SizedBox(width: 16.0),
            Text(
              '\$35-\$65',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border),
      ),
      child: Obx(() => Row(
            children: [
              Expanded(
                child: _buildTab(AppStrings.overview.tr, controller.selectedTab.value == 0, () => controller.changeTab(0)),
              ),
              Expanded(
                child: _buildTab(AppStrings.reviews.tr, controller.selectedTab.value == 1, () => controller.changeTab(1)),
              ),
            ],
          )),
    );
  }

  Widget _buildTab(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: isSelected ? AppColors.textColor : AppColors.greyText,
            fontSize: 14.0,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDescription(),
        const SizedBox(height: 24.0),
        _buildWhatsIncluded(),
        const SizedBox(height: 24.0),
        _buildTopArtisan(),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.star_rounded, color: AppColors.ratingStar, size: 24.0),
            const SizedBox(width: 8.0),
            Text(
              '4.7 Average Rating',
              style: GoogleFonts.poppins(
                color: AppColors.textColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '(54 reviews)',
              style: GoogleFonts.poppins(
                color: AppColors.greyText,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.reviews.length,
          itemBuilder: (context, index) {
            final review = controller.reviews[index];
            return _buildReviewCard(review);
          },
        ),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F4F8))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: AssetImage(review['image']),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'],
                      style: GoogleFonts.poppins(
                        color: AppColors.textColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      review['date'],
                      style: GoogleFonts.poppins(
                        color: AppColors.greyText,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star_rounded,
                    color: index < review['rating'] ? AppColors.ratingStar : AppColors.border,
                    size: 16.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            review['comment'],
            style: GoogleFonts.poppins(
              color: AppColors.greyText,
              fontSize: 14.0,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'Complete toilet repair and replacement services including flush systems, seals, and fittings.',
      style: GoogleFonts.poppins(
        color: AppColors.greyText,
        fontSize: 14.0,
        height: 1.5,
      ),
    );
  }

  Widget _buildWhatsIncluded() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.whatsIncluded.tr,
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16.0),
          ...controller.whatsIncluded.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: AppColors.statusCompletedText, size: 20.0),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.poppins(
                          color: AppColors.greyText,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTopArtisan() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.topArtisanForThis.tr,
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      AppImages.homeSarahWilliams,
                      width: 48.0,
                      height: 48.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 14.0,
                      height: 14.0,
                      decoration: BoxDecoration(
                        color: AppColors.statusCompletedText,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Marcus Johnson',
                      style: GoogleFonts.poppins(
                        color: AppColors.textColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.ratingStar, size: 14.0),
                        const SizedBox(width: 4.0),
                        Text(
                          '4.9',
                          style: GoogleFonts.poppins(
                            color: AppColors.textColor,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            ' \u00b7 127 jobs',
                            style: GoogleFonts.poppins(
                              color: AppColors.greyText,
                              fontSize: 12.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                AppStrings.view.tr,
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontSize: 14.0,
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
