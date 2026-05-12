import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../constants/static/app_colors.dart';
import '../Services/api_services.dart';

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
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: avatarPath.startsWith('http') || avatarPath.contains('services/')
                      ? Image.network(
                          ApiServices.formatImageUrl(avatarPath),
                          width: 70.0,
                          height: 70.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildAvatarPlaceholder(),
                        )
                      : Image.asset(
                          avatarPath,
                          width: 70.0,
                          height: 70.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildAvatarPlaceholder(),
                        ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50), // Online Green
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16.0),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isVerified)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9), // Light green bg
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'VERIFIED',
                            style: GoogleFonts.poppins(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2E7D32), // Dark green text
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    role,
                    style: GoogleFonts.poppins(
                      fontSize: 13.0,
                      color: AppColors.greyText,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFB300), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        ' ($reviews)',
                        style: GoogleFonts.poppins(
                          fontSize: 12.0,
                          color: AppColors.greyText,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time, color: AppColors.greyText, size: 14),
                      const SizedBox(width: 4),
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
            const SizedBox(width: 8.0),
            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  pricePerHour.startsWith('\$') ? pricePerHour : '\$$pricePerHour',
                  style: GoogleFonts.poppins(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '/hr',
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
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      width: 70.0,
      height: 70.0,
      color: AppColors.primary.withOpacity(0.1),
      child: const Icon(Icons.person, color: AppColors.primary),
    );
  }
}


