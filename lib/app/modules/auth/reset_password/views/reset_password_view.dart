import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/components/custom_button.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

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
              _buildResetForm(),
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
          AppStrings.createNewPassword.tr,
          style: GoogleFonts.poppins(
            color: AppColors.primary,
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          AppStrings.createNewPasswordSub.tr,
          style: GoogleFonts.poppins(
            color: AppColors.greyText,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildResetForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          Obx(() => CustomTextField(
            labelText: AppStrings.newPassword.tr,
            hintText: 'â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢',
            controller: controller.newPasswordController,
            obscureText: controller.obscureNewPassword.value,
            suffixIcon: IconButton(
              icon: SvgPicture.asset(
                controller.obscureNewPassword.value ? AppImages.eyeHideIcon : AppImages.eyeShowIcon,
                width: 24.0,
                height: 24.0,
                colorFilter: const ColorFilter.mode(AppColors.greyText, BlendMode.srcIn),
              ),
              onPressed: controller.toggleNewPasswordVisibility,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a new password';
              }
              if (value.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
          )),
          SizedBox(height: 16.0),
          Obx(() => CustomTextField(
            labelText: AppStrings.confirmPassword.tr,
            hintText: 'â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢',
            controller: controller.confirmPasswordController,
            obscureText: controller.obscureConfirmPassword.value,
            suffixIcon: IconButton(
              icon: SvgPicture.asset(
                controller.obscureConfirmPassword.value ? AppImages.eyeHideIcon : AppImages.eyeShowIcon,
                width: 24.0,
                height: 24.0,
                colorFilter: const ColorFilter.mode(AppColors.greyText, BlendMode.srcIn),
              ),
              onPressed: controller.toggleConfirmPasswordVisibility,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != controller.newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          )),
          SizedBox(height: 32.0),
          CustomButton(
            text: AppStrings.changePassword.tr,
            onPressed: controller.submit,
          ),
        ],
      ),
    );
  }
}

