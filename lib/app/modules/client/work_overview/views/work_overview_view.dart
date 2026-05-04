import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/components/cost_breakdown_card.dart';
import '../../../../core/components/photo_thumbnail_tile.dart';
import '../controllers/work_overview_controller.dart';

class WorkOverviewView extends GetView<WorkOverviewController> {
  const WorkOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(WorkOverviewController());
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.workOverview.tr,
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
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: AppColors.timelineActive.withAlpha(20),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: AppColors.timelineActive.withAlpha(50)),
            ),
            child: Center(
              child: Row(
                children: [
                  Container(
                    width: 6.0,
                    height: 6.0,
                    decoration: const BoxDecoration(
                      color: AppColors.timelineActive,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    AppStrings.live.tr,
                    style: GoogleFonts.poppins(
                      color: AppColors.timelineActive,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSuccessBanner(),
                  SizedBox(height: 16.0),
                  _buildArtisanSnippet(),
                  SizedBox(height: 16.0),
                  _buildWorkCompleted(),
                  SizedBox(height: 16.0),
                  _buildPhotosSection(),
                  SizedBox(height: 16.0),
                  _buildCostBreakdown(),
                  SizedBox(height: 16.0),
                  _buildGuaranteeBox(),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildSuccessBanner() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.statusCompletedText.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle_outline, color: AppColors.statusCompletedText, size: 28.0),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.serviceCompletedSuccess.tr,
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Completed at 11:54 AM Â· Duration: 1h 36min',
                  style: GoogleFonts.poppins(
                    color: AppColors.white.withAlpha(200),
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtisanSnippet() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              AppImages.homeMarcusJohnson,
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'James Wilson',
                  style: GoogleFonts.poppins(
                    color: AppColors.textColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Plumbing Expert',
                  style: GoogleFonts.poppins(
                    color: AppColors.greyText,
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.ratingStar, size: 14.0),
                    SizedBox(width: 4.0),
                    Text(
                      '4.9 Â· Expert',
                      style: GoogleFonts.poppins(
                        color: AppColors.textColor,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: AppColors.statusCompletedText.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: AppColors.statusCompletedText, size: 16.0),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkCompleted() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.build_outlined, color: AppColors.primary, size: 20.0),
              SizedBox(width: 8.0),
              Text(
                AppStrings.workCompleted.tr,
                style: GoogleFonts.poppins(
                  color: AppColors.textColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          ...controller.completedTasks.map((task) => Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: AppColors.statusCompletedText, size: 18.0),
                    SizedBox(width: 12.0),
                    Text(
                      task,
                      style: GoogleFonts.poppins(
                        color: AppColors.greyText,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.photos.tr,
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            PhotoThumbnailTile(child: Icon(Icons.build, color: AppColors.greyText, size: 24.0)),
            PhotoThumbnailTile(child: Icon(Icons.water_drop, color: Colors.blue, size: 24.0)),
            PhotoThumbnailTile(child: Icon(Icons.check_box, color: Colors.green, size: 24.0)),
          ],
        ),
        SizedBox(height: 8.0),
        Text(
          '3 photos captured by artisan',
          style: GoogleFonts.poppins(
            color: AppColors.greyText,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  Widget _buildCostBreakdown() {
    return CostBreakdownCard(
      icon: Icons.credit_card_outlined,
      cardTitle: 'Cost Breakdown',
      items: [
        CostBreakdownItem(title: 'Labor (1.5 hrs @ \$55/hr)', amount: '\$82.50'),
        CostBreakdownItem(title: 'Parts: Pipe fitting Ã—2', amount: '\$18.00'),
        CostBreakdownItem(title: 'Parts: Pressure valve', amount: '\$24.50'),
        CostBreakdownItem(title: 'Platform fee (5%)', amount: '\$6.25'),
      ],
      totalLabel: 'Total Due',
      totalAmount: '\$131.25',
    );
  }

  Widget _buildGuaranteeBox() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: AppColors.primary, size: 18.0),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.serviceGuarantee.tr,
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'If the issue recurs, we\'ll fix it for free',
                  style: GoogleFonts.poppins(
                    color: AppColors.greyText,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: AppColors.background,
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: controller.goToPay,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: EdgeInsets.symmetric(vertical: 16.0),
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 0,
          ),
          child: Text(
            AppStrings.goToPay.tr,
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

