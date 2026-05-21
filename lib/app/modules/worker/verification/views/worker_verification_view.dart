import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

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
            "Take a clear picture of your government issued ID card",
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 48.0),
          Center(
            child: GestureDetector(
              onTap: () => controller.pickImage(ImageSource.camera),
              child: Obx(() {
                if (controller.pickedImage.value != null) {
                  return Container(
                    width: double.infinity,
                    height: 240.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      image: DecorationImage(
                        image: FileImage(controller.pickedImage.value!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
                return Container(
                  width: double.infinity,
                  height: 240.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB3E5FC),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Icon(Icons.camera_alt_rounded, size: 80, color: Colors.white),
                );
              }),
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
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              Obx(() {
                if (controller.pickedImage.value != null) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24.0),
                    height: 220.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.black45,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.file(
                        controller.pickedImage.value!,
                        fit: BoxFit.contain, // Perfectly fits any image size
                      ),
                    ),
                  );
                }
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  height: 220.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                );
              }),
              const SizedBox(height: 32.0),
              Text(
                "Confirm Document Photo",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Spacer(flex: 4),
              Obx(() {
                return GestureDetector(
                  onTap: controller.isLoading.value ? null : controller.submitVerification,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 60.0),
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Center(
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check, color: AppColors.primary, size: 40),
                            ),
                    ),
                  ),
                );
              }),
            ],
          ),
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: controller.previousStep,
            ),
          )
        ],
      ),
    );
  }
}
