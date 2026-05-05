import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/components/custom_button.dart';
import '../../../../core/components/custom_otp_input.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/verification_controller.dart';

class VerificationView extends GetView<VerificationController> {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 40.0),
              _buildOtpForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.verifyYourEmail.tr,
          style: GoogleFonts.poppins(
            color: AppColors.primary,
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          AppStrings.weSendCodeTo.tr,
          style: GoogleFonts.poppins(
            color: AppColors.greyText,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpForm() {
    return Column(
      children: [
        CustomOtpInput(
          length: 6,
          onCompleted: (v) {
            controller.otpCode.value = v;
          },
          onChanged: (v) {
            controller.otpCode.value = v;
          },
        ),
        SizedBox(height: 32.0),
        Obx(() => Column(
          children: [
            Text(
              AppStrings.dontReceiveCode.tr,
              style: GoogleFonts.poppins(
                color: AppColors.textColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4.0),
            GestureDetector(
              onTap: controller.timerSeconds.value == 0 ? controller.resendCode : null,
              child: Text(
                controller.timerSeconds.value > 0 
                  ? 'Resend in 0:${controller.timerSeconds.value.toString().padLeft(2, '0')}s'
                  : AppStrings.resendCode.tr,
                style: GoogleFonts.poppins(
                  color: controller.timerSeconds.value > 0 ? AppColors.greyText : AppColors.errorText,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        )),
        SizedBox(height: 40.0),
        CustomButton(
          text: AppStrings.verify.tr,
          onPressed: controller.verify,
        ),
      ],
    );
  }
}

