import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PaymentController());
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.payment.tr,
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: AppColors.timelineActive.withAlpha(20),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: AppColors.timelineActive.withAlpha(50)),
            ),
            child: Center(
              child: Row(
                children: [
                  Container(
                    width: 6.0,
                    height: 6.0,
                    decoration: const BoxDecoration(
                      color: AppColors.timelineActive,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    AppStrings.live.tr,
                    style: GoogleFonts.poppins(
                      color: AppColors.timelineActive,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPaymentHeader(),
                  SizedBox(height: 24.0),
                  _buildTotalDueCard(),
                  SizedBox(height: 16.0),
                  _buildCostSummary(),
                  SizedBox(height: 24.0),
                  _buildCardForm(),
                  SizedBox(height: 24.0),
                  _buildSecurityBadges(),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Pay Now >',
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.payment.tr,
              style: GoogleFonts.poppins(
                color: AppColors.textColor,
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.lock_outline,
                  color: AppColors.timelineActive,
                  size: 16.0,
                ),
                SizedBox(width: 4.0),
                Text(
                  AppStrings.secured.tr,
                  style: GoogleFonts.poppins(
                    color: AppColors.timelineActive,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        Text(
          AppStrings.securePaymentPortal.tr,
          style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 14.0),
        ),
      ],
    );
  }

  Widget _buildTotalDueCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.totalAmountDue.tr,
            style: GoogleFonts.poppins(
              color: AppColors.white.withAlpha(180),
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            '\$100.00',
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 40.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Job #FX-2024-0892 Â· Pipe Leak Repair',
            style: GoogleFonts.poppins(
              color: AppColors.white.withAlpha(150),
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostSummary() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.costBreakdown.tr,
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.0),
          _buildSummaryRow('Service (Pipe Leak Repair)', '\$95.00'),
          SizedBox(height: 12.0),
          _buildSummaryRow(AppStrings.platformFee.tr, '\$5.00'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: AppColors.border),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.total.tr,
                style: GoogleFonts.poppins(
                  color: AppColors.textColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '\$100.00',
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 14.0),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCardForm() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.cardDetails.tr,
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.0),
          _buildSavedCardItem(
            iconPath:
                'assets/images/visa.png', // Temporary path, replace if needed
            cardName: 'Visa •••••25544',
            expiry: 'Expires 11/26',
            isSelected: true,
            iconType: 'visa',
          ),
          SizedBox(height: 16.0),
          _buildSavedCardItem(
            iconPath:
                'assets/images/master.png', // Temporary path, replace if needed
            cardName: 'Master •••••25544',
            expiry: 'Expires 11/26',
            isSelected: false,
            iconType: 'master',
          ),
        ],
      ),
    );
  }

  Widget _buildSavedCardItem({
    required String iconPath,
    required String cardName,
    required String expiry,
    required bool isSelected,
    required String iconType,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2.0 : 1.0,
        ),
      ),
      child: Row(
        children: [
          // Simulated Icon since we may not have actual visa/master images in assets
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: iconType == 'visa'
                  ? Colors.blue.withAlpha(20)
                  : Colors.red.withAlpha(20),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              iconType == 'visa' ? 'VISA' : 'MASTER',
              style: GoogleFonts.poppins(
                color: iconType == 'visa' ? Colors.blue : Colors.red,
                fontSize: 12.0,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardName,
                  style: GoogleFonts.poppins(
                    color: AppColors.textColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  expiry,
                  style: GoogleFonts.poppins(
                    color: AppColors.greyText,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 6.0 : 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String hint,
    TextEditingController ctr, {
    IconData? icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: ctr,
        decoration: InputDecoration(
          icon: icon != null
              ? Icon(icon, color: AppColors.greyText, size: 20.0)
              : null,
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            color: AppColors.greyText.withAlpha(150),
            fontSize: 14.0,
          ),
          border: InputBorder.none,
        ),
        style: GoogleFonts.poppins(color: AppColors.textColor, fontSize: 14.0),
      ),
    );
  }

  Widget _buildSecurityBadges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBadge(Icons.lock, 'SSL Secured'),
        SizedBox(width: 12.0),
        _buildBadge(Icons.verified_user, '256-bit Encryption'),
        SizedBox(width: 12.0),
        _buildBadge(Icons.check, 'PCI Compliant'),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.greyText.withAlpha(150), size: 12.0),
        SizedBox(width: 4.0),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.greyText.withAlpha(150),
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}
