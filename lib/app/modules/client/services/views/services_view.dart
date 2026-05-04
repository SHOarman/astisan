import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/components/service_category_card.dart';
import '../controllers/services_controller.dart';

class ServicesView extends GetView<ServicesController> {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ServicesController());
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Services',
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
              Text(
                AppStrings.ourAllServices.tr,
                style: GoogleFonts.poppins(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                AppStrings.goAnywhere.tr,
                style: GoogleFonts.poppins(
                  fontSize: 14.0,
                  color: AppColors.greyText,
                ),
              ),
              SizedBox(height: 24.0),
              Expanded(
                child: Obx(() => GridView.builder(
                  padding: EdgeInsets.only(bottom: 24.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 1.0, // adjusted back to square for category cards
                  ),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return ServiceCategoryCard(
                      title: category['title'],
                      imagePath: category['icon'],
                      onTap: () {
                        // We will add Routes.SUB_CATEGORY to app_routes.dart later.
                        Get.toNamed('/sub-category', arguments: category);
                      },
                    );
                  },
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

