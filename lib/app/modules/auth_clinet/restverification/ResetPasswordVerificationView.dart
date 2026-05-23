import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_otp_input.dart';
import '../../../core/constants/static/app_colors.dart';


import '../../../core/constants/static/app_strings.dart';
import 'controller/ResetPasswordVerificationController.dart';


class ResetPasswordVerificationView extends GetView<ResetPasswordVerificationController> {
  const ResetPasswordVerificationView({super.key});

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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 40.0),
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
        const SizedBox(height: 8.0),
        Obx(() => Text(
          "${AppStrings.weSendCodeTo.tr} ${controller.email.value}",
          style: GoogleFonts.poppins(
            color: AppColors.greyText,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        )),
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
        const SizedBox(height: 32.0),
        Obx(() {
          int minutes = controller.timerSeconds.value ~/ 60;
          int seconds = controller.timerSeconds.value % 60;
          String timeFormatted = "$minutes:${seconds.toString().padLeft(2, '0')}";

          return Column(
            children: [
              Text(
                AppStrings.dontReceiveCode.tr,
                style: GoogleFonts.poppins(
                  color: AppColors.textColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4.0),
              GestureDetector(
                onTap: (controller.timerSeconds.value == 0 && !controller.isLoading.value)
                    ? controller.resendCode
                    : null,
                child: Text(
                  controller.timerSeconds.value > 0
                      ? '${AppStrings.resendIn.tr} $timeFormatted'
                      : AppStrings.resendCode.tr,
                  style: GoogleFonts.poppins(
                    color: (controller.timerSeconds.value > 0 || controller.isLoading.value)
                        ? AppColors.greyText
                        : AppColors.errorText,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 40.0),
        Obx(() => CustomButton(
          text: AppStrings.verify.tr,
          isLoading: controller.isLoading.value,
          onPressed: controller.verify,
        )),
      ],
    );
  }
}