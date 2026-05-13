import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/static/app_colors.dart';
import '../Services/api_services.dart';

class ArtisanHomeCard extends StatelessWidget {
  final String name;
  final String role;
  final String avatarPath;
  final bool isVerified;
  final double rating;
  final int reviews;
  final String pricePerHour;
  final String distanceOrTime;
  final bool isOnline;
  final VoidCallback onTap;

  const ArtisanHomeCard({
    super.key,
    required this.name,
    required this.role,
    required this.avatarPath,
    this.isVerified = true,
    required this.rating,
    required this.reviews,
    required this.pricePerHour,
    required this.distanceOrTime,
    this.isOnline = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.0,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
                    child: avatarPath.isEmpty
                        ? _buildPlaceholder()
                        : avatarPath.startsWith('http')
                            ? Image.network(
                                avatarPath,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                              )
                            : Image.asset(
                                avatarPath,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                              ),
                  ),
                  if (isVerified)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified, color: Colors.blue, size: 16),
                      ),
                    ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          role,
                          style: GoogleFonts.poppins(
                            fontSize: 11.0,
                            color: AppColors.greyText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$$pricePerHour/hr',
                          style: GoogleFonts.poppins(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          distanceOrTime,
                          style: GoogleFonts.poppins(
                            fontSize: 10.0,
                            color: AppColors.greyText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.primary.withOpacity(0.1),
      child: const Icon(Icons.person, color: AppColors.primary, size: 40),
    );
  }
}
