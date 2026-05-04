import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_images.dart';
import '../controllers/select_location_controller.dart';

class SelectLocationView extends GetView<SelectLocationController> {
  const SelectLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Layer 1: Full-screen map placeholder with interaction detection
          Positioned.fill(
            child: GestureDetector(
              onPanUpdate: (_) => controller.onMapInteraction(),
              onTap: () => controller.onMapInteraction(),
              child: Image.asset(AppImages.mapPlaceholder, fit: BoxFit.cover),
            ),
          ),

          // Layer 2: Fixed Location Marker in center
          const Center(
            child: Icon(
              Icons.location_on,
              size: 48.0,
              color: AppColors.primary,
            ),
          ),

          // Layer 3: Top Navigation & Search Bar
          Positioned(
            top: 60.0,
            left: 24.0,
            right: 24.0,
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.textColor,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for address...',
                      hintStyle: GoogleFonts.poppins(
                        color: AppColors.greyText,
                        fontSize: 14.0,
                      ),
                      icon: const Icon(Icons.search, color: AppColors.greyText),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Layer 4: Bottom Address Details Card
          Positioned(
            bottom: 40.0,
            left: 24.0,
            right: 24.0,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Location Details',
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyText,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 24.0,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Obx(
                          () => Text(
                            controller.selectedAddress.value,
                            style: GoogleFonts.poppins(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),

                  // Dynamic Action Button (My Location vs Confirm Location)
                  Obx(() {
                    final bool isSelected = controller.isLocationSelected.value;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSelected
                            ? controller.setAddress
                            : controller.onMyLocationTapped,
                        style: ElevatedButton.styleFrom(
                          // Use a slightly lighter blue for "My Location" state as per image
                          backgroundColor: isSelected
                              ? AppColors.primary
                              : const Color(0xFF6A95D0),
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ), // More rounded corners matching image
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          isSelected ? 'Confirm Location' : 'My Location',
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
