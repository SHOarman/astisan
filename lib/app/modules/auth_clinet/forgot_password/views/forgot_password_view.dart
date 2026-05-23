import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/components/custom_button.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

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
              _buildForm(),
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
          AppStrings.forgotPasswordTitle.tr,
          style: GoogleFonts.poppins(
            color: AppColors.primary,
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          AppStrings.forgotPasswordSub.tr,
          style: GoogleFonts.poppins(
            color: AppColors.greyText,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          CustomTextField(
            labelText: AppStrings.email.tr,
            hintText: 'example@gmail.com',
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.pleaseEnterEmail.tr;
              }
              if (!GetUtils.isEmail(value)) {
                return AppStrings.enterValidEmailError.tr;
              }
              return null;
            },
          ),
          const SizedBox(height: 32.0),
          Obx(() => CustomButton(
            text: AppStrings.sendCode.tr,
            isLoading: controller.isLoading.value,
            onPressed: controller.sendCode,
          )),
        ],
      ),
    );
  }
}