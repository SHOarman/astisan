import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../controllers/help_support_controller.dart';

class TermsOfServiceView extends GetView<HelpSupportController> {
  const TermsOfServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Terms of Service',
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  _buildTermItem(
                    '1. Acceptance of Terms',
                    'By downloading, accessing, or using the EQi30 app, you agree to be bound by these Terms of Service. If you do not agree, please do not use the app.',
                  ),
                  _buildDivider(),
                  _buildTermItem(
                    '2. Eligibility',
                    'You must be 18 years or older to use EQi30. By creating an account, you confirm that you meet this requirement.',
                  ),
                  _buildDivider(),
                  _buildTermItem(
                    '3. Your Account',
                    'â€¢ You are responsible for maintaining the confidentiality of your login credentials.\nâ€¢ You are responsible for all activity that occurs under your account.\nâ€¢ Notify us immediately at [support@eqi30.com] if you suspect unauthorized access.',
                  ),
                  _buildDivider(),
                  _buildTermItem(
                    '4. No Professional Liability',
                    'You agree not to:\nâ€¢ Use the app for any unlawful or harmful purpose.\nâ€¢ Attempt to hack, reverse-engineer, or disrupt the app or its servers.\nâ€¢ Share, copy, or distribute any app content without written permission.\nâ€¢ Impersonate another person or misrepresent your identity.\nâ€¢ Upload any offensive, abusive, or inappropriate content.',
                  ),
                  _buildDivider(),
                  _buildTermItem(
                    '5. Intellectual Property',
                    'All content within EQi30 â€” including the EQ framework, micro-skill content, illustrations, and app design â€” is the intellectual property of EQi30 and its content creators. You may not reproduce, distribute, or use any content outside the app without prior written consent.',
                  ),
                  _buildDivider(),
                  _buildTermItem(
                    '6. Health & Professional Disclaimer',
                    'EQi30 is an educational and self-development tool. It is not a substitute for professional mental health treatment, therapy, or medical advice. If you are experiencing a mental health crisis, please seek help from a qualified professional.',
                  ),
                  _buildDivider(),
                  _buildTermItem(
                    '7. Termination',
                    'We reserve the right to suspend or terminate your account at any time if you violate these Terms. You may delete your account at any time via Profile -> Settings -> Delete Account.',
                  ),
                  _buildDivider(),
                  _buildTermItem(
                    '8. Limitation of Liability',
                    'EQi30 is provided "as is" without warranties of any kind. We are not liable for any indirect, incidental, or consequential damages arising from your use of the app.',
                  ),
                  _buildDivider(),
                  _buildTermItem(
                    '9. Changes to These Terms',
                    'We may update these Terms periodically. Continued use of the app after changes are posted constitutes your acceptance of the revised Terms. Significant changes will be communicated via in-app notification or email.',
                  ),
                  _buildDivider(),
                  _buildTermItem(
                    '10. Contact Us',
                    'For any questions regarding these Terms:\nðŸ“§ privacy@eqi30.com   ðŸŒ www.eqi30.com',
                  ),
                  SizedBox(height: 32.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermItem(String title, String content) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: EdgeInsets.zero,
        iconColor: AppColors.textColor,
        collapsedIconColor: AppColors.textColor,
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        childrenPadding: EdgeInsets.only(bottom: 16.0),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              content,
              style: GoogleFonts.poppins(
                color: AppColors.greyText,
                fontSize: 14.0,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: AppColors.border, height: 1);
  }
}

