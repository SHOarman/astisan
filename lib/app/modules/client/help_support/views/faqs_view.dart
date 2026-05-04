import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../controllers/help_support_controller.dart';

class FaqsView extends GetView<HelpSupportController> {
  const FaqsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'FAQs',
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
                  _buildFaqItem(
                    'What is EQi30?',
                    'EQi30 is a mobile app that helps professionals and leaders build emotional intelligence through 30 trainable abilities â€” with structured daily 5-minute micro-skill practices.',
                  ),
                  _buildDivider(),
                  _buildFaqItem(
                    'Who is EQi30 for?',
                    'It\'s built for working professionals, team leaders, and organizational leaders who want to develop real emotional and leadership skills through consistent daily practice.',
                  ),
                  _buildDivider(),
                  _buildFaqItem(
                    'How much time do I need each day?',
                    'As little as 5 minutes. You choose your own pace â€” 1, 2, or 3 abilities per day depending on your commitment level.',
                  ),
                  _buildDivider(),
                  _buildFaqItem(
                    'Is my journal and reflection data private?',
                    'Yes. Your personal journal entries and reflections are completely private and never shared with anyone, including coaching program administrators.',
                  ),
                  _buildDivider(),
                  _buildFaqItem(
                    'Is EQi30 a replacement for therapy?',
                    'No. EQi30 is a self-development and educational tool. It is not a substitute for professional mental health support or therapy.',
                  ),
                  _buildDivider(),
                  SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: 'ðŸ“§ Any other questions? Reach us at\n',
                        style: GoogleFonts.poppins(
                          color: AppColors.textColor,
                          fontSize: 14.0,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: 'support@eqi30.com',
                            style: GoogleFonts.poppins(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildFaqItem(String question, String answer) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        iconColor: AppColors.textColor,
        collapsedIconColor: AppColors.textColor,
        title: Text(
          question,
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        childrenPadding: EdgeInsets.only(bottom: 16.0),
        children: [
          Text(
            answer,
            style: GoogleFonts.poppins(
              color: AppColors.greyText,
              fontSize: 14.0,
              height: 1.5,
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

