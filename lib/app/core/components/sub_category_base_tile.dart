import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/static/app_colors.dart';

class SubCategoryBaseTile extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final VoidCallback onTap;

  const SubCategoryBaseTile({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
          children: [
            // Safe rendering of SVG Icon directly
            Image.asset(
              iconPath,
              width: 50.0,
              height: 50.0,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 50.0,
                height: 50.0,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
            SizedBox(width: 16.0),
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyText,
                    ),
                  ),
                ],
              ),
            ),
            // Right Arrow
            Icon(Icons.arrow_forward, color: AppColors.textColor, size: 20.0),
          ],
        ),
      ),
    );
  }
}
