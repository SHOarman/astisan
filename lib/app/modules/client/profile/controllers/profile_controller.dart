import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import 'package:artisan/app/core/constants/static/app_images.dart';
import '../../../../core/constants/static/app_strings.dart';

class ProfileController extends GetxController {
  final userName = 'Alex Thompson'.obs;
  final userEmail = 'alex.thompson@email.com'.obs;
  final userPhone = '+1 (555) 234-5678'.obs;

  final stats = {
    'bookings': 4,
    'reviews': 3,
    'rating': 4.8,
  }.obs;

  final menuItems = [
    {
      'title': AppStrings.orderHistory.tr,
      'subtitle': '4 completed bookings',
      'icon': Icons.receipt_long,
      'color': const Color(0xFF6C63FF),
    },
    {
      'title': AppStrings.savedAddresses.tr,
      'subtitle': '2 addresses saved',
      'icon': Icons.location_on_outlined,
      'color': const Color(0xFF9C27B0),
    },
    {
      'title': AppStrings.paymentMethods.tr,
      'subtitle': 'Visa **** 4242',
      'icon': Icons.credit_card,
      'color': const Color(0xFF4CAF50),
    },
    {
      'title': 'Refer & Get Bonus',
      'subtitle': 'Invite friends, earn €15',
      'icon': Icons.local_activity_outlined,
      'color': const Color(0xFFFFC107),
    },
    {
      'title': AppStrings.privacySecurity.tr,
      'subtitle': 'Password secured',
      'icon': Icons.shield_outlined,
      'color': const Color(0xFF2196F3),
    },
    {
      'title': AppStrings.helpSupport.tr,
      'subtitle': 'FAQ, contact us',
      'icon': Icons.help_outline,
      'color': const Color(0xFF9E9E9E),
    },
  ].obs;

  void navigateTo(String title) {
    if (title == AppStrings.savedAddresses.tr) {
      Get.toNamed(Routes.SAVED_ADDRESSES);
    } else if (title == AppStrings.paymentMethods.tr) {
      Get.toNamed(Routes.PAYMENT_METHOD);
    } else if (title == AppStrings.helpSupport.tr) {
      Get.toNamed(Routes.HELP_SUPPORT);
    } else if (title == AppStrings.privacySecurity.tr) {
      Get.toNamed(Routes.SECURITY);
    } else if (title == AppStrings.orderHistory.tr) {
      Get.toNamed(Routes.ORDER_HISTORY);
    } else if (title == 'Refer & Get Bonus') {
      Get.toNamed(Routes.GET_BONUS);
    }
    // Add other routes as needed
  }

  void editProfile() {
    Get.toNamed(Routes.EDIT_PROFILE);
  }

  final recentBookings = <Map<String, dynamic>>[
    {
      'title': 'Pipe Leak Repair',
      'date': 'Apr 7, 2026',
      'price': '\$100',
      'status': AppStrings.completed.tr,
      'icon': AppImages.iconWrench,
    },
    {
      'title': 'Deep House Cleaning',
      'date': 'Mar 22, 2026',
      'price': '\$85',
      'status': AppStrings.completed.tr,
      'icon': AppImages.iconCleaningService,
    },
    {
      'title': 'Electrical Wiring',
      'date': 'Mar 10, 2026',
      'price': '\$160',
      'status': AppStrings.completed.tr,
      'icon': AppImages.subElectricalFix,
    },
  ].obs;

  void signOut() {
    Get.offAllNamed(Routes.LOGIN);
  }
}

