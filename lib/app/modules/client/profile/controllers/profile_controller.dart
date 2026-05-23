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
    'bookings': 0,
    'reviews': 0,
    'rating': 0.0,
  }.obs;

  final menuItems = [
    {
      'title': AppStrings.language.tr,
      'subtitle': AppStrings.englishFrench.tr,
      'icon': Icons.language,
      'color': const Color(0xFF6C63FF),
    },
    {
      'title': AppStrings.orderHistory.tr,
      'subtitle': '4 ${AppStrings.completedBookingsCount.tr}',
      'icon': Icons.receipt_long,
      'color': const Color(0xFF6C63FF),
    },
    {
      'title': AppStrings.savedAddresses.tr,
      'subtitle': '2 ${AppStrings.addressesSavedCount.tr}',
      'icon': Icons.location_on_outlined,
      'color': const Color(0xFF9C27B0),
    },
    {
      'title': AppStrings.paymentMethods.tr,
      'subtitle': AppStrings.visaCardDesc.tr,
      'icon': Icons.credit_card,
      'color': const Color(0xFF4CAF50),
    },
    {
      'title': AppStrings.emergencySupport.tr,
      'subtitle': AppStrings.emergencySupportSub.tr,
      'icon': Icons.chat_bubble_outline,
      'color': const Color(0xFFF44336),
    },
    {
      'title': AppStrings.referAndGetBonus.tr,
      'subtitle': AppStrings.referAndGetBonusSub.tr,
      'icon': Icons.local_activity_outlined,
      'color': const Color(0xFFFFC107),
    },
    {
      'title': AppStrings.privacySecurity.tr,
      'subtitle': AppStrings.passwordSecured.tr,
      'icon': Icons.shield_outlined,
      'color': const Color(0xFF2196F3),
    },
    {
      'title': AppStrings.helpSupport.tr,
      'subtitle': AppStrings.faqContactUs.tr,
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
      final String? role = prefs.getString('role');

      if (token == null || token.isEmpty) {
        userName.value = 'Not Logged In';
        return;
      }

      final String cleanToken = token.trim().replaceAll('"', '');
      final bool isWorker = (role != 'client');
      final String endpoint = isWorker ? ApiServices.artisan_profile : ApiServices.client_profile;

      final response = await http.get(
        Uri.parse(endpoint),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Authorization': 'Bearer $cleanToken',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        userName.value = data['full_name'] ?? 'No Name';
        userEmail.value = data['email'] ?? 'No Email';
        userPhone.value = data['phone'] ?? 'No Phone';
        userProfileImage.value = ApiServices.formatImageUrl(data['profile_picture']?.toString());
        await prefs.setString('user_profile_pic', userProfileImage.value);

        if (isWorker && data['artisan_profile'] != null) {
          final artisan = data['artisan_profile'];
          stats['bookings'] = artisan['total_jobs_done'] ?? 0;
          stats['reviews'] = 0;
          stats['rating'] = double.tryParse(artisan['average_rating']?.toString() ?? '0.0') ?? 0.0;
        } else if (!isWorker) {
          fetchClientStats();
        }
      } else if (response.statusCode == 403) {
        final String alternativeUrl = isWorker ? ApiServices.client_profile : ApiServices.artisan_profile;
        final altResponse = await http.get(
          Uri.parse(alternativeUrl),
          headers: { 'Accept-Language': ApiServices.currentLanguage, 'Authorization': 'Bearer $cleanToken', 'Accept': 'application/json'},
        ).timeout(const Duration(seconds: 15));

        if (altResponse.statusCode == 200) {
          final altRole = isWorker ? 'client' : 'worker';
          prefs.setString('role', altRole);

          final data = json.decode(altResponse.body);
          userName.value = data['full_name'] ?? 'No Name';
          userEmail.value = data['email'] ?? 'No Email';
          userPhone.value = data['phone'] ?? 'No Phone';
          userProfileImage.value = ApiServices.formatImageUrl(data['profile_picture']?.toString());
          await prefs.setString('user_profile_pic', userProfileImage.value);
        } else {
          userName.value = 'Permission Denied (403)';
          Get.snackbar('Access Denied'.tr, 'Your account does not have permission for this role.'.tr, backgroundColor: Colors.orange, colorText: Colors.white);
        }
      } else {
        userName.value = 'Error ${response.statusCode}';
      }
    } catch (e) {
      userName.value = 'Error Loading Profile';
    }
  }

  Future<void> fetchClientStats() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) return;
      token = token.trim().replaceAll('"', '');
      
      // Fetch bookings to count completed ones
      final bookingResp = await http.get(
        Uri.parse("${ApiServices.baseurl}/api/bookings/client/"),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );
      if (bookingResp.statusCode == 200) {
        final data = jsonDecode(bookingResp.body);
        final results = (data is Map && data.containsKey('results')) ? data['results'] as List : (data is List ? data : []);
        int completedCount = results.where((b) => (b['status'] ?? '').toString().toLowerCase() == 'completed').length;
        stats['bookings'] = completedCount;
      }
      
      // Fetch reviews
      final reviewResp = await http.get(
        Uri.parse("${ApiServices.baseurl}/api/reviews/client/"),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );
      if (reviewResp.statusCode == 200) {
        final data = jsonDecode(reviewResp.body);
        stats['reviews'] = data['count'] ?? 0;
        final results = (data is Map && data.containsKey('results')) ? data['results'] as List : (data is List ? data : []);
        if (results.isNotEmpty) {
           double sum = 0;
           for(var r in results) {
               sum += double.tryParse(r['rating']?.toString() ?? '0') ?? 0;
           }
           stats['rating'] = sum / results.length;
        } else {
           stats['rating'] = 0.0;
        }
      }
      stats.refresh();
    } catch(e) {
      print("Error fetching client stats: $e");
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
    } else if (title == AppStrings.referAndGetBonus.tr || title == 'Refer & Get Bonus') {
      Get.toNamed(Routes.GET_BONUS);
    } else if (title == AppStrings.emergencySupport.tr || title == 'Emergency Support') {
      Get.toNamed(Routes.emergency_support);
    } else if (title == AppStrings.language.tr || title == 'Language') {
      Get.toNamed(Routes.language);
    }
  }

  void editProfile() {
    Get.toNamed(Routes.EDIT_PROFILE);
  }

  Future<void> signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(Routes.LOGIN);
  }
}