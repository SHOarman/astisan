import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/components/transaction_receipt_card.dart';
import '../controllers/payment_success_controller.dart';

class PaymentSuccessView extends GetView<PaymentSuccessController> {
  const PaymentSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PaymentSuccessController());
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.paymentSuccessful.tr,
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildSuccessAnimation(),
            SizedBox(height: 32.0),
            _buildReceiptCard(),
            SizedBox(height: 24.0),
            _buildRatingPrompt(),
            SizedBox(height: 32.0),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessAnimation() {
    return Column(
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            color: AppColors.statusCompletedBg,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, color: AppColors.statusCompletedText, size: 50.0),
        ),
        SizedBox(height: 24.0),
        Row(
          children: [
            Text(
              AppStrings.paymentSuccessful.tr,
              style: GoogleFonts.poppins(
                color: AppColors.textColor,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8,),
            Image.asset(
              AppImages.homeFirstServicePromo,
              width: 28.0,
              height: 28.0,
              fit: BoxFit.contain,
            )
          ],
        ),

        SizedBox(height: 12.0),
        Text(
          AppStrings.paymentMsg.tr.replaceFirst('%s', '\$121.25'),
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: AppColors.greyText,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptCard() {
    return TransactionReceiptCard(
      transactionId: 'TXN-2026-FX4821-7283',
      details: {
        'Service': 'Pipe Repair',
        'Artisan': 'James Wilson',
        'Date': 'April 7, 2026',
        'Time': '10:18 AM - 11:54 AM',
        'Payment Method': 'Visa...4242',
      },
      amountPaid: '\$121.25',
    );
  }

  Widget _buildRatingPrompt() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.ratingPromptBg,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.ratingStar.withAlpha(20)),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: AppColors.ratingStar, size: 24.0),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.howWasExperience.tr,
                  style: GoogleFonts.poppins(
                    color: AppColors.ratingStar.withAlpha(150), // Brownish looking orange in image
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Rate James Wilson and the service',
                  style: GoogleFonts.poppins(
                    color: AppColors.ratingStar.withAlpha(150),
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: controller.rateNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ratingStar,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
            child: Text(
              AppStrings.rateNow.tr,
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        OutlinedButton(
          onPressed: controller.downloadOrPrintReceipt,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56.0),
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.download, color: AppColors.primary, size: 20.0),
              const SizedBox(width: 8.0),
              Text(
                AppStrings.downloadReceipt.tr,
                style: GoogleFonts.poppins(
                  color: AppColors.textColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Obx(() => ElevatedButton(
          onPressed: controller.isLoadingHome.value ? null : controller.backToHome,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 56.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            elevation: 0,
            disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
          ),
          child: controller.isLoadingHome.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.home_outlined, color: Colors.white, size: 20.0),
                    const SizedBox(width: 8.0),
                    Text(
                      AppStrings.backToHome.tr,
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        )),
      ],
    );
  }
}

