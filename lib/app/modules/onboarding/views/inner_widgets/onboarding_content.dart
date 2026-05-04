import 'package:flutter/material.dart';

import '../../../../core/constants/static/app_colors.dart';
class OnboardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40.0), // Reduced slightly to save space
            
            ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: Image.asset(
                image,
                width: double.infinity,
                height: 380.0, // Reduced to 380 to better fit smaller devices
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 380.0,
                  color: AppColors.indicatorInactive,
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),
            
            const SizedBox(height: 32.0),
            
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
            ),
            const SizedBox(height: 16.0),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.greyText,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 20.0), // Bottom padding for scroll
          ],
        ),
      ),
    );
  }
}

