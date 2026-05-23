import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/components/custom_button.dart';
import '../../core/constants/static/app_colors.dart';
import '../../core/constants/static/app_strings.dart';
import 'auth_controller_worker/auth_worker_controller.dart';

class SerivesDetels extends GetView<AuthWorkerController> {
  const SerivesDetels({super.key});

  @override
  Widget build(BuildContext context) {
    // Initial data fetch
    if (controller.categories.isEmpty) controller.fetchCategories();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.completeServiceProfile.tr, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.selectServiceProvide.tr,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.greyText),
            ),
            const SizedBox(height: 32.0),

            // Category Dropdown
            Text(AppStrings.serviceCategory.tr, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Obx(() => controller.isCategoriesLoading.value
                ? const Center(child: CircularProgressIndicator())
                : _buildDropdown(
              hint: AppStrings.selectCategoryHint.tr,
              value: controller.selectedCategoryId.value.isEmpty ? null : controller.selectedCategoryId.value,
              items: controller.categories.map((c) => DropdownMenuItem<String>(
                  value: c['id'].toString(),
                  child: Text(c['name'])
              )).toList(),
              onChanged: controller.onCategoryChanged,
            )),

            const SizedBox(height: 24.0),

            // Service Dropdown
            Text(AppStrings.specificService.tr, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Obx(() => controller.isServicesLoading.value
                ? const LinearProgressIndicator()
                : _buildDropdown(
              hint: AppStrings.selectServiceHint.tr,
              value: controller.selectedServiceId.value.isEmpty ? null : controller.selectedServiceId.value,
              items: controller.services.map((s) => DropdownMenuItem<String>(
                  value: s['id'].toString(),
                  child: Text(s['name'])
              )).toList(),
              onChanged: controller.onServiceChanged,
            )),

            const SizedBox(height: 24.0),

            // Rate Input
            Text(AppStrings.yourHourlyRate.tr, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.rateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: "\$ ",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            Obx(() => controller.priceMin.value > 0
                ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text("${AppStrings.recommendedRange.tr} ${controller.priceMin.value} - ${controller.priceMax.value}",
                  style: TextStyle(color: AppColors.primary, fontSize: 12)),
            )
                : const SizedBox()),

            const SizedBox(height: 40.0),

            Obx(() => CustomButton(
              text: AppStrings.saveAndGoDashboard.tr,
              isLoading: controller.isLoading.value,
              onPressed: () => controller.saveServiceDetails(),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({required String hint, required String? value, required List<DropdownMenuItem<String>> items, required ValueChanged<String?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}