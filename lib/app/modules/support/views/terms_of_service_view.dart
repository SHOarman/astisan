import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/static/app_colors.dart';
import '../../../core/constants/static/app_strings.dart';
import '../controllers/support_controller.dart';

class TermsOfServiceView extends GetView<SupportController> {
  const TermsOfServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SupportController>()) {
      Get.put(SupportController());
    }

    final terms = [
      {'title': '1. Acceptance of Terms', 'content': AppStrings.tosContent1},
      {'title': '2. Eligibility', 'content': AppStrings.tosContent2},
      {'title': '3. Your Account', 'content': AppStrings.tosContent3},
      {'title': '4. Acceptable Use', 'content': AppStrings.tosContent4},
      {'title': '5. Artisan Responsibilities', 'content': AppStrings.tosContent5},
      {'title': '6. Bookings, Payments & Cancellations', 'content': AppStrings.tosContent6},
      {'title': '7. Platform Disclaimer', 'content': AppStrings.tosContent7},
      {'title': '8. Intellectual Property', 'content': 'All platform content â€” including design, branding, features, and technology â€” is the exclusive intellectual property of the platform owner. Reproduction, distribution, or commercial use of any content without prior written consent is strictly prohibited.'},
      {'title': '9. Account Termination', 'content': 'By us: We reserve the right to suspend or permanently terminate any account that violates these Terms, without prior notice.\nBy you: You may delete your account at any time via Profile -> Settings -> Delete Account. All personal data will be permanently removed within 30 days of deletion.'},
      {'title': '10. Limitation of Liability', 'content': 'This platform is provided "as is" without warranties of any kind. To the fullest extent permitted by law, we are not liable for any indirect, incidental, or consequential damages arising from the use of the platform.'},
      {'title': '11. Changes to These Terms', 'content': 'We may update these Terms periodically. Any significant changes will be communicated via in-app notification or email. Continued use of the platform after updates constitutes acceptance of the revised Terms.'},
      {'title': '12. Contact us', 'content': AppStrings.tosContent12},
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
          'Terms of Service',
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: terms.length,
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
                terms[index]['title']!,
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
                      terms[index]['content']!.tr,
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
