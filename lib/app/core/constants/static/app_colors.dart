import 'package:flutter/material.dart';

class AppColors {
  /// Primary Theme Color - Dark Blue
  static const Color primary = Color(0xFF1B457C);
  
  /// Base Text Color
  static const Color textColor = Color(0xFF0B0B0B);
  
  /// Secondary text color, unselected states, etc
  static const Color greyText = Color(0xFF8C8C8C);
  
  /// Page Indicator default color
  static const Color indicatorInactive = Color(0xFFE5E5E5);
  
  /// White Color
  static const Color white = Colors.white;
  
  /// Background Color
  static const Color background = Colors.white;

  /// Border colors for text fields and unselected cards
  static const Color border = Color(0xFFE0E0E0);

  /// Social button background color
  static const Color socialButtonBg = Color(0xFFF5F5F5);

  /// Checkbox active color
  static const Color checkboxActive = Color(0xFF1B457C);

  /// Error or destructive text color (used for resend code)
  static const Color errorText = Color(0xFFFF4B4B);

  // Phase 3 Colors
  static const Color statusCompletedText = Color(0xFF4CAF50);
  static const Color statusCompletedBg = Color(0xFFE8F5E9);
  static const Color statusCancelledText = Color(0xFFF44336);
  static const Color statusCancelledBg = Color(0xFFFFEBEE);
  static const Color ratingStar = Color(0xFFFFC107);
  static const Color bottomNavActiveBg = Color(0xFFE8EAF6);

  // Phase 4 Colors
  static const Color badgePopularBg = Color(0xFFFFF5E6);
  static const Color badgePopularText = Color(0xFFFF9800);
  static const Color stepperActive = Color(0xFF4CAF50);
  static const Color stepperInactive = Color(0xFFE0E0E0);

  // Phase 5 Colors
  static const Color chatBubbleSent = Color(0xFF2C599D); // Similar to primary but mapped if needed, Wait, image 1 chat sent bubble looks lighter blue? AppColors.primary is fine.
  static const Color chatBubbleReceived = Colors.white;
  static const Color timelineActive = Color(0xFF4CAF50);
  static const Color timelineCurrent = Color(0xFF1B457C);
  static const Color timelineInactive = Color(0xFFE0E0E0);
  static const Color radarRing = Color(0xFF4A7CBD); // Lighter blue for radar ring

  // Phase 6 Colors
  static const Color promoDiscountText = Color(0xFF4CAF50);
  static const Color receiptHeaderBg = Color(0xFF2B5292);
  static const Color ratingPromptBg = Color(0xFFFFF9E6);

  // Worker Role Colors
  static const Color onlineGreen = Color(0xFF4CAF50);
  static const Color urgentRed = Color(0xFFF44336);
  static const Color normalYellow = Color(0xFFFFC107);
  static const Color payoutBannerBg = Color(0xFFE8F5E9);
  static const Color payoutText = Color(0xFF2E7D32);
  static const Color warningBannerIcon = Color(0xFFF57C00);

  // Profile Phase Colors
  static const Color deleteButtonBg = Color(0xFFF87171);
  static const Color addressBadgeBg = Color(0xFFE8F5E9);
  static const Color addressBadgeText = Color(0xFF4CAF50);
}

