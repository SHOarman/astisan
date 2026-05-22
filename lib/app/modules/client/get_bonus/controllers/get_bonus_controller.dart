import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';

class GetBonusController extends GetxController {
  final referralCode = ''.obs;
  final totalReferrals = 0.obs;
  final referralHistory = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.replaceAll('"', '').trim();

      // Fetch code
      final codeRes = await http.get(
        Uri.parse('${ApiServices.baseurl}/api/user/referral/code/'),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );
      if (codeRes.statusCode == 200) {
        final data = json.decode(codeRes.body);
        referralCode.value = data['referral_code'] ?? '';
        totalReferrals.value = data['total_referrals'] ?? 0;
      }

      // Fetch history
      final historyRes = await http.get(
        Uri.parse('${ApiServices.baseurl}/api/user/referral/history/'),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );
      if (historyRes.statusCode == 200) {
        final List<dynamic> data = json.decode(historyRes.body);
        referralHistory.assignAll(data.cast<Map<String, dynamic>>());
      }
    } catch (e) {
      print('Error fetching referral data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void copyReferralCode() {
    if (referralCode.value.isEmpty) return;
    Clipboard.setData(ClipboardData(text: referralCode.value));
    Get.snackbar(
      'Copied',
      'Referral code copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void inviteFriend() {
    // Logic to share referral code
  }
}
