import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/components/custom_text_field.dart';
import '../controllers/worker_add_card_controller.dart';

class WorkerAddCardView extends GetView<WorkerAddCardController> {
  const WorkerAddCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isEditing.value ? "Edit Card" : "Add Card",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        )),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fill your VISA or Master Card details and save the card",
              style: GoogleFonts.poppins(
                fontSize: 14.0,
                color: AppColors.greyText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32.0),
            _buildCardForm(),
            const SizedBox(height: 48.0),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: const Color(0xFFF1F4F8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomTextField(
            labelText: "Cardholder Name",
            hintText: "Marcus Johnson",
            controller: controller.nameController,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            labelText: "Card Number",
            hintText: "4242 4242 4242 4242",
            controller: controller.cardNumberController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  labelText: "Expiry Date",
                  hintText: "12/28",
                  controller: controller.expiryController,
                  keyboardType: TextInputType.datetime,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomTextField(
                  labelText: "CVV",
                  hintText: "***",
                  controller: controller.cvvController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomTextField(
            labelText: "Country/Region",
            hintText: "United States",
            controller: controller.countryController,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Obx(() {
      final isRed = controller.isEditing.value;
      return ElevatedButton(
        onPressed: controller.handleAction,
        style: ElevatedButton.styleFrom(
          backgroundColor: isRed ? AppColors.urgentRed : AppColors.primary,
          minimumSize: const Size(double.infinity, 56.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0,
        ),
        child: Text(
          isRed ? "Delete Card" : "Save Card",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    });
  }
}
