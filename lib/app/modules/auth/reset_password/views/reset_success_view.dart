import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/components/custom_button.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/routes/app_routes.dart';

class ResetSuccessView extends StatelessWidget {
  const ResetSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withAlpha(25), // Light blue background
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppImages.successShieldIcon,
                  width: 80.0,
                  height: 80.0,
                  // Fallback in case asset is missing
                  placeholderBuilder: (context) => Icon(
                    Icons.verified_user,
                    size: 80.0,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              Text(
                AppStrings.success.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                AppStrings.successSub.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.greyText,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              CustomButton(
                text: AppStrings.continueBtn.tr,
                onPressed: () {
                  Get.offAllNamed(Routes.LOGIN);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

