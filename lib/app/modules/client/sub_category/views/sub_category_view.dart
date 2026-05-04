import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/components/sub_category_base_tile.dart';
import '../../../../core/routes/app_routes.dart';
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
          onPressed: () => Get.back(),
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
              SizedBox(height: 4.0),
              Text(
                AppStrings.whatDoYouNeedHelpWith.tr,
                style: GoogleFonts.poppins(
                  fontSize: 14.0,
                  color: AppColors.greyText,
                ),
              ),
              SizedBox(height: 24.0),
              Expanded(
                child: Obx(() => ListView.separated(
                  padding: EdgeInsets.only(bottom: 24.0),
                  itemCount: controller.subcategories.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.0),
                  itemBuilder: (context, index) {
                    final item = controller.subcategories[index];
                    return SubCategoryBaseTile(
                      title: item['title'] ?? '',
                      description: item['desc'] ?? '',
                      iconPath: item['icon'] ?? '',
                      onTap: () {
                        Get.toNamed(Routes.BOOKING, arguments: item);
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

