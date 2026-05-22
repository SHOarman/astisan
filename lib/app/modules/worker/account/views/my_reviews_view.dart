import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/components/review_tile.dart';
import '../controllers/my_reviews_controller.dart';

class MyReviewsView extends GetView<MyReviewsController> {
  const MyReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Reviews',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 50,),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Client Feedback',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'See all',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      );
                    }
                    if (controller.reviews.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Text(
                            "No reviews yet.",
                            style: GoogleFonts.poppins(color: AppColors.greyText),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.reviews.length,
                      itemBuilder: (context, index) {
                        final review = controller.reviews[index];
                        return ReviewTile(
                          clientName: review['name'],
                          date: review['date'],
                          rating: review['rating'],
                          comment: review['comment'],
                          serviceName: review['service'],
                          payment: review['payment'],
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 80,
          color: AppColors.primary,
        ),
        Positioned(
          bottom: -60,
          left: 24,
          right: 24,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Obx(() => Text(
                      controller.avgRating.value.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    )),
                    Row(
                      children: List.generate(5, (index) => const Icon(Icons.star_rounded, color: Colors.amber, size: 16)),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                      '${controller.totalReviews} reviews',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.greyText,
                      ),
                    )),
                  ],
                ),
                const SizedBox(width: 24),
                const VerticalDivider(width: 1),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      Obx(() => _buildRatingBar('5', controller.totalReviews.value > 0 ? (controller.ratingBreakdown['5'] ?? 0) / controller.totalReviews.value : 0)),
                      Obx(() => _buildRatingBar('4', controller.totalReviews.value > 0 ? (controller.ratingBreakdown['4'] ?? 0) / controller.totalReviews.value : 0)),
                      Obx(() => _buildRatingBar('3', controller.totalReviews.value > 0 ? (controller.ratingBreakdown['3'] ?? 0) / controller.totalReviews.value : 0)),
                      Obx(() => _buildRatingBar('2', controller.totalReviews.value > 0 ? (controller.ratingBreakdown['2'] ?? 0) / controller.totalReviews.value : 0)),
                      Obx(() => _buildRatingBar('1', controller.totalReviews.value > 0 ? (controller.ratingBreakdown['1'] ?? 0) / controller.totalReviews.value : 0)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 140), // Placeholder for stack height
      ],
    );
  }

  Widget _buildRatingBar(String star, double percent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Text(
            star,
            style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star_rounded, color: Colors.amber, size: 10),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: const Color(0xFFF1F4F8),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
