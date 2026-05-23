import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/components/custom_dialog.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/components/map_placeholder.dart';
import '../../../../core/components/artisan_bottom_sheet_card.dart';
import '../controllers/finding_artisan_controller.dart';

class FindingArtisanView extends GetView<FindingArtisanController> {
  const FindingArtisanView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FindingArtisanController());
    return Obx(() {
      if (controller.isFound.value) {
        return _buildMapState(context);
      } else {
        return _buildSearchingState(context);
      }
    });
  }

  Widget _buildSearchingState(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text(
          AppStrings.findingArtisan.tr,
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.white),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          _buildRadarAnimation(),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(100),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(100),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Text(
            AppStrings.findingBestArtisan.tr,
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            AppStrings.checkingAvailability.tr,
            style: GoogleFonts.poppins(
              color: AppColors.white.withAlpha(150),
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 32.0),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                _buildSearchStepNode(
                  AppStrings.searchingNearby.tr,
                  isCompleted: true,
                  index: '1',
                ),
                _buildSearchStepNode(
                  AppStrings.checkingAvailability.tr,
                  isActive: true,
                  index: '2',
                ),
                _buildSearchStepNode(AppStrings.matchingRequirements.tr, index: '3'),
                _buildSearchStepNode(AppStrings.artisanFoundConfirming.tr, index: '4'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarAnimation() {
    return SizedBox(
      height: 250.0,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 240.0,
            height: 240.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.radarRing.withAlpha(50),
                width: 1,
              ),
            ),
          ),
          Container(
            width: 170.0,
            height: 170.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.radarRing.withAlpha(80),
                width: 1,
              ),
            ),
          ),
          Container(
            width: 90.0,
            height: 90.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.radarRing.withAlpha(150),
                width: 1,
              ),
            ),
          ),
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: AppColors.timelineActive,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.timelineActive.withAlpha(100),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(Icons.location_on, color: AppColors.white, size: 24.0),
          ),
          Positioned(
            top: 20.0,
            left: MediaQuery.of(Get.context!).size.width * 0.3,
            child: _buildAvatarNode(40.0),
          ),
          Positioned(top: 80.0, right: 40.0, child: _buildAvatarNode(45.0)),
          Positioned(bottom: 60.0, right: 120.0, child: _buildAvatarNode(50.0)),
          Positioned(bottom: 100.0, left: 50.0, child: _buildAvatarNode(45.0)),
        ],
      ),
    );
  }

  Widget _buildAvatarNode(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white.withAlpha(100), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.asset(AppImages.placeholderAvatar, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildSearchStepNode(
      String text, {
        bool isCompleted = false,
        bool isActive = false,
        required String index,
      }) {
    Color bgColor = AppColors.white.withAlpha(10);
    Color borderColor = Colors.transparent;
    Widget leadingWidget = Container(
      width: 24.0,
      height: 24.0,
      decoration: BoxDecoration(
        color: AppColors.white.withAlpha(20),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          index,
          style: TextStyle(
            color: AppColors.white.withAlpha(100),
            fontSize: 10.0,
          ),
        ),
      ),
    );

    if (isCompleted) {
      bgColor = AppColors.timelineActive.withAlpha(20);
      borderColor = AppColors.timelineActive.withAlpha(50);
      leadingWidget = Container(
        width: 24.0,
        height: 24.0,
        decoration: const BoxDecoration(
          color: AppColors.timelineActive,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: AppColors.white, size: 14.0),
      );
    } else if (isActive) {
      bgColor = AppColors.white.withAlpha(15);
      borderColor = AppColors.white.withAlpha(50);
      leadingWidget = Container(
        width: 24.0,
        height: 24.0,
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: 8.0,
            height: 8.0,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          leadingWidget,
          const SizedBox(width: 16.0),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: isCompleted || isActive
                  ? AppColors.white
                  : AppColors.white.withAlpha(100),
              fontSize: 14.0,
              fontWeight: isCompleted || isActive
                  ? FontWeight.w500
                  : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapState(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          AppStrings.findingArtisan.tr,
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textColor),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: MapPlaceholder(
        child: Stack(
          children: [
            Center(
              child: Obx(() {
                final artisan = controller.foundArtisan.value;
                return Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(50),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: artisan != null && artisan['avatar'] != null && artisan['avatar'].isNotEmpty
                        ? Image.network(artisan['avatar'], fit: BoxFit.cover, errorBuilder: (c, e, s) => Image.asset(AppImages.placeholderAvatar))
                        : Image.asset(AppImages.placeholderAvatar, fit: BoxFit.cover),
                  ),
                );
              }),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Obx(() {
                final artisan = controller.foundArtisan.value;
                return ArtisanBottomSheetCard(
                  headerWidget: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: AppColors.timelineActive.withAlpha(20),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check, color: AppColors.timelineActive, size: 16.0),
                          const SizedBox(width: 8.0),
                          Text(
                            artisan != null ? AppStrings.artisanFound.tr : AppStrings.noArtisanNearby.tr,
                            style: GoogleFonts.poppins(
                              color: AppColors.timelineActive,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  avatarPath: artisan != null && artisan['avatar'] != null && artisan['avatar'].isNotEmpty
                      ? artisan['avatar']
                      : AppImages.homeSarahWilliams,
                  name: artisan != null ? artisan['name'] : AppStrings.searching.tr,
                  details: artisan != null
                      ? '${artisan['role']} \u00B7 ${artisan['distance']}'
                      : AppStrings.checkingAvailability.tr,
                  ratingText: AppStrings.rating.tr,
                  ratingValue: artisan != null ? artisan['rating'].toString() : '0.0',
                  actionWidget: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Obx(() => ElevatedButton(
                          onPressed: (artisan != null && !controller.isSubmitting.value) ? controller.trackArtisan : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isSubmitting.value 
                            ? const SizedBox(
                                height: 20, 
                                width: 20, 
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                              )
                            : Text(
                                AppStrings.viewbokking.tr,
                                style: GoogleFonts.poppins(
                                  color: AppColors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                        )),
                      ),
                      const SizedBox(height: 12.0),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                title: AppStrings.cancelOrder.tr,
                                subtitle: AppStrings.cannotUndo.tr,
                                primaryButtonText: AppStrings.confirm.tr,
                                secondaryButtonText: AppStrings.cancel.tr,
                                onPrimaryPressed: () => Navigator.pop(context),
                                onSecondaryPressed: () => Navigator.pop(context),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            side: BorderSide(color: AppColors.greyText.withAlpha(50)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: Text(
                            AppStrings.cancel.tr,
                            style: GoogleFonts.poppins(
                              color: AppColors.greyText,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}