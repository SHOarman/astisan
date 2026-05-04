import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/payment_success_controller.dart';

class RatingView extends GetView<PaymentSuccessController> {
  const RatingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.paymentSuccessful.tr,
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: UnconstrainedBox(
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              margin: EdgeInsets.only(left: 16.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.socialButtonBg,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: AppColors.textColor, size: 16.0),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isReviewSubmitted.value) {
          return _buildSuccessState();
        } else {
          return _buildRatingState();
        }
      }),
    );
  }

  Widget _buildRatingState() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'How was your experience?',
                    style: GoogleFonts.poppins(
                      color: AppColors.textColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Your feedback helps improve service quality and\nhelps others choose the right worker.',
                    style: GoogleFonts.poppins(
                      color: AppColors.textColor.withAlpha(200),
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Text(
                    'Rate your experience',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.textColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildStarsRow(),
                  SizedBox(height: 32.0),
                  _buildReviewInput(),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ElevatedButton(
              onPressed: controller.submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: Size(double.infinity, 56.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                elevation: 0,
              ),
              child: Text(
                'Submit Review',
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarsRow() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final isSelected = index < controller.rating.value;
          return GestureDetector(
            onTap: () => controller.rating.value = index + 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: Icon(
                Icons.star_rounded,
                color: isSelected ? AppColors.ratingStar : AppColors.indicatorInactive,
                size: 44.0,
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildReviewInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: TextField(
        controller: controller.reviewController,
        maxLines: 6,
        decoration: InputDecoration(
          hintText: 'Share your experience with the worker...',
          hintStyle: GoogleFonts.poppins(color: AppColors.greyText.withAlpha(200), fontSize: 13.0),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.0),
        ),
        style: GoogleFonts.poppins(color: AppColors.textColor, fontSize: 13.0),
      ),
    );
  }

  Widget _buildSuccessState() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      color: AppColors.statusCompletedText,
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.statusCompletedText.withAlpha(200),
                          AppColors.statusCompletedText,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_rounded,
                        color: AppColors.white,
                        size: 80.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Text(
                    'Thank you for your\nfeedback!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.textColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Your review has been submitted successfully.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.textColor.withAlpha(200),
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: controller.backToHome,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: Size(double.infinity, 56.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                elevation: 0,
              ),
              child: Text(
                AppStrings.backToHome.tr,
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

