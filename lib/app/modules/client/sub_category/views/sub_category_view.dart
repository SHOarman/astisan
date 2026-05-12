import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/components/sub_category_base_tile.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/sub_category_controller.dart';

class SubCategoryView extends GetView<SubCategoryController> {
  const SubCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SubCategoryController());
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textColor),
        onPressed: () {
          try {
            final dashboardController = Get.find<DashboardController>();
            dashboardController.changePage(1);
            Get.back();
          } catch (e) {
            Get.offAllNamed(Routes.DASHBOARD); // Fallback to Dashboard
            Get.find<DashboardController>().changePage(1);
          }
        },
        ),
        title: Text(
          'Services', // Matches the mockups header
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Obx(() => Text(
                controller.title,
                style: GoogleFonts.poppins(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              )),
              Obx(() => controller.categoryDescription.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        controller.categoryDescription.value,
                        style: GoogleFonts.poppins(
                          fontSize: 14.0,
                          color: AppColors.greyText,
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
              SizedBox(height: 24.0),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.services.isEmpty) {
                    return Center(
                      child: Text(
                        "No services available in this category",
                        style: GoogleFonts.poppins(color: AppColors.greyText),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    itemCount: controller.services.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                    itemBuilder: (context, index) {
                      final item = controller.services[index];
                      return SubCategoryBaseTile(
                        title: item['title'] ?? '',
                        description: item['description'] ?? '',
                        iconPath: item['image'] ?? '',
                        onTap: () {
                          Get.toNamed(Routes.BOOKING, arguments: {
                            'service': item,
                          });
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

