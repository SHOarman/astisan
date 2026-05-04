import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/components/custom_stepper.dart';
import '../../../../core/components/fixed_bottom_action_bar.dart';
import '../../../../core/components/selectable_date_card.dart';
import '../../../../core/components/selectable_time_chip.dart';
import '../../../../core/components/address_selection_card.dart';
import '../controllers/booking_controller.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BookingController());
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.booking.tr,
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
          onPressed: controller.previousStep,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Obx(
              () => CustomStepper(currentStep: controller.currentStep.value),
            ),
          ),
          Expanded(
            child: Obx(() {
              switch (controller.currentStep.value) {
                case 1:
                  return _buildDateAndTimeStep();
                case 2:
                  return _buildAddressStep();
                case 3:
                  return _buildNotesStep();
                default:
                  return const SizedBox.shrink();
              }
            }),
          ),
          FixedBottomActionBar(
            buttonText: AppStrings.continueBtn.tr,
            onPressed: controller.nextStep,
          ),
        ],
      ),
    );
  }

  Widget _buildDateAndTimeStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.primary,
                      size: 20.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      AppStrings.selectDate.tr,
                      style: GoogleFonts.poppins(
                        color: AppColors.textColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(
                    () => Row(
                      children: List.generate(controller.dates.length, (index) {
                        final date = controller.dates[index];
                        return SelectableDateCard(
                          day: date['day']!,
                          date: date['date']!,
                          month: date['month']!,
                          isSelected:
                              controller.selectedDateIndex.value == index,
                          onTap: () =>
                              controller.selectedDateIndex.value = index,
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.0),
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: AppColors.primary,
                      size: 20.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      AppStrings.selectTime.tr,
                      style: GoogleFonts.poppins(
                        color: AppColors.textColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: controller.times.length,
                  itemBuilder: (context, index) {
                    return Obx(
                      () => SelectableTimeChip(
                        time: controller.times[index],
                        isSelected: controller.selectedTimeIndex.value == index,
                        onTap: () => controller.selectedTimeIndex.value = index,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.serviceAddress.tr,
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            height: 160.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Stack(
              children: [
                // Lines to simulate map streets
                Positioned.fill(child: CustomPaint(painter: MapLinesPainter())),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white,
                            width: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(50),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: AppColors.white,
                          size: 20.0,
                        ),
                      ),
                      Container(
                        width: 2.0,
                        height: 14.0,
                        color: AppColors.primary.withAlpha(80),
                      ),
                      Text(
                        'New York, NY',
                        style: GoogleFonts.poppins(
                          color: AppColors.primary.withAlpha(150),
                          fontSize: 10.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 12.0,
                  left: 12.0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary,
                        size: 16.0,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        AppStrings.useCurrentLocation.tr,
                        style: GoogleFonts.poppins(
                          color: AppColors.primary,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.0),
          Text(
            AppStrings.savedAddresses.tr,
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.0),
          Obx(
            () => Column(
              children: List.generate(controller.addresses.length, (index) {
                final address = controller.addresses[index];
                return AddressSelectionCard(
                  title: address['title'] as String,
                  address: address['address'] as String,
                  isDefault: address['isDefault'] as bool,
                  isSelected: controller.selectedAddressIndex.value == index,
                  onTap: () => controller.selectedAddressIndex.value = index,
                );
              }),
            ),
          ),
          SizedBox(height: 8.0),
          // Add new address button dotted
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: AppColors.primary.withAlpha(100),
                style: BorderStyle.none,
              ),
            ),
            child: CustomPaint(
              painter: DashedBorderPainter(
                color: AppColors.primary.withAlpha(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(4.0),
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: AppColors.primary,
                      size: 16.0,
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Text(
                    AppStrings.addNewAddress.tr,
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.additionalNotes.tr,
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            AppStrings.addNotesHint.tr,
            style: GoogleFonts.poppins(
              color: AppColors.greyText,
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: controller.notesController,
              maxLines: 6,
              maxLength: 500,
              decoration: InputDecoration(
                hintText:
                    'Describe your issue, specific requirements, or any other details that would help the artisan...',
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.greyText,
                  fontSize: 14.0,
                ),
                border: InputBorder.none,
                counterText: '', // hide default counter
              ),
              style: GoogleFonts.poppins(
                color: AppColors.textColor,
                fontSize: 14.0,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => Text(
                '${controller.notesLength}/500 characters',
                style: GoogleFonts.poppins(
                  color: AppColors.greyText,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 24.0),
          Text(
            AppStrings.quickAdd.tr,
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.0),
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: controller.quickNotes
                .map(
                  (note) => GestureDetector(
                    onTap: () => controller.addQuickNote(note),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(50),
                        ),
                      ),
                      child: Text(
                        note,
                        style: GoogleFonts.poppins(
                          color: AppColors.primary,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// Simple painters for custom shapes
class DashedBorderPainter extends CustomPainter {
  final Color color;
  DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    var path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(16.0),
      ),
    );

    // Simplistic dash effect representation using pathMetrics (often requires external libs, but we can draw basic rects)
    // For exact dashed border, usually package 'dotted_border' is used. I'll just draw a solid border fallback if strict dash is tough in pure canvas, but here is a simple line dash.
    Path dashPath = Path();
    var metrics = path.computeMetrics();
    for (var m in metrics) {
      double distance = 0.0;
      while (distance < m.length) {
        dashPath.addPath(m.extractPath(distance, distance + 5), Offset.zero);
        distance += 10;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MapLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height * 0.6),
      Offset(size.width, size.height * 0.6),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.4, 0),
      Offset(size.width * 0.4, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
