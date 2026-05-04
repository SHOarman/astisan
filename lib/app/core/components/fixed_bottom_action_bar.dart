import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/static/app_colors.dart';

class FixedBottomActionBar extends StatelessWidget {
  final String? leadingText;
  final String? leadingValue;
  final String buttonText;
  final VoidCallback onPressed;

  const FixedBottomActionBar({
    super.key,
    this.leadingText,
    this.leadingValue,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (leadingText != null && leadingValue != null) ...[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        leadingText!,
                        style: GoogleFonts.poppins(
                          color: AppColors.greyText,
                          fontSize: 12.0,
                        ),

                      ),
                      SizedBox(width: 10,),

                      Text(
                        leadingValue!,
                        style: GoogleFonts.poppins(
                          color: AppColors.textColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
              SizedBox(width: 24.0),
            ],
            Expanded(
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonText,
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Icon(Icons.chevron_right, color: AppColors.white, size: 24.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

