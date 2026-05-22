import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppStrings.editProfile.tr,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: _buildAvatarSection()),
                  const SizedBox(height: 40.0),
                  _buildForm(),
                ],
              ),
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Obx(() => Stack(
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFF1F4F8),
            image: controller.profileImage.value != null
                ? DecorationImage(
                    image: FileImage(controller.profileImage.value!),
                    fit: BoxFit.cover,
                  )
                : (controller.profileImageUrl.value.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(controller.profileImageUrl.value),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage(AppImages.homeMarcusJohnson),
                        fit: BoxFit.cover,
                      )),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: controller.pickImage,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE0E0E0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: AppColors.greyText,
                size: 18.0,
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildForm() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabeledField(AppStrings.fullName.tr, controller.fullNameController),
        const SizedBox(height: 24.0),
        _buildLabeledField(AppStrings.email.tr, controller.emailController, readOnly: true),
        const SizedBox(height: 24.0),
        _buildLabeledField(AppStrings.number.tr, controller.phoneController),
        
        if (controller.isWorker.value) ...[
          const SizedBox(height: 24.0),
          _buildLabeledField(AppStrings.occupation.tr, controller.occupationController),
          const SizedBox(height: 24.0),
          _buildLabeledField(AppStrings.bio.tr, controller.bioController, maxLines: 3),
          const SizedBox(height: 24.0),
          _buildLabeledField(AppStrings.experienceYears.tr, controller.experienceController, keyboardType: TextInputType.number),
          const SizedBox(height: 24.0),
          _buildLabeledField(AppStrings.rate.tr, controller.rateController, keyboardType: TextInputType.number),
          const SizedBox(height: 24.0),
          _buildLabeledField(AppStrings.skillsList.tr, controller.skillsController),
          const SizedBox(height: 24.0),
          _buildLabeledField(AppStrings.serviceAreasList.tr, controller.areasController),
        ],
      ],
    ));
  }

  Widget _buildLabeledField(String label, TextEditingController ctr, {bool readOnly = false, int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: readOnly ? const Color(0xFFE5E7EB) : const Color(0xFFF1F4F8),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: ctr,
            readOnly: readOnly,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 16.0),
            ),
            style: GoogleFonts.poppins(
              color: AppColors.greyText,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Obx(() => ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.saveChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 56.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.0,
                  ),
                )
              : Text(
                  AppStrings.saveChanges.tr,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        )),
      ),
    );
  }
}
