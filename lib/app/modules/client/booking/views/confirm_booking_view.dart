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
              child: Column(
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
                  // Artisan Card
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset(
                            AppImages.homeSarahWilliams,
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'James Wilson',
                                style: GoogleFonts.poppins(
                                  color: AppColors.textColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Plumbing Expert',
                                style: GoogleFonts.poppins(
                                  color: AppColors.greyText,
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: AppColors.ratingStar,
                                    size: 14.0,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    '4.9',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.textColor,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.statusCompletedText,
                          size: 24.0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Date
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
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.primary,
                            size: 20.0,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.dateTime.tr.split(' ')[0],
                              style: GoogleFonts.poppins(
                                color: AppColors.greyText,
                                fontSize: 12.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Tue, Apr 14',
                              style: GoogleFonts.poppins(
                                color: AppColors.textColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Time
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
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.access_time,
                            color: AppColors.primary,
                            size: 20.0,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time',
                              style: GoogleFonts.poppins(
                                color: AppColors.greyText,
                                fontSize: 12.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '10:00 AM',
                              style: GoogleFonts.poppins(
                                color: AppColors.textColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Address
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
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.primary,
                            size: 20.0,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.address.tr,
                                style: GoogleFonts.poppins(
                                  color: AppColors.greyText,
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '123 Main Street, Apt 4B, New York, ...',
                                style: GoogleFonts.poppins(
                                  color: AppColors.textColor,
                                  fontSize: 14.0,
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
                  // Notes
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
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.description_outlined,
                            color: AppColors.primary,
                            size: 20.0,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.notes.tr,
                                style: GoogleFonts.poppins(
                                  color: AppColors.greyText,
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                controller.notesController.text.isEmpty
                                    ? 'No additional notes'
                                    : controller.notesController.text,
                                style: GoogleFonts.poppins(
                                  color: AppColors.textColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  // Cost Breakdown
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFF0F5FA,
                      ), // Subtle blueish background
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: const Color(0xFFE2EBF5)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.serviceFee.tr ?? 'Service fee',
                              style: GoogleFonts.poppins(
                                color: AppColors.greyText,
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              '\$65.00',
                              style: GoogleFonts.poppins(
                                color: AppColors.textColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.platformFee.tr ?? 'Platform fee',
                              style: GoogleFonts.poppins(
                                color: AppColors.greyText,
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              '\$5.00',
                              style: GoogleFonts.poppins(
                                color: AppColors.textColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Divider(
                            color: Color(0xFFE2EBF5),
                            thickness: 1.0,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.estimatedTotal.tr ?? 'Estimated Total',
                              style: GoogleFonts.poppins(
                                color: AppColors.textColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '\$70.00',
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
              ),
            ),
          ),
          FixedBottomActionBar(
            buttonText: AppStrings.confirmBooking.tr ?? 'Confirm Booking',
            onPressed: () {
              Get.toNamed(Routes.FINDING_ARTISAN, arguments: {
                'skip_searching_state': true,
              });
            },
          ),
        ],
      ),
    );
  }
}
