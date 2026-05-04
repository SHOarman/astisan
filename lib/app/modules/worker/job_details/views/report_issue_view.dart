import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/report_issue_controller.dart';

class ReportIssueView extends GetView<ReportIssueController> {
  const ReportIssueView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Column(
          children: [
            Text(
              AppStrings.reportAnIssue.tr,
              style: GoogleFonts.poppins(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "Job #J1 Â· Pipe Leak Repair",
              style: GoogleFonts.poppins(
                fontSize: 12.0,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmergencyBanner(),
            const SizedBox(height: 32),
            _buildLabel("${AppStrings.issueType.tr} *"),
            const SizedBox(height: 12),
            _buildDropdown(),
            const SizedBox(height: 32),
            _buildLabel(AppStrings.urgencyLevel.tr),
            const SizedBox(height: 12),
            _buildUrgencySelector(),
            const SizedBox(height: 32),
            _buildLabel("${AppStrings.description.tr} *"),
            const SizedBox(height: 12),
            _buildDescriptionField(),
            const SizedBox(height: 32),
            _buildAttachmentTile(),
            const SizedBox(height: 48),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD166).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFD48806),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF7A5900),
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: "In an emergency, call "),
                  TextSpan(
                    text: "911",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFC0392B),
                    ),
                  ),
                  const TextSpan(
                    text:
                        " immediately. Use this form to report non-emergency job issues.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textColor,
      ),
    );
  }

  Widget _buildDropdown() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedIssueType.value.isEmpty
                ? null
                : controller.selectedIssueType.value,
            hint: Text(
              AppStrings.selectIssueType.tr,
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
            ),
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            items: controller.issueTypes.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: GoogleFonts.poppins(fontSize: 14)),
              );
            }).toList(),
            onChanged: controller.selectIssue,
          ),
        ),
      ),
    );
  }

  Widget _buildUrgencySelector() {
    return Obx(
      () => Row(
        children: [
          _buildUrgencyOption(
            AppStrings.low.tr,
            const Color(0xFF4CAF50),
            controller.urgencyLevel.value == "Low",
          ),
          const SizedBox(width: 12),
          _buildUrgencyOption(
            AppStrings.medium.tr,
            const Color(0xFFFFC107),
            controller.urgencyLevel.value == "Medium",
          ),
          const SizedBox(width: 12),
          _buildUrgencyOption(
            AppStrings.high.tr,
            const Color(0xFFF44336),
            controller.urgencyLevel.value == "High",
          ),
        ],
      ),
    );
  }

  Widget _buildUrgencyOption(String label, Color color, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setUrgency(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withOpacity(0.1)
                : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, color: color, size: 12),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: controller.descriptionController,
            maxLines: 6,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: AppStrings.describeIssueHint.tr,
              hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
              border: InputBorder.none,
              counterText: "",
            ),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Text(
            "${controller.characterCount.value}/500",
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentTile() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          const Icon(Icons.attachment, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            AppStrings.addPhotosDocs.tr,
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: controller.submitReport,
        icon: const Icon(
          Icons.check_circle_outline,
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          AppStrings.submitReport.tr,
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 56.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
