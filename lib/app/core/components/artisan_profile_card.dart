import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/static/app_colors.dart';
import '../constants/static/app_strings.dart';
import 'package:get/get.dart';

class ArtisanProfileCard extends StatelessWidget {
  final String name;
  final String role;
  final String avatarPath;
  final bool isVerified;
  final double rating;
  final int reviews;
  final String pricePerHour;
  final String distanceOrTime;
  final VoidCallback onTap;

  const ArtisanProfileCard({
    super.key,
    required this.name,
    required this.role,
    required this.avatarPath,
    this.isVerified = true,
    required this.rating,
    required this.reviews,
    required this.pricePerHour,
    required this.distanceOrTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    avatarPath,
                    width: 60.0,
                    height: 60.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60.0,
                      height: 60.0,
                      color: AppColors.border,
                      child: Icon(Icons.person, color: AppColors.greyText),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.circle, color: AppColors.statusCompletedText, size: 10.0),
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isVerified) ...[
                        SizedBox(width: 8.0),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(25),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            AppStrings.verified.tr,
                            style: GoogleFonts.poppins(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        role,
                        style: GoogleFonts.poppins(
                          fontSize: 14.0,
                          color: AppColors.greyText,
                        ),
                      ),
                      Text(
                        pricePerHour,
                        style: GoogleFonts.poppins(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.ratingStar, size: 16.0),
                      SizedBox(width: 4.0),
                      Text(
                        '$rating',
                        style: GoogleFonts.poppins(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        '($reviews)',
                        style: GoogleFonts.poppins(
                          fontSize: 12.0,
                          color: AppColors.greyText,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Icon(Icons.access_time, color: AppColors.greyText, size: 14.0),
                      SizedBox(width: 4.0),
                      Text(
                        distanceOrTime,
                        style: GoogleFonts.poppins(
                          fontSize: 12.0,
                          color: AppColors.greyText,
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
    );
  }
}

