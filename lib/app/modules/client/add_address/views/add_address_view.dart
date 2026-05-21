import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/components/custom_button.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../controllers/add_address_controller.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AddAddressView extends GetView<AddAddressController> {
  const AddAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Add New Address",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabelSelection(),
              const SizedBox(height: 24.0),
              Obx(() => controller.label.value == 'other' 
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CustomTextField(
                      labelText: "Custom Label",
                      hintText: "e.g. Grandma's House",
                      controller: controller.customLabelController,
                      validator: (v) => v!.isEmpty ? 'Enter a label' : null,
                    ),
                  )
                : const SizedBox.shrink()),
              const SizedBox(height: 16.0),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      FlutterMap(
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
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 40.0), // Points exactly to center
                          child: Icon(Icons.location_on, size: 40, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Obx(() => Text(
                "Selected Location: ${controller.selectedLocation.value.latitude.toStringAsFixed(4)}, ${controller.selectedLocation.value.longitude.toStringAsFixed(4)}",
                style: GoogleFonts.poppins(fontSize: 12, color: AppColors.greyText),
              )),
              const SizedBox(height: 24.0),
              _buildDefaultSwitch(),
              const SizedBox(height: 40.0),
              Obx(() => CustomButton(
                text: "Save Address",
                isLoading: controller.isLoading.value,
                onPressed: controller.saveAddress,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabelSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Save address as",
          style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w700, color: AppColors.textColor),
        ),
        const SizedBox(height: 12.0),
        Obx(() => Row(
          children: [
            _labelChip(Icons.home_rounded, "Home", "home"),
            const SizedBox(width: 12.0),
            _labelChip(Icons.work_rounded, "Office", "office"),
            const SizedBox(width: 12.0),
            _labelChip(Icons.location_on_rounded, "Other", "other"),
          ],
        )),
      ],
    );
  }

  Widget _labelChip(IconData icon, String title, String value) {
    bool isSelected = controller.label.value == value;
    return GestureDetector(
      onTap: () => controller.setLabel(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : AppColors.greyText, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: isSelected ? Colors.white : AppColors.textColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultSwitch() {
    return Obx(() => Row(
      children: [
        Switch(
          value: controller.isDefault.value,
          onChanged: (v) => controller.isDefault.value = v,
          activeColor: AppColors.primary,
        ),
        const SizedBox(width: 8),
        Text(
          "Set as default address",
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textColor),
        ),
      ],
    ));
  }
}
