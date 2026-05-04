import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/worker_verification_controller.dart';

class WorkerVerificationView extends GetView<WorkerVerificationController> {
  const WorkerVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Obx(() {
          bool isCamera = controller.currentStep.value == 3;
          String title = AppStrings.accountVerification.tr;
          if (controller.currentStep.value >= 4) {
            title = AppStrings.verificationSuccess.tr;
          }

          return AppBar(
            backgroundColor: isCamera
                ? const Color(0xFF0F172A)
                : AppColors.primary,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: AppColors.white, size: 24.0),
              onPressed: () => Get.back(),
            ),
            centerTitle: true,
            title: Text(
              title,
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.currentStep.value == 3) {
                return _buildCameraStep();
              }
              if (controller.currentStep.value == 4) {
                return _buildSuccessStep();
              }
              if (controller.currentStep.value == 5) {
                return _buildFailureStep();
              }
              return PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [_buildStep1(), _buildStep2(), _buildStep3()],
              );
            }),
          ),
          Obx(() {
            if (controller.currentStep.value == 3)
              return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: controller.nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 56.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Continue",
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSuccessStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: const BoxDecoration(
              color: Color(0xFF22C55E),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 100.0),
          ),
          const SizedBox(height: 48.0),
          Text(
            AppStrings.verificationSuccessfullyCompleted.tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailureStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: const BoxDecoration(
              color: Color(0xFFEF4444),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 100.0),
          ),
          const SizedBox(height: 48.0),
          Text(
            AppStrings.verificationFailed.tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            AppStrings.pleaseTryAgainLater.tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Document verification",
            style: GoogleFonts.poppins(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 32.0),
          Text(
            "Select Document type",
            style: GoogleFonts.poppins(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 16.0),
          _docTypeCard(
            title: "ID Card",
            icon: Icons.contact_mail_rounded,
            type: 'ID Card',
          ),
          const SizedBox(height: 16.0),
          _docTypeCard(
            title: "Passport",
            icon: Icons.public_rounded,
            type: 'Passport',
          ),
        ],
      ),
    );
  }

  Widget _docTypeCard({
    required String title,
    required IconData icon,
    required String type,
  }) {
    return Obx(() {
      bool isSelected = controller.selectedDocType.value == type;
      return GestureDetector(
        onTap: () => controller.selectDocType(type),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFF1F4F8)
                : const Color(0xFFF1F4F8).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF63B3ED,
                  ).withOpacity(0.2), // Light blue circle
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF4299E1), size: 24.0),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected ? AppColors.primary : const Color(0xFF9CA3AF),
                size: 24.0,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Document verification",
            style: GoogleFonts.poppins(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            "Please provide your ID Card information",
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 32.0),
          _buildField("Full name", controller.nameController, 'Alex Smith'),
          const SizedBox(height: 24.0),
          _buildField("Date of birth", controller.dobController, 'mm/dd/yy'),
          const SizedBox(height: 24.0),
          _buildField(
            "ID  number",
            controller.idNumberController,
            '45246282554252',
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 12.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
          ),
          child: TextFormField(
            controller: ctrl,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                color: const Color(0xFF9CA3AF),
                fontSize: 14.0,
              ),
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Document verification",
            style: GoogleFonts.poppins(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            "Take both side pictures of your government issued ID card",
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 48.0),
          Center(
            child: Container(
              width: double.infinity,
              height: 240.0,
              decoration: BoxDecoration(
                color: const Color(0xFFB3E5FC), // Mockup light blue
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Placeholder for the illustration since we don't have the asset
                  Container(
                    width: 250,
                    height: 154,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.account_box_rounded,
                          size: 80,
                          color: Color(0xFF4299E1),
                        ),
                        const SizedBox(height: 12.0),
                        Container(
                          width: 100,
                          height: 8,
                          color: const Color(0xFFE2E8F0),
                        ),
                        const SizedBox(height: 4.0),
                        Container(
                          width: 80,
                          height: 8,
                          color: const Color(0xFFE2E8F0),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 12,
                    child: Text(
                      "ID CARD",
                      style: GoogleFonts.poppins(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraStep() {
    return Container(
      color: const Color(0xFF0F172A),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          Container(
            width: 340.0,
            height: 220.0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          const SizedBox(height: 32.0),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
              children: [
                const TextSpan(text: 'Place the '),
                TextSpan(
                  text: 'ID Card',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF4299E1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: ' in the frame'),
              ],
            ),
          ),
          const Spacer(flex: 4),
          GestureDetector(
            onTap: controller.showSuccess, // Direct to success for demo
            child: Container(
              margin: const EdgeInsets.only(bottom: 60.0),
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Center(
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
