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
                  Obx(() => CircleAvatar(
                    radius: 60.0,
                    backgroundImage: (controller.artisanData['avatar'] != null && controller.artisanData['avatar'].toString().isNotEmpty)
                        ? NetworkImage(controller.artisanData['avatar'])
                        : (controller.artisanData['profile_picture'] != null && controller.artisanData['profile_picture'].toString().isNotEmpty)
                        ? NetworkImage(controller.artisanData['profile_picture'])
                        : const AssetImage('assets/images/placeholder_avatar.png') as ImageProvider,
                  )),
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
            Obx(() => Text(
              controller.artisanData['name'] ?? controller.artisanData['full_name'] ?? 'Artisan Name',
              style: GoogleFonts.poppins(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            )),
            Obx(() => Text(
              controller.artisanData['role'] ?? controller.artisanData['occupation'] ?? 'Professional',
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                color: AppColors.greyText,
              ),
            )),
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
                  Obx(() => Text(
                    controller.artisanData['bio']?.toString().isNotEmpty == true
                        ? controller.artisanData['bio']
                        : 'Experienced artisan with a proven track record of providing high-quality services. Specializing in ${controller.artisanData['role'] ?? controller.artisanData['occupation'] ?? 'general maintenance'}.',
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      color: AppColors.greyText,
                      height: 1.6,
                    ),
                  )),
                  const SizedBox(height: 24.0),
                  _buildSectionTitle('Skills'),
                  const SizedBox(height: 12.0),
                  Obx(() => Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _buildSkillsList(controller.artisanData),
                  )),
                  const SizedBox(height: 24.0),
                  _buildSectionTitle('Service Areas'),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Obx(() => Text(
                          controller.artisanData['distance'] ?? controller.artisanData['distanceOrTime'] ?? 'Nearby',
                          style: GoogleFonts.poppins(fontSize: 14.0, color: AppColors.greyText),
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  _buildReviewsSection(context),
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
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Rating', '${controller.artisanData['rating'] ?? '0.0'}', Icons.star_rounded, AppColors.ratingStar),
        _buildStatItem('Jobs', '${controller.artisanData['jobsDone'] ?? controller.artisanData['review_count'] ?? '0'}', Icons.work_outline, AppColors.primary),
        _buildStatItem('Rate', '\$${controller.artisanData['price'] ?? controller.artisanData['hourly_rate'] ?? '0'}', Icons.monetization_on_outlined, AppColors.statusCompletedText),
      ],
    ));
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

  List<Widget> _buildSkillsList(Map<String, dynamic> artisan) {
    if (artisan['skills'] != null && artisan['skills'] is List && artisan['skills'].isNotEmpty) {
      return (artisan['skills'] as List).map((s) => _buildSkillBadge(s.toString())).toList();
    }
    return [
      _buildSkillBadge('Professional'),
      _buildSkillBadge('Verified'),
    ];
  }

  Widget _buildReviewsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Reviews'.tr),
        const SizedBox(height: 16.0),
        Row(children: [
          const Icon(Icons.star_rounded, color: AppColors.ratingStar, size: 24.0),
          const SizedBox(width: 8.0),
          Obx(() => Text(
            '${controller.artisanData['rating'] ?? '0.0'} ${'Average Rating'.tr}',
            style: GoogleFonts.poppins(color: AppColors.textColor, fontSize: 16.0, fontWeight: FontWeight.w700),
          )),
        ]),
        const SizedBox(height: 16.0),
        Obx(() {
          if (controller.reviews.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text('No reviews yet'.tr, style: GoogleFonts.poppins(color: AppColors.greyText)),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.reviews.length,
            itemBuilder: (context, index) => _buildReviewCard(controller.reviews[index]),
          );
        }),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF1F4F8)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
              radius: 20.0, 
              backgroundColor: Colors.grey[200],
              backgroundImage: (review['image'] != null && review['image'].toString().isNotEmpty)
                  ? NetworkImage(review['image']) 
                  : null,
              child: (review['image'] == null || review['image'].toString().isEmpty)
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 12.0),
            Expanded(child: Text(review['name'] ?? 'Client', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
            Row(
              children: [
                const Icon(Icons.star, color: AppColors.ratingStar, size: 14),
                const SizedBox(width: 4),
                Text('${review['rating']}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12)),
              ],
            )
          ]),
          if (review['comment'] != null && review['comment'].toString().isNotEmpty) ...[
            const SizedBox(height: 8.0),
            Text(review['comment'], style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 13.0)),
          ],
          if (review['date'] != null && review['date'].toString().isNotEmpty) ...[
            const SizedBox(height: 8.0),
            Text(review['date'], style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 11.0)),
          ]
        ],
      ),
    );
  }
}