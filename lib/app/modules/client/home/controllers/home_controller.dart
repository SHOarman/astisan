import 'package:get/get.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/constants/static/app_strings.dart';

class HomeController extends GetxController {
  final forYouCategories = <Map<String, dynamic>>[
    {
      'title': AppStrings.repairMaintenance,
      'icon': AppImages.forYouRepair,
    },
    {
      'title': AppStrings.cleaning,
      'icon': AppImages.forYouCleaning,
    },
    {
      'title': AppStrings.installation,
      'icon': AppImages.forYouInstallation,
    },
    {
      'title': AppStrings.homeImprovement,
      'icon': AppImages.forYouHomeImprovement,
    },
  ].obs;

  final popularServices = <Map<String, dynamic>>[
    {
      'title': 'Pipe Leak Repair',
      'image': AppImages.homePipeLeak,
      'rating': 4.8,
      'reviews': 89,
      'priceRange': '\$40-\$80',
    },
    {
      'title': 'Toilet Repair',
      'image': AppImages.homeToiletRepair,
      'rating': 4.8,
      'reviews': 69,
      'priceRange': '\$35-\$65',
    },
    {
      'title': 'Deep House Cleaning',
      'image': AppImages.homeDeepCleaning,
      'rating': 4.8,
      'reviews': 89,
      'priceRange': '\$60-\$120',
    },
    {
      'title': 'Electrical Wiring',
      'image': AppImages.homeElectricalWiring,
      'rating': 4.8,
      'reviews': 89,
      'priceRange': '\$80-\$200',
    },
  ].obs;

  final recommendedArtisans = <Map<String, dynamic>>[
    {
      'name': 'Marcus Johnson',
      'role': 'Plumber',
      'avatar': AppImages.homeMarcusJohnson,
      'isVerified': true,
      'rating': 4.9,
      'reviews': 127,
      'pricePerHour': '\$35/hr',
      'distanceOrTime': '1.2 km',
    },
    {
      'name': 'Sarah Williams',
      'role': 'Cleaner',
      'avatar': AppImages.homeSarahWilliams,
      'isVerified': true,
      'rating': 4.8,
      'reviews': 89,
      'pricePerHour': '\$28/hr',
      'distanceOrTime': '2.1 km',
    },
    {
      'name': 'Daniel Carter',
      'role': 'Electrician',
      'avatar': AppImages.homeDanielCarter,
      'isVerified': true,
      'rating': 4.7,
      'reviews': 203,
      'pricePerHour': '\$45/hr',
      'distanceOrTime': '3.4 km',
    },
  ].obs;

  final selectedCity = 'San Francisco'.obs;
  final selectedAddress = '75 Wellington Street, ON K1A 0A2'.obs;

  void updateAddress(String city, String address) {
    selectedCity.value = city;
    selectedAddress.value = address;
  }
}

