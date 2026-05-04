import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/static/app_colors.dart';

class ArtisanBottomSheetCard extends StatelessWidget {
  final Widget? headerWidget;
  final String avatarPath;
  final String name;
  final String? badgeText;
  final String details;
  final String? ratingText; // "Rating" text above star
  final String ratingValue;
  final Widget? trailingIcon;
  final Widget actionWidget;
  final bool isOnline;

  const ArtisanBottomSheetCard({
    super.key,
    this.headerWidget,
    required this.avatarPath,
    required this.name,
    this.badgeText,
    required this.details,
    this.ratingText,
    required this.ratingValue,
    this.trailingIcon,
    required this.actionWidget,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (headerWidget != null) ...[
            headerWidget!,
            SizedBox(height: 24.0),
          ],
          Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      avatarPath,
                      width: 56.0,
                      height: 56.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      bottom: -2.0,
                      right: -2.0,
                      child: Container(
                        width: 16.0,
                        height: 16.0,
                        decoration: BoxDecoration(
                          color: AppColors.statusCompletedText,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2.5),
                        ),
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
                        Text(
                          name,
                          style: GoogleFonts.poppins(
                            color: AppColors.textColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (badgeText != null) ...[
                          SizedBox(width: 8.0),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              color: AppColors.statusCompletedBg,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              badgeText!,
                              style: GoogleFonts.poppins(
                                color: AppColors.statusCompletedText,
                                fontSize: 10.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      details,
                      style: GoogleFonts.poppins(
                        color: AppColors.greyText,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailingIcon != null) trailingIcon! 
              else Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (ratingText != null)
                    Text(
                      ratingText!,
                      style: GoogleFonts.poppins(
                        color: AppColors.greyText,
                        fontSize: 12.0,
                      ),
                    ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.ratingStar, size: 16.0),
                      SizedBox(width: 4.0),
                      Text(
                        ratingValue,
                        style: GoogleFonts.poppins(
                          color: AppColors.textColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.0),
          actionWidget,
        ],
      ),
    );
  }
}

