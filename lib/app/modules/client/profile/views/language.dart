import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/global_controllers/role_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../dashboard/controllers/dashboard_controller.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  final RoleController roleController = Get.find<RoleController>();

  Future<void> _changeLanguage(String langCode) async {
    // Show loading
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.white)),
      barrierDismissible: false,
    );

    // Set language
    roleController.setLanguage(langCode);

    // Small delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Dismiss loading
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    // Success snackbar
    Get.snackbar(
      "Success", 
      "Language changed successfully", 
      backgroundColor: Colors.green.withOpacity(0.9), 
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );

    // Ensure dashboard is on the home tab
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().changePage(0);
    }
    
    // Redirect to Dashboard (automatically routes to client/worker based on role)
    Get.offAllNamed(Routes.DASHBOARD);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Language",
          style: TextStyle(
            color: Color(0xFF1D2939),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        String currentLang = roleController.isClient 
            ? roleController.clientLanguage.value 
            : roleController.workerLanguage.value;
            
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              _buildLanguageTile("English", "en", currentLang == "en"),
              const SizedBox(height: 12),
              _buildLanguageTile("French", "fr", currentLang == "fr"),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLanguageTile(String title, String langCode, bool isSelected) {
    return GestureDetector(
      onTap: () => _changeLanguage(langCode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEEF4FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFADC8FF) : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D2939),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF2E90FA),
                size: 20,
              )
            else
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}