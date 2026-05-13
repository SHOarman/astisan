import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/service_details_controller.dart';

class ArtisanProfileView extends GetView<ServiceDetailsController> {
  const ArtisanProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final artisan = controller.artisanData;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Artisan Profile',
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24.0),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: artisan['profile_picture'] != null && artisan['profile_picture'].isNotEmpty
                        ? NetworkImage(artisan['profile_picture'])
                        : const AssetImage('assets/images/placeholder_avatar.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.onlineGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              artisan['full_name'] ?? 'Marcus Johnson',
              style: GoogleFonts.poppins(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
            Text(
              artisan['occupation'] ?? 'Professional Plumber',
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                color: AppColors.greyText,
              ),
            ),
            const SizedBox(height: 24.0),
            _buildStatsRow(artisan),
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('About'),
                  const SizedBox(height: 12.0),
                  Text(
                    'Experienced artisan with a proven track record of providing high-quality services. Specializing in ${artisan['occupation'] ?? 'general maintenance'} with over 5 years of experience.',
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      color: AppColors.greyText,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  _buildSectionTitle('Skills'),
                  const SizedBox(height: 12.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      _buildSkillBadge('Plumbing'),
                      _buildSkillBadge('Repair'),
                      _buildSkillBadge('Installation'),
                      _buildSkillBadge('Maintenance'),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          onPressed: () => controller.bookNow(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Book Now',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(Map<String, dynamic> artisan) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Rating', '${artisan['rating'] ?? '4.9'}', Icons.star_rounded, AppColors.ratingStar),
        _buildStatItem('Jobs', '${artisan['review_count'] ?? '127'}', Icons.work_outline, AppColors.primary),
        _buildStatItem('Rate', '\$${artisan['hourly_rate'] ?? '35'}/hr', Icons.monetization_on_outlined, AppColors.statusCompletedText),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color iconColor) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.greyText,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: AppColors.textColor,
      ),
    );
  }

  Widget _buildSkillBadge(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        skill,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
