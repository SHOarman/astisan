import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/components/address_tile.dart';
import '../../../../core/components/dashed_container.dart';
import '../controllers/worker_saved_addresses_controller.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WorkerSavedAddressesView extends GetView<WorkerSavedAddressesController> {
  const WorkerSavedAddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Saved Addresses".tr,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24.0),
                  _buildMapSection(context),
                  const SizedBox(height: 32.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      "Current Service Location".tr,
                      style: GoogleFonts.poppins(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Obx(() {
                    if (controller.isLoading.value && controller.currentAddress.value.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: AddressTile(
                        title: 'Service Area'.tr,
                        address: controller.currentAddress.value.isNotEmpty ? controller.currentAddress.value : "Tap 'Use Current Location' above to set your area.".tr,
                        isDefault: true,
                        icon: Icons.my_location,
                        isSelected: true,
                        onTap: () {},
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildMapSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(AppImages.mapPlaceholder),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FlutterMap(
                mapController: controller.mapController,
                options: MapOptions(
                  initialCenter: controller.selectedLocation.value,
                  initialZoom: 15.0,
                  onPositionChanged: (position, hasGesture) {
                    if (hasGesture && position.center != null) {
                      controller.selectedLocation.value = position.center!;
                    }
                  },
                  onTap: (tapPosition, point) {
                    controller.mapController.move(point, controller.mapController.camera.zoom);
                    controller.selectedLocation.value = point;
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=GPXbdZO7XpRukMLD8Bz1',
                    userAgentPackageName: 'com.example.app',
                  ),
                ],
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 40.0), // Points exactly to center
                child: Icon(Icons.location_on, size: 40, color: Colors.red),
              ),
            ),
            // Use Current Location Button
            Obx(() {
              if (controller.hasSavedAddress.value) {
                return const SizedBox.shrink();
              }
              return Positioned(
                left: 16,
                bottom: 16,
                child: GestureDetector(
                  onTap: controller.useCurrentLocation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.my_location, color: AppColors.primary, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          "Use Current Location".tr,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }


  Widget _buildSaveButton() {
    return Obx(() {
      if (controller.hasSavedAddress.value) {
        return const SizedBox.shrink();
      }
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 56.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 0,
            ),
            child: controller.isLoading.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
              : Text(
                  "Save Changes".tr,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          ),
        ),
      );
    });
  }
}
