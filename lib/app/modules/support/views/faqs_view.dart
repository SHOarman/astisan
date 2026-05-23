import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/static/app_colors.dart';
import '../../../core/constants/static/app_strings.dart';
import '../controllers/support_controller.dart';

class FaqsView extends GetView<SupportController> {
  const FaqsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is available if navigated directly
    if (!Get.isRegistered<SupportController>()) {
      Get.put(SupportController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'FAQs'.tr,
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingFaqs.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.faqsList.isEmpty) {
          return Center(child: Text(AppStrings.noFaqsAvailable.tr));
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          itemCount: controller.faqsList.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey.withOpacity(0.1), height: 1),
          itemBuilder: (context, index) {
            final faq = controller.faqsList[index];
            final isExpanded = controller.expandedIndex.value == index;
            return Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                onExpansionChanged: (expanded) => controller.toggleFAQ(index),
                tilePadding: EdgeInsets.zero,
                iconColor: AppColors.textColor,
                collapsedIconColor: AppColors.textColor,
                title: Text(
                  faq['question'] ?? '',
                  style: GoogleFonts.poppins(
                    color: AppColors.textColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      faq['answer'] ?? '',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 14.0,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
