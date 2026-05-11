import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                Obx(
                      () => CustomButton(
                    text: AppStrings.signUp.tr,
                    isLoading: controller.isLoading.value,
                    onPressed: () => controller.signUp(), // Function call update
                  ),
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
          validator: (v) => v == null || v.isEmpty ? 'Enter email' : (v.isEmail ? null : 'Invalid email'),
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
          validator: (v) => v != null && v.length < 6 ? 'Password must be 6+ chars' : null,
        )),
      ],
    );
  }

  Widget _buildServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Service Details"),

        Obx(() => controller.isCategoriesLoading.value
            ? const LinearProgressIndicator()
            : _buildDropdown(
          label: "Select Category",
          value: controller.selectedCategoryId.value.isEmpty ? null : controller.selectedCategoryId.value,
          items: controller.categories.map((c) => DropdownMenuItem<String>(
              value: c['id'].toString(),
              child: Text(c['name'], style: GoogleFonts.poppins(fontSize: 14))
          )).toList(),
          onChanged: controller.onCategoryChanged,
        )
        ),

        const SizedBox(height: 16.0),

        Obx(() => controller.isServicesLoading.value
            ? const LinearProgressIndicator()
            : _buildDropdown(
          label: "Select Service",
          value: controller.selectedServiceId.value.isEmpty ? null : controller.selectedServiceId.value,
          items: controller.services.map((s) => DropdownMenuItem<String>(
              value: s['id'].toString(),
              child: Text(s['name'], style: GoogleFonts.poppins(fontSize: 14))
          )).toList(),
          onChanged: controller.onServiceChanged,
        )
        ),

        const SizedBox(height: 16.0),

        Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              labelText: "Service Rate",
              hintText: "Enter your rate",
              controller: controller.rateController,
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.isEmpty ? 'Enter rate' : null,
            ),
            if (controller.priceMin.value > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                child: Text(
                  "Allowed range: ${controller.priceMin.value} to ${controller.priceMax.value}",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        )),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primary)),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 14, color: AppColors.greyText),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _buildTermsSection() {
    return Row(
      children: [
        Obx(() => Checkbox(
            value: controller.agreeToTerms.value,
            onChanged: (val) => controller.toggleTermsAgreement(val),
            activeColor: AppColors.checkboxActive
        )),
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