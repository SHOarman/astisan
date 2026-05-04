import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../controllers/help_support_controller.dart';

class HelpSupportView extends GetView<HelpSupportController> {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // F9F9F9/White
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: UnconstrainedBox(
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              margin: EdgeInsets.only(left: 16.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.socialButtonBg,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: AppColors.textColor, size: 16.0),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMenuItem('Privacy Policy', controller.goToPrivacyPolicy),
                _buildDivider(),
                _buildMenuItem('Terms of Service', controller.goToTermsOfService),
                _buildDivider(),
                _buildMenuItem('FAQs', controller.goToFaqs),
                _buildDivider(),
                _buildMenuItem('Feedback', controller.goToFeedback, isLast: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, VoidCallback onTap, {bool isLast = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isLast ? Radius.zero : Radius.circular(16.0),
        bottom: isLast ? Radius.circular(16.0) : Radius.zero,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                color: AppColors.textColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.greyText, size: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Divider(color: AppColors.border, height: 1),
    );
  }
}

