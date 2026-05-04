import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/static/app_colors.dart';
import '../../../core/constants/static/app_strings.dart';
import '../controllers/support_controller.dart';
import '../../../core/routes/app_routes.dart';

class HelpSupportView extends GetView<SupportController> {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: UnconstrainedBox(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_back, color: AppColors.textColor, size: 20.0),
              ),
            ),
          ),
        ),
        title: Text(
          AppStrings.helpSupport.tr,
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildMenuItem(
                'Privacy Policy', 
                Icons.security_outlined, 
                () => Get.toNamed(Routes.PRIVACY_POLICY)
              ),
              _buildDivider(),
              _buildMenuItem(
                'Terms of Service', 
                Icons.description_outlined, 
                () => Get.toNamed(Routes.TERMS_OF_SERVICE)
              ),
              _buildDivider(),
              _buildMenuItem(
                'FAQs', 
                Icons.help_outline_rounded, 
                () => Get.toNamed(Routes.FAQS)
              ),
              _buildDivider(),
              _buildMenuItem(
                'Feedback', 
                Icons.chat_bubble_outline_rounded, 
                () => Get.toNamed(Routes.FEEDBACK),
                isLast: true
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap, {bool isLast = false}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: AppColors.textColor,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.greyText, size: 20.0),
      shape: isLast 
          ? const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)))
          : null,
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Divider(color: Color(0xFFF1F4F9), height: 1),
    );
  }
}
