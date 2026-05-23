import 'package:artisan/app/core/constants/static/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/components/address_tile.dart';
import '../controllers/saved_addresses_controller.dart';

import '../../../../core/components/dashed_container.dart';

class SavedAddressesView extends GetView<SavedAddressesController> {
  const SavedAddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppStrings.saveAddress.tr,
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
                  _buildMapSection(),
                  const SizedBox(height: 32.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      AppStrings.saveAddress.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ));
                    }
                    
                    if (controller.savedAddresses.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Text(
                           AppStrings.not_addreshfined.tr,
                            style: GoogleFonts.poppins(color: AppColors.greyText),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      itemCount: controller.savedAddresses.length,
                      itemBuilder: (context, index) {
                        final addr = controller.savedAddresses[index];
                        return AddressTile(
                          title: addr['title'],
                          address: addr['address'],
                          isDefault: addr['isDefault'],
                          icon: addr['icon'],
                          onTap: () {},
                          onDelete: () => controller.deleteAddress(addr['id'].toString()),
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 12.0),
                  _buildAddNewButton(),
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

  Widget _buildMapSection() {
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

      ),
    );
  }

  Widget _buildAddNewButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GestureDetector(
        onTap: controller.addNewAddress,
        child: DashedContainer(
          color: const Color(0xFFD1D5DB),
          dashWidth: 4,
          dashSpace: 4,
          borderRadius: 20,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Color(0xFF374B71), size: 22),
              const SizedBox(width: 10.0),
              Text(
              AppStrings.addNewAddress.tr,
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF374B71),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          onPressed: controller.saveChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 56.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 0,
          ),
          child: Text(
            AppStrings.saveChangess.tr,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
