import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/routes/app_routes.dart';
import '../controllers/worker_account_controller.dart';

class WorkerAccountView extends StatelessWidget {
  const WorkerAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered before building
    final controller = Get.isRegistered<WorkerAccountController>()
        ? Get.find<WorkerAccountController>()
        : Get.put(WorkerAccountController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, controller),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 50.0), // Space for the lower skills card
                  _buildBioSection(controller),
                  const SizedBox(height: 24.0),
                  _buildMenuSection(controller),
                  const SizedBox(height: 24.0),
                  _buildServiceAreaSection(controller),
                  const SizedBox(height: 32.0),
                  _buildSignOutButton(controller),
                  const SizedBox(height: 120.0),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildHeader(BuildContext context, WorkerAccountController controller) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            bottom: 130,
          ),
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 32.0),
              _buildProfileInfo(controller),
              const SizedBox(height: 32.0),
              _buildStatsRow(controller),
            ],
          ),
        ),
        Positioned(
          bottom: -40,
          left: 24,
          right: 24,
          child: _buildSkillsCard(controller),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "My Profile",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w700),
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
    );
  }

  Widget _buildProfileInfo(WorkerAccountController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Stack(
            children: [
              Obx(() => Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image: controller.profilePicture.value.isNotEmpty
                        ? (controller.profilePicture.value.startsWith('http')
                            ? NetworkImage(controller.profilePicture.value)
                            : FileImage(File(controller.profilePicture.value))) as ImageProvider
                        : const AssetImage(AppImages.homeMarcusJohnson),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
              Positioned(
                right: -2,
                bottom: -2,
                child: Obx(() => controller.isVerified.value
                    ? Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.verified_rounded, color: AppColors.onlineGreen, size: 18),
                )
                    : const SizedBox.shrink()),
              ),
            ],
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                  controller.userName.value,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w700),
                )),
                Obx(() => controller.userEmail.value.isNotEmpty 
                  ? Text(
                      controller.userEmail.value,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.0),
                    )
                  : const SizedBox.shrink()),
                const SizedBox(height: 6),
                Obx(() => _buildStatusBadge(controller.verificationStatus.value)),
                const SizedBox(height: 8),
                Obx(() => Text(
                  "${controller.experienceYears.value} years experience",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w600),
                )),
                const SizedBox(height: 4),
                Obx(() {
                  String prof = controller.profession.value.trim();
                  if (prof.isEmpty) prof = "Artisan";
                  String rate = controller.serviceRate.value;
                  return Text(
                    "$prof • \$$rate",
                    style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontSize: 13.0),
                  );
                }),
                const SizedBox(height: 4),
                Obx(() => Text(
                  "${controller.locationController.selectedCity.value} • Joined ${controller.joinYear.value}",
                  style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.6), fontSize: 12.0),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    String label;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'verified':
        badgeColor = AppColors.onlineGreen;
        label = "VERIFIED ARTISAN";
        icon = Icons.verified_user_rounded;
        break;
      case 'pending':
        badgeColor = Colors.orange;
        label = "VERIFICATION PENDING";
        icon = Icons.hourglass_top_rounded;
        break;
      default:
        badgeColor = Colors.grey.shade400;
        label = "UNVERIFIED ARTISAN";
        icon = Icons.info_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 9.0, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(WorkerAccountController controller) {
    return Padding(
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
            Obx(() => _buildStatColumn("${controller.jobsDone.value}", "Jobs Done")),
            Obx(() => _buildStatColumn("${controller.rating.value} ★", "Rating")),
            Obx(() => _buildStatColumn("\$${controller.earnings.value}", "Earnings")),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w800)),
        Text(label, style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.5), fontSize: 11.0)),
      ],
    );
  }

  Widget _buildSkillsCard(WorkerAccountController controller) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Skills & Services", style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w700, color: AppColors.textColor)),
          const SizedBox(height: 12.0),
          Obx(() => Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: controller.skills.map((skill) => _buildSkillChip(skill)).toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 12.0, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildBioSection(WorkerAccountController controller) {
    return Obx(() {
      if (controller.bio.value.isEmpty || controller.bio.value == 'No bio available') {
        return const SizedBox.shrink();
      }
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("About Me", style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w700, color: AppColors.textColor)),
            const SizedBox(height: 12.0),
            Text(
              controller.bio.value,
              style: GoogleFonts.poppins(fontSize: 13.0, color: AppColors.greyText, height: 1.5),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMenuSection(WorkerAccountController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          _buildMenuTile(Icons.language, "Language", "English, French", onTap: () => Get.toNamed(Routes.language)),
          _buildMenuTile(Icons.badge_outlined, "Account Verification", "Verified by passport", trailing: _buildVerifiedPill(), onTap: () => Get.toNamed(Routes.WORKER_VERIFICATION)),
          _buildMenuTile(Icons.settings_outlined, "Account Settings", "Payment, availability, zones", onTap: () => Get.toNamed(Routes.WORKER_ACCOUNT_SETTINGS)),
          _buildMenuTile(Icons.security, "Security", "Password secured", onTap: () => Get.toNamed(Routes.SECURITY)),
          _buildMenuTile(Icons.help_outline_rounded, "Help & Support", "Get assistance", showDivider: false, onTap: () => Get.toNamed(Routes.HELP_SUPPORT)),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, String subtitle, {Widget? trailing, bool showDivider = true, VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF4F6F8), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.textColor, size: 20),
          ),
          title: Text(title, style: GoogleFonts.poppins(fontSize: 15.0, fontWeight: FontWeight.w700)),
          subtitle: Text(subtitle, style: GoogleFonts.poppins(fontSize: 12.0, color: AppColors.greyText)),
          trailing: trailing ?? Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
        ),
        if (showDivider) Divider(height: 1, indent: 70, color: Colors.black.withOpacity(0.05)),
      ],
    );
  }

  Widget _buildVerifiedPill() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_rounded, color: Color(0xFF5C86CE), size: 16),
        const SizedBox(width: 4),
        Text("Verified", style: GoogleFonts.poppins(color: const Color(0xFF5C86CE), fontSize: 13.0, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildServiceAreaSection(WorkerAccountController controller) {
    return Obx(() {
      if (controller.serviceAreas.isEmpty) return const SizedBox.shrink();
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24.0), border: Border.all(color: Colors.black.withOpacity(0.05))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Service Area", style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: controller.serviceAreas.map((area) => _buildAreaChip(area)).toList(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAreaChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFFE9F9EE), borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on_rounded, color: AppColors.urgentRed, size: 12),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.poppins(color: const Color(0xFF1B5E20), fontSize: 12.0, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSignOutButton(WorkerAccountController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: controller.signOut,
        icon: const Icon(Icons.logout_rounded),
        label: const Text("Sign Out"),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFEBEE),
          foregroundColor: AppColors.urgentRed,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700),
          elevation: 0,
        ),
      ),
    );
  }
}