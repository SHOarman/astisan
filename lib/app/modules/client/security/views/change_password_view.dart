import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/security_controller.dart';

class ChangePasswordView extends GetView<SecurityController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24.0),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.changePassword.tr,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Obx(() => _buildPasswordField(
                  label: AppStrings.currentPass.tr,
                  controller: controller.currentPassController,
                  isVisible: controller.isCurrentPassVisible.value,
                  onToggle: controller.toggleCurrentPassVisibility,
                )),
            const SizedBox(height: 32.0),
            Obx(() => _buildPasswordField(
                  label: AppStrings.newPassword.tr,
                  controller: controller.newPasswordController,
                  isVisible: controller.isNewPassVisible.value,
                  onToggle: controller.toggleNewPassVisibility,
                )),
            const SizedBox(height: 32.0),
            Obx(() => _buildPasswordField(
                  label: AppStrings.confirmPasswordAlt.tr,
                  controller: controller.confirmPasswordController,
                  isVisible: controller.isConfirmPassVisible.value,
                  onToggle: controller.toggleConfirmPassVisibility,
                )),
            const SizedBox(height: 60.0),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: GoogleFonts.poppins(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: 14.0,
            color: AppColors.textColor.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
          hintText: "Ã¢â‚¬Â¢Ã¢â‚¬Â¢Ã¢â‚¬Â¢Ã¢â‚¬Â¢Ã¢â‚¬Â¢Ã¢â‚¬Â¢Ã¢â‚¬Â¢Ã¢â‚¬Â¢",
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xFF9CA3AF),
            letterSpacing: 2.0,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: const Color(0xFF9CA3AF),
              size: 22,
            ),
            onPressed: onToggle,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: controller.savePassword,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A7CBD), // Matching the image's lighter blue
        minimumSize: const Size(double.infinity, 56.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0,
      ),
      child: Text(
        AppStrings.save.tr,
        style: GoogleFonts.poppins(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
