import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/components/custom_button.dart';
import '../../core/components/custom_social_button.dart';
import '../../core/components/custom_text_field.dart';
import '../../core/constants/static/app_colors.dart';
import '../../core/constants/static/app_images.dart';
import '../../core/constants/static/app_strings.dart';
import 'auth_controller_worker/auth_worker_controller.dart';



class SingUp extends GetView<AuthWorkerController> {
  const SingUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 40.0),
              _buildSignUpForm(),
              const SizedBox(height: 32.0),
              _buildOrDivider(),
              const SizedBox(height: 24.0),
              _buildSocialLogins(),
              const SizedBox(height: 40.0),
              _buildLoginPrompt(),
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
          AppStrings.registerAccount.tr,
          style: GoogleFonts.poppins(
            color: AppColors.primary,
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          AppStrings.signInSub.tr,
          style: GoogleFonts.poppins(
            color: AppColors.greyText,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          CustomTextField(
            labelText: AppStrings.fullName.tr,
            hintText: 'Your Name',
            controller: controller.nameController,
            validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
          ),
          const SizedBox(height: 16.0),
          CustomTextField(
            labelText: AppStrings.email.tr,
            hintText: 'example@mail.com',
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value == null || value.isEmpty ? 'Please enter your email' : null,
          ),
          const SizedBox(height: 16.0),
          CustomTextField(
            labelText: AppStrings.number.tr,
            hintText: '+1 (500) 000-0000',
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) => value == null || value.isEmpty ? 'Please enter your phone number' : null,
          ),
          const SizedBox(height: 16.0),
          Obx(() => CustomTextField(
            labelText: AppStrings.password.tr,
            hintText: '***********',
            controller: controller.passwordController,
            obscureText: controller.obscurePassword.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.obscurePassword.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.greyText,
                size: 24.0,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
            validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
          )),
          const SizedBox(height: 16.0),
          Obx(() => CustomTextField(
            labelText: AppStrings.confirmPassword.tr,
            hintText: '***********',
            controller: controller.confirmPasswordController,
            obscureText: controller.obscureConfirmPassword.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.obscureConfirmPassword.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.greyText,
                size: 24.0,
              ),
              onPressed: controller.toggleConfirmPasswordVisibility,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please confirm your password';
              if (value != controller.passwordController.text) return 'Passwords do not match';
              return null;
            },
          )),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Obx(() => Checkbox(
                value: controller.agreeToTerms.value,
                onChanged: controller.toggleTermsAgreement,
                activeColor: AppColors.checkboxActive,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                side: const BorderSide(color: AppColors.border),
              )),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'Agree with ',
                    style: GoogleFonts.poppins(
                      color: AppColors.textColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: 'terms',
                        style: GoogleFonts.poppins(
                          color: AppColors.textColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: GoogleFonts.poppins(
                          color: AppColors.textColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'privacy',
                        style: GoogleFonts.poppins(
                          color: AppColors.textColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          CustomButton(
            text: AppStrings.signUp.tr,
            onPressed: controller.signUp,
          ),
        ],
      ),
    );
  }

  Widget _buildOrDivider() {
    return Center(
      child: Text(
        AppStrings.or.tr,
        style: GoogleFonts.poppins(
          color: AppColors.primary,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSocialLogins() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomSocialButton(
          iconPath: AppImages.googleIcon,
          onPressed: () => controller.onSocialLogin('Google'),
        ),
        const SizedBox(width: 20.0),
        CustomSocialButton(
          iconPath: AppImages.appleIcon,
          onPressed: () => controller.onSocialLogin('Apple'),
        ),
      ],
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: '${AppStrings.alreadyHaveAccount.tr} ',
          style: GoogleFonts.poppins(
            color: AppColors.primary,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text: AppStrings.signIn.tr,
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
              recognizer: TapGestureRecognizer()..onTap = controller.navigateToLogin,
            ),
          ],
        ),
      ),
    );
  }
}