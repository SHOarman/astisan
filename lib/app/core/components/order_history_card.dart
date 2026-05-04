import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:artisan/app/core/constants/static/app_colors.dart';
import 'package:artisan/app/core/constants/static/app_strings.dart';
import 'package:get/get.dart';

class OrderHistoryCard extends StatelessWidget {
  final String title;
  final String artisanName;
  final String date;
  final String price;
  final String status;
  final String imagePath;
  final String artisanAvatarPath;
  final VoidCallback onRate;
  final VoidCallback onRebook;

  const OrderHistoryCard({
    super.key,
    required this.title,
    required this.artisanName,
    required this.date,
    required this.price,
    required this.status,
    required this.imagePath,
    required this.artisanAvatarPath,
    required this.onRate,
    required this.onRebook,
  });

  Color _getStatusColor() {
    if (status.toLowerCase().contains('cancelled')) return AppColors.statusCancelledText;
    return AppColors.statusCompletedText;
  }

  Color _getStatusBgColor() {
    if (status.toLowerCase().contains('cancelled')) return AppColors.statusCancelledBg;
    return AppColors.statusCompletedBg;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20.0), // Rounded as per Activity.jpg
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Image with Artisan Overlay
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      imagePath,
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 2.0,
                    right: 2.0,
                    child: Container(
                      padding: const EdgeInsets.all(1.0),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 12.0,
                        backgroundColor: AppColors.border,
                        backgroundImage: AssetImage(artisanAvatarPath),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16.0),
              
              // Details Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: _getStatusBgColor(),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, color: _getStatusColor(), size: 8.0),
                              const SizedBox(width: 6.0),
                              Text(
                                status,
                                style: GoogleFonts.poppins(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w600,
                                  color: _getStatusColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      '${AppStrings.by.tr}$artisanName',
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyText,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          date,
                          style: GoogleFonts.poppins(
                            fontSize: 13.0,
                            color: AppColors.greyText.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          price,
                          style: GoogleFonts.poppins(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: _getStatusColor(), // Design shows green for price on completed
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12.0),
        
        // Action Buttons
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onRate,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.border.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: AppColors.ratingStar, size: 20.0),
                      const SizedBox(width: 8.0),
                      Text(
                        AppStrings.rate.tr,
                        style: GoogleFonts.poppins(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: InkWell(
                onTap: onRebook,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sync, color: AppColors.primary.withOpacity(0.7), size: 20.0),
                      const SizedBox(width: 8.0),
                      Text(
                        AppStrings.rebook.tr,
                        style: GoogleFonts.poppins(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24.0), // Gap between cards
      ],
    );
  }
}
