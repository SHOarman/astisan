import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:artisan/app/core/constants/static/app_images.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/Services/api_services.dart';

class ProfileController extends GetxController {
  final userName = 'Loading...'.obs;
  final userEmail = '...'.obs;
  final userPhone = '...'.obs;
  final userProfileImage = ''.obs;

  final stats = {
    'bookings': 4,
    'reviews': 3,
    'rating': 4.8,
  }.obs;

  final menuItems = [
    {
      'title': "Language",
      'subtitle': 'English, French',
      'icon': Icons.language,
      'color': const Color(0xFF6C63FF),
    },
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
      'title': 'Emergency Support',
      'subtitle': '24/7 AI & Admin chat',
      'icon': Icons.chat_bubble_outline,
      'color': const Color(0xFFF44336),
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

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        userName.value = 'Not Logged In';
        return;
      }

      final response = await http.get(
        Uri.parse(ApiServices.client_profile),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        userName.value = data['full_name'] ?? 'No Name';
        userEmail.value = data['email'] ?? 'No Email';
        userPhone.value = data['phone'] ?? 'No Phone';
        userProfileImage.value = ApiServices.formatImageUrl(data['profile_picture']?.toString());
      } else {
        userName.value = 'Error Loading Profile';
      }
    } catch (e) {
      userName.value = 'Error Loading Profile';
    }
  }

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
    } else if (title == 'Emergency Support') {
      Get.toNamed(Routes.emergency_support);
    } else if (title == 'Language') {
      Get.toNamed(Routes.language);
    }
  }

  void editProfile() {
    Get.toNamed(Routes.EDIT_PROFILE);
  }

  Future<void> signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(Routes.SIGN_UP);
  }
}