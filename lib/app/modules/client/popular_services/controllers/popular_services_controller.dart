import 'package:get/get.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/constants/static/app_images.dart';

class PopularServicesController extends GetxController {
  final popularServices = <Map<String, dynamic>>[
    {
      'title': AppStrings.popPipeLeakRepair,
      'image': AppImages.popPipeLeak,
      'rating': 4.8,
      'reviews': 89,
      'priceRange': '\$40-\$80',
    },
    {
      'title': AppStrings.popToiletRepair,
      'image': AppImages.popToiletRepair,
      'rating': 4.8,
      'reviews': 69,
      'priceRange': '\$35-\$65',
    },
    {
      'title': AppStrings.popDeepHouseCleaning,
      'image': AppImages.popDeepCleaning,
      'rating': 4.8,
      'reviews': 89,
      'priceRange': '\$60-\$120',
    },
    {
      'title': AppStrings.popElectricalWiring,
      'image': AppImages.popElectricalWiring,
      'rating': 4.8,
      'reviews': 89,
      'priceRange': '\$80-\$200',
    },
    {
      'title': AppStrings.popAcServiceRepair,
      'image': AppImages.popAcService,
      'rating': 4.8,
      'reviews': 89,
      'priceRange': '\$60-\$120',
    },
    {
      'title': AppStrings.popFurnitureAssembly,
      'image': AppImages.popFurnitureAssembly,
      'rating': 4.8,
      'reviews': 89,
      'priceRange': '\$80-\$200',
    },
    {
      'title': AppStrings.popWallPainting,
      'image': AppImages.popWallPainting,
      'rating': 4.8,
      'reviews': 89,
      'priceRange': '\$60-\$120',
    },
    {
      'title': AppStrings.popLockKeyService,
      'image': AppImages.popLockKey,
      'rating': 4.8,
      'reviews': 89,
      'priceRange': '\$80-\$200',
    },
    {
      'title': AppStrings.popTvInstallation,
      'image': AppImages.popTvInstallation,
      'rating': 4.8,
      'reviews': 89,
      'priceRange': '\$60-\$120',
    },
    {
      'title': AppStrings.popWindowGlassRepair,
      'image': AppImages.popWindowGlass,
      'rating': 4.8,
      'reviews': 89,
      'priceRange': '\$80-\$200',
    },
  ].obs;
}

