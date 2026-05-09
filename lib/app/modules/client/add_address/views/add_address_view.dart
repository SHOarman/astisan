import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/components/custom_button.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../controllers/add_address_controller.dart';

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
              CustomTextField(
                labelText: "Address Line",
                hintText: "Street address, Apartment, etc.",
                controller: controller.addressController,
                validator: (v) => v!.isEmpty ? 'Enter address' : null,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      labelText: "City",
                      hintText: "New York",
                      controller: controller.cityController,
                      validator: (v) => v!.isEmpty ? 'Enter city' : null,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: CustomTextField(
                      labelText: "State",
                      hintText: "NY",
                      controller: controller.stateController,
                      validator: (v) => v!.isEmpty ? 'Enter state' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      labelText: "Zip Code",
                      hintText: "10001",
                      controller: controller.zipController,
                      validator: (v) => v!.isEmpty ? 'Enter zip' : null,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: CustomTextField(
                      labelText: "Country",
                      hintText: "USA",
                      controller: controller.countryController,
                      validator: (v) => v!.isEmpty ? 'Enter country' : null,
                    ),
                  ),
                ],
              ),
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
