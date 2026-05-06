import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/components/custom_button.dart';
import '../../core/components/custom_text_field.dart';
import '../../core/constants/static/app_colors.dart';
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
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 30.0),
                _buildPersonalSection(),
                const SizedBox(height: 30.0),
                _buildServiceSection(),
                const SizedBox(height: 24.0),
                _buildTermsSection(),
                const SizedBox(height: 24.0),
                CustomButton(
                  text: AppStrings.signUp.tr,
                  onPressed: controller.signUp,
                ),
                const SizedBox(height: 40.0),
                _buildLoginPrompt(),
              ],
            ),
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
          style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 28.0, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8.0),
        Text(
          "Join as a worker and provide services",
          style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 14.0, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildPersonalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Personal Information"),
        CustomTextField(
          labelText: AppStrings.fullName.tr,
          hintText: 'Your Name',
          controller: controller.nameController,
          validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
        ),
        const SizedBox(height: 16.0),
        CustomTextField(
          labelText: AppStrings.email.tr,
          hintText: 'example@mail.com',
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (v) => v == null || v.isEmpty ? 'Enter email' : null,
        ),
        const SizedBox(height: 16.0),
        CustomTextField(
          labelText: AppStrings.number.tr,
          hintText: '+1 (500) 000-0000',
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          validator: (v) => v == null || v.isEmpty ? 'Enter phone' : null,
        ),
        const SizedBox(height: 16.0),
        Obx(() => CustomTextField(
          labelText: AppStrings.password.tr,
          hintText: '***********',
          controller: controller.passwordController,
          obscureText: controller.obscurePassword.value,
          suffixIcon: IconButton(
            icon: Icon(controller.obscurePassword.value ? Icons.visibility_off : Icons.visibility, color: AppColors.greyText),
            onPressed: controller.togglePasswordVisibility,
          ),
          validator: (v) => v == null || v.isEmpty ? 'Enter password' : null,
        )),
        const SizedBox(height: 16.0),
        Obx(() => CustomTextField(
          labelText: AppStrings.confirmPassword.tr,
          hintText: '***********',
          controller: controller.confirmPasswordController,
          obscureText: controller.obscureConfirmPassword.value,
          suffixIcon: IconButton(
            icon: Icon(controller.obscureConfirmPassword.value ? Icons.visibility_off : Icons.visibility, color: AppColors.greyText),
            onPressed: controller.toggleConfirmPasswordVisibility,
          ),
          validator: (v) => v != controller.passwordController.text ? 'Not match' : null,
        )),
      ],
    );
  }

  Widget _buildServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Service Details"),
        Obx(() => _buildDropdown(
          label: "Select Category",
          value: controller.selectedCategory.value.isEmpty ? null : controller.selectedCategory.value,
          items: controller.categoryData.keys.toList(),
          onChanged: (val) {
            controller.selectedCategory.value = val!;
            controller.selectedService.value = '';
          },
        )),
        const SizedBox(height: 16.0),
        Obx(() => _buildDropdown(
          label: "Select Service",
          value: controller.selectedService.value.isEmpty ? null : controller.selectedService.value,
          items: controller.selectedCategory.value.isNotEmpty ? controller.categoryData[controller.selectedCategory.value]! : [],
          onChanged: (val) => controller.selectedService.value = val!,
        )),
        const SizedBox(height: 16.0),
        CustomTextField(
          labelText: "Service Rate",
          hintText: "\$40",
          controller: controller.rateController,
          validator: (v) => v == null || v.isEmpty ? 'Enter rate' : null,
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primary)),
    );
  }

  Widget _buildDropdown({required String label, required String? value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 14, color: AppColors.greyText),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.poppins(fontSize: 14)))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTermsSection() {
    return Row(
      children: [
        Obx(() => Checkbox(value: controller.agreeToTerms.value, onChanged: controller.toggleTermsAgreement, activeColor: AppColors.checkboxActive)),
        Expanded(child: Text("Agree with terms and privacy", style: GoogleFonts.poppins(fontSize: 14))),
      ],
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: '${AppStrings.alreadyHaveAccount.tr} ',
          style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 14.0),
          children: [
            TextSpan(
              text: AppStrings.signIn.tr,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              recognizer: TapGestureRecognizer()..onTap = controller.navigateToLogin,
            ),
          ],
        ),
      ),
    );
  }
}