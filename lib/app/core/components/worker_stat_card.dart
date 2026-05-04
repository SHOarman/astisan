import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/static/app_colors.dart';

class WorkerStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Widget? icon;
  final Color? subtitleColor;
  final Color? backgroundColor;

  const WorkerStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.subtitleColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(width: 8.0),
              ],
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12.0,
                  color: AppColors.greyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4.0),
            Text(
              subtitle!,
              style: GoogleFonts.inter(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: subtitleColor ?? AppColors.onlineGreen,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

