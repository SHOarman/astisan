import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GetBonusController extends GetxController {
  final referralCode = 'FIX65567GO';

  void copyReferralCode() {
    Clipboard.setData(ClipboardData(text: referralCode));
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
