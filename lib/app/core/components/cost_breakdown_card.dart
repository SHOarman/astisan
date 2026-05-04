import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/static/app_colors.dart';

class CostBreakdownItem {
  final String title;
  final String amount;
  final Color? amountColor;
  final bool isBold;

  CostBreakdownItem({
    required this.title,
    required this.amount,
    this.amountColor,
    this.isBold = false,
  });
}

class CostBreakdownCard extends StatelessWidget {
  final List<CostBreakdownItem> items;
  final String totalLabel;
  final String totalAmount;
  final IconData? icon;
  final String? cardTitle;

  const CostBreakdownCard({
    super.key,
    required this.items,
    required this.totalLabel,
    required this.totalAmount,
    this.icon,
    this.cardTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cardTitle != null || icon != null) ...[
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.primary, size: 20.0),
                  SizedBox(width: 8.0),
                ],
                if (cardTitle != null)
                  Text(
                    cardTitle!,
                    style: GoogleFonts.poppins(
                      color: AppColors.textColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.0),
          ],
          ...items.map((item) => Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.poppins(
                          color: AppColors.greyText,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Text(
                      item.amount,
                      style: GoogleFonts.poppins(
                        color: item.amountColor ?? AppColors.textColor,
                        fontSize: 14.0,
                        fontWeight: item.isBold ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: AppColors.border),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                totalLabel,
                style: GoogleFonts.poppins(
                  color: AppColors.textColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                totalAmount,
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

