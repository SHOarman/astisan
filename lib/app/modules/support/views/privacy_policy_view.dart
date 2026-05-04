import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/static/app_colors.dart';
import '../../../core/constants/static/app_strings.dart';
import '../controllers/support_controller.dart';

class PrivacyPolicyView extends GetView<SupportController> {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SupportController>()) {
      Get.put(SupportController());
    }

    final policies = [
      {'title': '1. Information We Collect', 'content': AppStrings.privacyContent1},
      {'title': '2. How We Use Your Information', 'content': AppStrings.privacyContent2},
      {'title': '3. How We Share Your Information', 'content': AppStrings.privacyContent3},
      {'title': '4. Location Data', 'content': AppStrings.privacyContent4},
      {'title': '5. Data Storage & Security', 'content': AppStrings.privacyContent5},
      {'title': '6. Your Rights', 'content': AppStrings.privacyContent6},
      {'title': '7. Changes to This Policy', 'content': AppStrings.privacyContent7},
      {'title': '8. Contact Us', 'content': AppStrings.privacyContent8},
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
          'Privacy Policy',
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: policies.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: index == 0,
              tilePadding: EdgeInsets.zero,
              iconColor: AppColors.textColor,
              collapsedIconColor: AppColors.textColor,
              title: Text(
                policies[index]['title']!,
                style: GoogleFonts.poppins(
                  color: AppColors.textColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      policies[index]['content']!.tr,
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 14.0,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
