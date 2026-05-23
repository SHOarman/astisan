import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/static/app_colors.dart';
import '../../../core/constants/static/app_strings.dart';
import '../controllers/support_controller.dart';

class PrivacyPolicyView extends GetView<SupportController> {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SupportController>()) {
      Get.put(SupportController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Privacy Policy'.tr,
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingPrivacy.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            controller.privacyContent.value,
            style: GoogleFonts.poppins(
              color: Colors.grey[800],
              fontSize: 14.0,
              height: 1.6,
            ),
          ),
        );
      }),
    );
  }
}
