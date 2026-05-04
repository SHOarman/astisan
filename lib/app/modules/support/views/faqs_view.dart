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

    final faqs = [
      {'q': AppStrings.faqQ1, 'a': AppStrings.faqA1},
      {'q': AppStrings.faqQ2, 'a': AppStrings.faqA2},
      {'q': AppStrings.faqQ3, 'a': AppStrings.faqA3},
      {'q': AppStrings.faqQ4, 'a': AppStrings.faqA4},
      {'q': AppStrings.faqQ5, 'a': AppStrings.faqA5},
    ];

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
          'FAQs',
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        itemCount: faqs.length,
        separatorBuilder: (context, index) => Divider(color: Colors.grey.withOpacity(0.1), height: 1),
        itemBuilder: (context, index) {
          return Obx(() {
            final isExpanded = controller.expandedIndex.value == index;
            return Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                onExpansionChanged: (expanded) => controller.toggleFAQ(index),
                tilePadding: EdgeInsets.zero,
                iconColor: AppColors.textColor,
                collapsedIconColor: AppColors.textColor,
                title: Text(
                  faqs[index]['q']!.tr,
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
                      faqs[index]['a']!.tr,
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
          });
        },
      ),
    );
  }
}
