import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/static/app_colors.dart';

class SelectableDateCard extends StatelessWidget {
  final String day;
  final String date;
  final String month;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableDateCard({
    super.key,
    required this.day,
    required this.date,
    required this.month,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60.0,
        margin: EdgeInsets.only(right: 12.0),
        padding: EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(16.0),
          border: isSelected ? null : Border.all(color: AppColors.border),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(50),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              day,
              style: GoogleFonts.poppins(
                color: isSelected ? AppColors.white.withAlpha(200) : AppColors.greyText,
                fontSize: 12.0,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              date,
              style: GoogleFonts.poppins(
                color: isSelected ? AppColors.white : AppColors.textColor,
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              month,
              style: GoogleFonts.poppins(
                color: isSelected ? AppColors.white.withAlpha(200) : AppColors.greyText,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

