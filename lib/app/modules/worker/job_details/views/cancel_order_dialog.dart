import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/worker_job_details_controller.dart';

class CancelOrderDialog extends GetView<WorkerJobDetailsController> {
  const CancelOrderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.cancelOrderTitle.tr,
              style: GoogleFonts.poppins(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              AppStrings.cancelOrderSub.tr,
              style: GoogleFonts.poppins(
                fontSize: 14.0,
                color: AppColors.greyText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: controller.confirmCancellation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF37569), // Pinkish Red from Image 14
                minimumSize: const Size(double.infinity, 56.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                elevation: 0,
              ),
              child: Text(
                AppStrings.confirm.tr,
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56.0),
                side: const BorderSide(color: Color(0xFF0F172A)), // Dark border from Image 14
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              ),
              child: Text(
                AppStrings.cancel.tr,
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
