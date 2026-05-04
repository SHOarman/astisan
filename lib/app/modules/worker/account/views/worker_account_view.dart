import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/routes/app_routes.dart';
import '../controllers/worker_account_controller.dart';

class WorkerAccountView extends GetView<WorkerAccountController> {
  const WorkerAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(WorkerAccountController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 24.0),
                  _buildMenuSection(),
                  const SizedBox(height: 24.0),
                  _buildServiceAreaSection(),
                  const SizedBox(height: 32.0),
                  _buildSignOutButton(),
                  const SizedBox(height: 120.0), // Space for bottom nav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Blue Background
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            bottom: 100, // Extra space for overlapping card
          ),
          child: Column(
            children: [
              // Custom Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Profile",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),
              
              // Profile Info Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: const DecorationImage(
                              image: AssetImage(AppImages.homeMarcusJohnson),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                            ),
                            child: const Icon(Icons.verified_rounded, color: AppColors.onlineGreen, size: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Marcus Johnson",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.onlineGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 12),
                                const SizedBox(width: 4),
                                Text(
                                  "VERIFIED ARTISAN",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Certified Plumber • 5+ years",
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13.0,
                            ),
                          ),
                          Text(
                            "New York, NY • Joined 2021",
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32.0),

              // Stats Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn("203", "Jobs Done"),
                      _buildStatColumn("4.9 ★", "Rating"),
                      _buildStatColumn("\$4.2K", "Earnings"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Overlapping Skills Card
        Positioned(
          bottom: -15, // Negative offset to overlap
          left: 24,
          right: 24,
          child: _buildSkillsCard(),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.5),
            fontSize: 11.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Skills & Services",
            style: GoogleFonts.poppins(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 10.0,
            children: controller.skills.map((skill) => _buildSkillChip(skill)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: AppColors.primary,
          fontSize: 13.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          _buildMenuTile(
            Icons.badge_outlined,
            "Account Verification",
            "Verified by passport",
            trailing: _buildVerifiedPill(),
            onTap: () => Get.toNamed(Routes.WORKER_VERIFICATION),
          ),
          _buildMenuTile(
            Icons.star_outline_rounded,
            "My Reviews",
            "203 reviews • 4.9 avg",
            onTap: () => Get.toNamed(Routes.MY_REVIEWS),
          ),
          _buildMenuTile(
            Icons.insights_rounded,
            "Performance",
            "Top 5% in your area",
            onTap: () => Get.toNamed(Routes.PERFORMANCE),
          ),
          _buildMenuTile(
            Icons.settings_outlined,
            "Account Settings",
            "Payment, availability, zones",
            onTap: () => Get.toNamed(Routes.WORKER_ACCOUNT_SETTINGS),
          ),
          _buildMenuTile(
            Icons.security,
            "Security",
            "Password secured",
            onTap: () => Get.toNamed(Routes.SECURITY),

          ),

          _buildMenuTile(
            Icons.help_outline_rounded,
            "Help & Support",
            "Get assistance",
            showDivider: false,
            onTap: () => Get.toNamed(Routes.HELP_SUPPORT),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
      IconData icon,
      String title,
      String subtitle, {
        Widget? trailing,
        bool showDivider = true,
        VoidCallback? onTap, // ১. নতুন প্যারামিটার অ্যাড করা হয়েছে
      }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.textColor.withOpacity(0.7), size: 22),
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 12.0,
              color: AppColors.greyText,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: trailing ?? Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          onTap: onTap, // ২. হার্ডকোডেড রাউট সরিয়ে ডায়নামিক ভেরিয়েবল বসানো হয়েছে
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(height: 1, color: Colors.grey.withOpacity(0.08)),
          ),
      ],
    );
  }

  Widget _buildVerifiedPill() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_rounded, color: Color(0xFF5C86CE), size: 16),
        const SizedBox(width: 4),
        Text(
          "Verified",
          style: GoogleFonts.poppins(
            color: const Color(0xFF5C86CE),
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4),
        Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
      ],
    );
  }

  Widget _buildServiceAreaSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service Area",
            style: GoogleFonts.poppins(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 16.0),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: controller.serviceAreas.map((area) => _buildAreaChip(area)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F9EE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on_rounded, color: AppColors.urgentRed, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: const Color(0xFF1B5E20),
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: controller.signOut,
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text("Sign Out"),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFEBEE),
          foregroundColor: AppColors.urgentRed,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
    );
  }
}