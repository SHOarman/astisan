import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/components/custom_stepper.dart';
import '../../../../core/components/fixed_bottom_action_bar.dart';
import '../../../../core/routes/app_routes.dart';
import '../controllers/booking_controller.dart';

class ConfirmBookingView extends GetView<BookingController> {
  const ConfirmBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.booking.tr,
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            // Because we're in a separate route, previous step is either back to camera or note.
            // We'll let Get.back take them to the Camera screen to retake, or handle properly.
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 0.0,
            ),
            child: const CustomStepper(currentStep: 5),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Obx(() {
                final artisan = controller.selectedArtisan;
                final address = controller.addresses.isNotEmpty 
                    ? controller.addresses[controller.selectedAddressIndex.value] 
                    : {'address': 'No address selected'};
                final date = controller.dates[controller.selectedDateIndex.value];
                final time = controller.selectedTime.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.bookingSummary.tr,
                      style: GoogleFonts.poppins(
                        color: AppColors.textColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Service / Category Card (Replacing Artisan Card)
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(20),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: const Icon(Icons.category, color: AppColors.primary, size: 28.0),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.serviceData['title'] ?? 'Service Selection',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.textColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Matching you with the best artisan',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.greyText,
                                    fontSize: 12.0,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Price Range: ${controller.serviceFeeString}',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primary,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Date
                    _buildSummaryItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Date',
                      value: '${date['day']}, ${date['month']} ${date['date']}',
                    ),
                    const SizedBox(height: 16.0),
                    // Time
                    _buildSummaryItem(
                      icon: Icons.access_time,
                      label: 'Time',
                      value: '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                    ),
                    const SizedBox(height: 16.0),
                    // Address
                    _buildSummaryItem(
                      icon: Icons.location_on_outlined,
                      label: AppStrings.address.tr,
                      value: address['address'],
                    ),
                    const SizedBox(height: 16.0),
                    // Notes
                    _buildSummaryItem(
                      icon: Icons.description_outlined,
                      label: AppStrings.notes.tr,
                      value: controller.notesController.text.isEmpty
                          ? 'No additional notes'
                          : controller.notesController.text,
                    ),
                    const SizedBox(height: 32.0),

                    // Cost Breakdown
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F5FA),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: const Color(0xFFE2EBF5)),
                      ),
                      child: Column(
                        children: [
                          _buildCostRow(
                            AppStrings.serviceFee.tr, 
                            controller.serviceFeeString
                          ),
                          const SizedBox(height: 12.0),
                          _buildCostRow(AppStrings.platformFee.tr, controller.platformFeeString),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(color: Color(0xFFE2EBF5), thickness: 1.0),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.estimatedTotal.tr,
                                style: GoogleFonts.poppins(
                                  color: AppColors.textColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                controller.estimatedTotalString,
                                style: GoogleFonts.poppins(
                                  color: AppColors.statusCompletedText,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          FixedBottomActionBar(
            buttonText: AppStrings.confirmBooking.tr ?? 'Confirm Booking',
            onPressed: () {
              Get.toNamed(Routes.FINDING_ARTISAN, arguments: {
                'service': controller.serviceData.value,
                'artisan': controller.selectedArtisan.value,
                'image': controller.capturedImagePath.value,
              });
            },
          ),
        ],
      ),
    );
  }
  Widget _buildPlaceholder() {
    return Container(
      width: 50.0,
      height: 50.0,
      color: AppColors.primary.withAlpha(20),
      child: const Icon(Icons.person, color: AppColors.primary),
    );
  }

  Widget _buildSummaryItem({required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20.0),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 12.0)),
                const SizedBox(height: 4.0),
                Text(value, style: GoogleFonts.poppins(color: AppColors.textColor, fontSize: 14.0, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 14.0)),
        Text(amount, style: GoogleFonts.poppins(color: AppColors.textColor, fontSize: 14.0, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
