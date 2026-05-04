import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Condition;
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/components/service_item_card.dart';
import '../../../../core/components/artisan_profile_card.dart';
import '../inner_widgets/promo_card.dart';
import '../controllers/home_controller.dart';

import '../../../../core/routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Transform.translate(
              offset: Offset(0, -24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.0),
                      _buildForYouSection(),
                      SizedBox(height: 24.0),
                      _buildPopularServicesSection(context),
                      SizedBox(height: 24.0),
                      _buildRecommendedArtisansSection(),
                      SizedBox(height: 24.0),
                      _buildPromoBanner(),
                      SizedBox(height: 40.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: 60.0,
        left: 24.0,
        right: 24.0,
        bottom: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Get.toNamed(Routes.SELECT_LOCATION),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.white, size: 24.0),
                    SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                controller.selectedCity.value,
                                style: GoogleFonts.poppins(
                                  color: AppColors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.white,
                              size: 20.0,
                            ),
                          ],
                        ),
                        Obx(
                          () => Text(
                            controller.selectedAddress.value,
                            style: GoogleFonts.poppins(
                              color: AppColors.white.withAlpha(200),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                child: Icon(
                  Icons.notifications_none,
                  color: AppColors.white,
                  size: 24.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: AppStrings.searchService.tr,
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.greyText,
                  fontSize: 14.0,
                ),
                icon: const Icon(Icons.search, color: AppColors.greyText),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 24.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.asset(
              AppImages.bannerHome,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForYouSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.forYou.tr,
              style: GoogleFonts.poppins(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.SERVICES),
              child: Icon(
                Icons.arrow_forward,
                color: AppColors.textColor,
                size: 20.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        SizedBox(
          height: 160.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.forYouCategories.length,
            separatorBuilder: (context, index) => SizedBox(width: 16.0),
            itemBuilder: (context, index) {
              final cat = controller.forYouCategories[index];
              return SizedBox(
                width: 150.0,
                child: _buildForYouCard(
                  title: cat['title'],
                  iconPath: cat['icon'],
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildForYouCard({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha(10),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: 50.0,
              width: 50.0,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, color: Colors.grey),
            ),
            SizedBox(height: 12.0),
            Flexible(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularServicesSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.popularServices.tr,
              style: GoogleFonts.poppins(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.POPULAR_SERVICES),
              child: Row(
                children: [
                  Text(
                    AppStrings.seeAll.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                    size: 20.0,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Obx(() {
          final items = controller.popularServices.take(4).toList();
          return GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveValue<int>(
                context,
                defaultValue: 2,
                conditionalValues: [
                  const Condition.largerThan(name: MOBILE, value: 3),
                  const Condition.largerThan(name: TABLET, value: 4),
                ],
              ).value,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              childAspectRatio: 0.75,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final service = items[index];
              return ServiceItemCard(
                title: service['title'],
                imagePath: service['image'],
                rating: service['rating'],
                reviews: service['reviews'],
                priceRange: service['priceRange'],
                onTap: () {
                  Get.toNamed(Routes.BOOKING, arguments: {
                    'service': service,
                    'source': 'popular_services',
                  });
                },
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildRecommendedArtisansSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.recommendedArtisans.tr,
              style: GoogleFonts.poppins(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            Text(
              AppStrings.seeAll.tr,
              style: GoogleFonts.poppins(
                fontSize: 14.0,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Obx(
          () => ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.recommendedArtisans.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.0),
            itemBuilder: (context, index) {
              final artisan = controller.recommendedArtisans[index];
              return ArtisanProfileCard(
                name: artisan['name'],
                role: artisan['role'],
                avatarPath: artisan['avatar'],
                isVerified: artisan['isVerified'],
                rating: artisan['rating'],
                reviews: artisan['reviews'],
                pricePerHour: artisan['pricePerHour'],
                distanceOrTime: artisan['distanceOrTime'],
                onTap: () {
                  Get.toNamed(Routes.SERVICE_DETAILS, arguments: artisan);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPromoBanner() {
    return const PromoCard();
  }
}
