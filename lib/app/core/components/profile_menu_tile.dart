import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/static/app_colors.dart';

class ProfileMenuTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final dynamic icon; // Supports IconData or String path
  final Color iconBgColor;
  final VoidCallback onTap;

  const ProfileMenuTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconBgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: iconBgColor.withAlpha(25),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: _buildIcon(),
            ),
            const SizedBox(width: 16.0),
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
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2.0),
                    Text(
                      subtitle!,
                      style: GoogleFonts.poppins(
                        fontSize: 13.0,
                        color: AppColors.greyText,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.greyText,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (icon is IconData) {
      return Icon(
        icon as IconData,
        color: AppColors.textColor,
        size: 24.0,
      );
    } else if (icon is String) {
      final String path = icon as String;
      if (path.endsWith('.svg')) {
        return SvgPicture.asset(
          path,
          colorFilter: const ColorFilter.mode(AppColors.textColor, BlendMode.srcIn),
          width: 24.0,
          height: 24.0,
        );
      } else {
        return Image.asset(
          path,
          width: 24.0,
          height: 24.0,
          color: AppColors.textColor,
        );
      }
    }
    return const SizedBox();
  }
}