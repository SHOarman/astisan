import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/static/app_colors.dart';
import '../../../core/constants/static/app_images.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller for dependency injection
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Image.asset(
          AppImages.logo,
          width: 200.0, // Approximate logo width
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => 
              const Icon(Icons.broken_image, size: 100),
        ),
      ),
    );
  }
}

