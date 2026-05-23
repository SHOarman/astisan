import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/add_card_controller.dart';

class AddCardView extends GetView<AddCardController> {
  const AddCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppStrings.addCard.tr,
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
                  Text(
                    AppStrings.fillCardDetails.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  _buildCardForm(),
                ],
              ),
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: const Color(0xFFF1F4F8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller.nameController,
            AppStrings.cardholderName.tr,
            label: AppStrings.cardholderName.tr,
          ),
          const SizedBox(height: 20.0),
          _buildTextField(
            controller.cardNumberController,
            AppStrings.cardNo.tr,
            label: AppStrings.cardNumber.tr,
            icon: Icons.credit_card,
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller.expiryController,
                  AppStrings.expiry.tr,
                  label: AppStrings.expiryDate.tr,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: _buildTextField(
                  controller.cvvController,
                  AppStrings.cvv.tr,
                  label: AppStrings.cvvLabel.tr,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          _buildTextField(
            controller.addressController,
            AppStrings.branchName.tr,
            label: AppStrings.address.tr,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctr,
    String hint, {
    String? label,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF1F4F8),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: ctr,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                color: AppColors.greyText,
                fontSize: 13,
              ),
              prefixIcon: icon != null
                  ? Icon(icon, color: AppColors.greyText, size: 20)
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 14.0,
              ),
            ),
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
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
        child: ElevatedButton(
          onPressed: controller.saveCard,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 56.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 0,
          ),
          child: Text(
            AppStrings.saveCard.tr,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
