import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/components/service_item_card.dart';
import '../controllers/popular_services_controller.dart';
import '../../../../core/routes/app_routes.dart';

class PopularServicesView extends GetView<PopularServicesController> {
  const PopularServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PopularServicesController());
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(24.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.greyText.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: AppColors.textColor, size: 20.0),
            ),
          ),
        ),
        title: Text(
          AppStrings.popularServices.tr,
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Text(
                AppStrings.allPopularServices.tr,
                style: GoogleFonts.poppins(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: Obx(() => GridView.builder(
                  padding: EdgeInsets.only(bottom: 24.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: controller.popularServices.length,
                  itemBuilder: (context, index) {
                    final service = controller.popularServices[index];
                    return ServiceItemCard(
                      title: service['title'] as String,
                      imagePath: service['image'] as String,
                      rating: (service['rating'] as num).toDouble(),
                      reviews: service['reviews'] as int,
                      priceRange: service['priceRange'] as String,
                      onTap: () {
                        Get.toNamed(Routes.BOOKING, arguments: {
                          'service': service,
                          'source': 'popular_services',
                        });
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

