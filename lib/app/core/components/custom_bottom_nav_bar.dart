import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/static/app_colors.dart';

class NavItemData {
  final String label;
  final dynamic icon; // Can be String (svg) or IconData

  NavItemData({required this.label, required this.icon});
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavItemData> items;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    // We use a fixed height but let's ensure the background reaches the bottom
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false, // Only bottom safe area
        child: Container(
          height: 80.0, // Standard height for the content part
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (index) {
              return _buildNavItem(
                index,
                items[index].label,
                items[index].icon,
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, dynamic icon) {
    final isActive = currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: isActive
            ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0)
            : const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isActive ? AppColors.bottomNavActiveBg : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            _buildIconWidget(icon, isActive),
            if (isActive) ...[
              const SizedBox(width: 8.0),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIconWidget(dynamic icon, bool isActive) {
    final color = isActive ? AppColors.primary : AppColors.greyText;
    if (icon is IconData) {
      return Icon(icon, size: 26.0, color: color);
    } else if (icon is String) {
      return SvgPicture.asset(
        icon,
        width: 24.0,
        height: 24.0,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }
    return const SizedBox();
  }
}
