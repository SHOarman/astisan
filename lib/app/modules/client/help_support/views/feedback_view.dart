import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../controllers/help_support_controller.dart';

class FeedbackView extends GetView<HelpSupportController> {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Feedback',
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildFeedbackSection(
                      'Subject',
                      'Short title of your issue or suggestion',
                      controller.subjectController,
                    ),
                    SizedBox(height: 16.0),
                    _buildFeedbackSection(
                      'Email Address',
                      'Write your email',
                      controller.emailController,
                    ),
                    SizedBox(height: 16.0),
                    _buildMessageSection(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ElevatedButton(
                onPressed: controller.submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3044), // Very dark teal/blue from mockup
                  minimumSize: Size(double.infinity, 56.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  elevation: 0,
                ),
                child: Text(
                  'Submit',
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackSection(String title, String hint, TextEditingController ctr) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(15), // Light blue-grey background
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.0),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AppColors.primary.withAlpha(50)),
            ),
            child: TextField(
              controller: ctr,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.poppins(color: AppColors.greyText.withAlpha(150), fontSize: 14.0),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              style: GoogleFonts.poppins(color: AppColors.textColor, fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(15),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Massage', // Using verbatim spelling from image
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.0),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AppColors.primary.withAlpha(50)),
            ),
            child: Stack(
              children: [
                TextField(
                  controller: controller.messageController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: 'Please explain what happend...', // Using verbatim spelling
                    hintStyle: GoogleFonts.poppins(color: AppColors.greyText.withAlpha(150), fontSize: 14.0),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 60.0),
                  ),
                  style: GoogleFonts.poppins(color: AppColors.textColor, fontSize: 14.0),
                ),
                Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: AppColors.primary.withAlpha(80)),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, color: AppColors.textColor, size: 24.0),
                      onPressed: () {
                        // Action for adding attachment
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

