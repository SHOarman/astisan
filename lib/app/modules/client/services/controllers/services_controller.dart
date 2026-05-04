import 'package:get/get.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/constants/static/app_images.dart';

class ServicesController extends GetxController {
  final categories = <Map<String, dynamic>>[
    {
      'title': AppStrings.repairMaintenance,
      'icon': AppImages.iconRepairMaintenance,
      'subcategories': [
        {'title': AppStrings.subAcRepair, 'desc': AppStrings.subAcRepairDesc, 'icon': AppImages.subAcRepair},
        {'title': AppStrings.subElectricalFix, 'desc': AppStrings.subElectricalFixDesc, 'icon': AppImages.subElectricalFix},
        {'title': AppStrings.subLockRepair, 'desc': AppStrings.subLockRepairDesc, 'icon': AppImages.subLockRepair},
        {'title': AppStrings.subPlumbingFix, 'desc': AppStrings.subPlumbingFixDesc, 'icon': AppImages.subPlumbingFix},
        {'title': AppStrings.subRoofLeakRepair, 'desc': AppStrings.subRoofLeakRepairDesc, 'icon': AppImages.subRoofLeakRepair},
        {'title': AppStrings.subWallCeilingFix, 'desc': AppStrings.subWallCeilingFixDesc, 'icon': AppImages.subWallCeilingFix},
      ]
    },
    {
      'title': AppStrings.cleaning,
      'icon': AppImages.iconCleaningService,
      'subcategories': [
        {'title': AppStrings.subBathroomCleaning, 'desc': AppStrings.subBathroomCleaningDesc, 'icon': AppImages.subBathroomCleaning},
        {'title': AppStrings.subHomeDeepCleaning, 'desc': AppStrings.subHomeDeepCleaningDesc, 'icon': AppImages.subHomeDeepCleaning},
        {'title': AppStrings.subKitchenCleaning, 'desc': AppStrings.subKitchenCleaningDesc, 'icon': AppImages.subKitchenCleaning},
        {'title': AppStrings.subPostConstruction, 'desc': AppStrings.subPostConstructionDesc, 'icon': AppImages.subPostConstruction},
        {'title': AppStrings.subSofaCarpetCleaning, 'desc': AppStrings.subSofaCarpetCleaningDesc, 'icon': AppImages.subSofaCarpetCleaning},
        {'title': AppStrings.subWindowCleaning, 'desc': AppStrings.subWindowCleaningDesc, 'icon': AppImages.subWindowCleaning},
      ]
    },
    {
      'title': AppStrings.installation,
      'icon': AppImages.iconInstallationService,
      'subcategories': [
        {'title': AppStrings.subAcInstallation, 'desc': AppStrings.subAcInstallationDesc, 'icon': AppImages.subAcInstallation},
        {'title': AppStrings.subCctvSmartHome, 'desc': AppStrings.subCctvSmartHomeDesc, 'icon': AppImages.subCctvSmartHome},
        {'title': AppStrings.subDoorWindowFitting, 'desc': AppStrings.subDoorWindowFittingDesc, 'icon': AppImages.subDoorWindowFitting},
        {'title': AppStrings.subFurnitureAssembly, 'desc': AppStrings.subFurnitureAssemblyDesc, 'icon': AppImages.subFurnitureAssembly},
        {'title': AppStrings.subTvWallMount, 'desc': AppStrings.subTvWallMountDesc, 'icon': AppImages.subTvWallMount},
        {'title': AppStrings.subWaterHeaterSetup, 'desc': AppStrings.subWaterHeaterSetupDesc, 'icon': AppImages.subWaterHeaterSetup},
      ]
    },
    {
      'title': AppStrings.homeImprovement,
      'icon': AppImages.iconHomeImprovement,
      'subcategories': [
        {'title': AppStrings.subBathroomRemodeling, 'desc': AppStrings.subBathroomRemodelingDesc, 'icon': AppImages.subBathroomRemodeling},
        {'title': AppStrings.subFalseCeilingWork, 'desc': AppStrings.subFalseCeilingWorkDesc, 'icon': AppImages.subFalseCeilingWork},
        {'title': AppStrings.subFlooringTiling, 'desc': AppStrings.subFlooringTilingDesc, 'icon': AppImages.subFlooringTiling},
        {'title': AppStrings.subKitchenRenovation, 'desc': AppStrings.subKitchenRenovationDesc, 'icon': AppImages.subKitchenRenovation},
        {'title': AppStrings.subPaintingDecoration, 'desc': AppStrings.subPaintingDecorationDesc, 'icon': AppImages.subPaintingDecoration},
        {'title': AppStrings.subWallpaperPaneling, 'desc': AppStrings.subWallpaperPanelingDesc, 'icon': AppImages.subWallpaperPaneling},
      ]
    },
    {
      'title': AppStrings.movingShifting,
      'icon': AppImages.iconMovingShifting,
      'subcategories': [
        {'title': AppStrings.subHomeRelocation, 'desc': AppStrings.subHomeRelocationDesc, 'icon': AppImages.subHomeRelocation},
        {'title': AppStrings.subJunkRemoval, 'desc': AppStrings.subJunkRemovalDesc, 'icon': AppImages.subJunkRemoval},
        {'title': AppStrings.subOfficeShifting, 'desc': AppStrings.subOfficeShiftingDesc, 'icon': AppImages.subOfficeShifting},
        {'title': AppStrings.subPackingService, 'desc': AppStrings.subPackingServiceDesc, 'icon': AppImages.subPackingService},
        {'title': AppStrings.subSingleItemMoving, 'desc': AppStrings.subSingleItemMovingDesc, 'icon': AppImages.subSingleItemMoving},
        {'title': AppStrings.subStorageService, 'desc': AppStrings.subStorageServiceDesc, 'icon': AppImages.subStorageService},
      ]
    },
    {
      'title': AppStrings.gardenCleaning,
      'icon': AppImages.iconGardenCleaning,
      'subcategories': [
        {'title': AppStrings.subGardenWasteRemoval, 'desc': AppStrings.subGardenWasteRemovalDesc, 'icon': AppImages.subGardenWasteRemoval},
        {'title': AppStrings.subIrrigationSetup, 'desc': AppStrings.subIrrigationSetupDesc, 'icon': AppImages.subIrrigationSetup},
        {'title': AppStrings.subLawnMowing, 'desc': AppStrings.subLawnMowingDesc, 'icon': AppImages.subLawnMowing},
        {'title': AppStrings.subPestControlGarden, 'desc': AppStrings.subPestControlGardenDesc, 'icon': AppImages.subPestControlGarden},
        {'title': AppStrings.subPlantingLandscaping, 'desc': AppStrings.subPlantingLandscapingDesc, 'icon': AppImages.subPlantingLandscaping},
        {'title': AppStrings.subTreeBushTrimming, 'desc': AppStrings.subTreeBushTrimmingDesc, 'icon': AppImages.subTreeBushTrimming},
      ]
    },
  ].obs;
}

