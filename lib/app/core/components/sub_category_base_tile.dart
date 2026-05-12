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
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F7FA), // Light blueish-grey background
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1.0), // Added border back as requested
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
            iconPath.startsWith('http')
                ? Image.network(
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
                  )
                : Image.asset(
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
                  if (description.trim().isNotEmpty) ...[
                    const SizedBox(height: 4.0),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87, // Changed to black as requested
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ] else ...[
                    // For debugging: show this to see if the issue is data or UI
                    const SizedBox(height: 4.0),
                    Text(
                      "Details available on booking", 
                      style: GoogleFonts.poppins(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8A99A7).withOpacity(0.5),
                      ),
                    ),
                  ],
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
