import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/components/payment_card_tile.dart';
import '../controllers/payment_method_controller.dart';

import '../../../../core/components/dashed_container.dart';

class PaymentMethodView extends GetView<PaymentMethodController> {
  const PaymentMethodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Payment Method",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Saved Card",
              style: GoogleFonts.poppins(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 16.0),
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.savedCards.length,
                itemBuilder: (context, index) {
                  final card = controller.savedCards[index];
                  return PaymentCardTile(
                    type: card['type'],
                    number: card['number'],
                    expiry: card['expiry'],
                    imagePath: card['image'],
                    onTap: () {},
                  );
                },
              ),
            ),
            const SizedBox(height: 24.0),
            _buildAddNewButton(),
            const SizedBox(height: 32.0),
            _buildSecurityBadges(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewButton() {
    return GestureDetector(
      onTap: controller.addPaymentMethod,
      child: DashedContainer(
        color: const Color(0xFFD1D5DB),
        dashWidth: 4,
        dashSpace: 4,
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: Color(0xFF374B71), size: 22),
            const SizedBox(width: 10.0),
            Text(
              "Add New Payment Method",
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF374B71),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityBadges() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 24,
      runSpacing: 8,
      children: [
        _buildBadge(Icons.lock, "SSL Secured"),
        _buildBadge(Icons.shield_outlined, "256-bit Encryption"),
        _buildBadge(Icons.check, "PCI Compliant"),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.ratingStar,
        ), // Mockup shows gold-ish icons? Actually light grey/beige in some mockups, but I'll use a subtle color.
        const SizedBox(width: 6.0),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 10.0,
            color: AppColors.greyText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
