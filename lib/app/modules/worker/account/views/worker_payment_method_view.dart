import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/components/payment_card_tile.dart';
import '../../../../core/components/dashed_container.dart';
import '../controllers/worker_payment_method_controller.dart';

class WorkerPaymentMethodView extends GetView<WorkerPaymentMethodController> {
  const WorkerPaymentMethodView({super.key});

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
        padding: const EdgeInsets.all(24.0),
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
            Obx(() => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.savedCards.length,
              itemBuilder: (context, index) {
                final card = controller.savedCards[index];
                return PaymentCardTile(
                  type: card['type'],
                  number: card['number'],
                  expiry: card['expiry'],
                  imagePath: card['imagePath'],
                  onTap: () => controller.editCard(card),
                );
              },
            )),
            const SizedBox(height: 8.0),
            _buildAddNewButton(),
            const SizedBox(height: 48.0),
            _buildSecurityBadges(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewButton() {
    return GestureDetector(
      onTap: controller.addNewPaymentMethod,
      child: DashedContainer(
        color: AppColors.primary.withOpacity(0.3),
        dashWidth: 4,
        dashSpace: 4,
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 22),
            const SizedBox(width: 10.0),
            Text(
              "Add New Payment Method",
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityBadges() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: [
          _buildBadge(Icons.verified_user, "SSL Secured", Colors.green),
          _buildBadge(Icons.security, "256-bit Encryption", Colors.blue),
          _buildBadge(Icons.lock, "PCI Compliant", Colors.grey),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 11.0,
            color: AppColors.greyText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
