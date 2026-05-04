import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/components/custom_button.dart';
import '../../../core/constants/static/app_colors.dart';
import '../../../core/constants/static/app_images.dart';
import '../../../core/constants/static/app_strings.dart';
import '../controllers/onboarding_controller.dart';
import './inner_widgets/onboarding_content.dart';
import './inner_widgets/onboarding_indicator.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    // Define data for the 3 pages mapped from AppStrings and AppImages
    final List<Map<String, String>> pagesData = [
      {
        "image": AppImages.onboarding1,
        "title": AppStrings.findTrustedHelp.tr,
        "description": AppStrings.findTrustedHelpSub.tr,
      },
      {
        "image": AppImages.onboarding2,
        "title": AppStrings.trackService.tr,
        "description": AppStrings.trackServiceSub.tr,
      },
      {
        "image": AppImages.onboarding3,
        "title": AppStrings.securePayments.tr,
        "description": AppStrings.securePaymentsSub.tr,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // PageView taking remaining space
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: pagesData.length,
                itemBuilder: (context, index) {
                  return OnboardingContent(
                    image: pagesData[index]["image"]!,
                    title: pagesData[index]["title"]!,
                    description: pagesData[index]["description"]!,
                  );
                },
              ),
            ),
            
            // Custom Indicator placed below the images/text content
            Obx(
              () => OnboardingIndicator(
                itemCount: pagesData.length,
                currentIndex: controller.currentIndex.value,
              ),
            ),
            
            SizedBox(height: 40.0),
            
            // Bottom Action Button
            Obx(() {
              final isLastPage = controller.currentIndex.value == pagesData.length - 1;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: CustomButton(
                  text: isLastPage ? AppStrings.getStarted.tr : AppStrings.next.tr,
                  trailingIconPath: AppImages.arrowRight,
                  onPressed: controller.onNextTapped,
                ),
              );
            }),
            
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}

