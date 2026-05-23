import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
          AppStrings.bookingInfo.tr,
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
                case 5:
                  return _buildConfirmStep();
                default:
                  return const SizedBox.shrink();
              }
            }),
          ),
          Obx(() => FixedBottomActionBar(
            buttonText: controller.currentStep.value == 5 ? AppStrings.confirm.tr : AppStrings.continueBtn.tr,
            isLoading: controller.isSubmittingBooking.value,
            onPressed: controller.isSubmittingBooking.value ? null : controller.nextStep,
          )),
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
                SizedBox(
                  height: 160,
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: GoogleFonts.poppins(
                          color: AppColors.textColor,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: controller.selectedTime.value,
                      onDateTimeChanged: (DateTime newTime) {
                        controller.selectedTime.value = newTime;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
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
                Positioned.fill(child: CustomPaint(painter: MapLinesPainter())),

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
                () {
              if (controller.isLoadingAddresses.value) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ));
              }

              if (controller.addresses.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      AppStrings.noSavedAddresses.tr,
                      style: GoogleFonts.poppins(color: AppColors.greyText),
                    ),
                  ),
                );
              }

              return Column(
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
              );
            },
          ),
          SizedBox(height: 8.0),
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
                hintText: AppStrings.describeIssueHint.tr,
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.greyText,
                  fontSize: 14.0,
                ),
                border: InputBorder.none,
                counterText: '',
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
                '${controller.notesLength}/500 ${AppStrings.charactersLimit.tr}',
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

  Widget _buildConfirmStep() {
    final artisan = controller.selectedArtisan;
    final date = controller.dates[controller.selectedDateIndex.value];

    final time = controller.selectedTime.value;
    final ampm = time.hour >= 12 ? 'PM' : 'AM';
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final timeStr = '$hour:$minute $ampm';

    final address = controller.addresses.isNotEmpty
        ? controller.addresses[controller.selectedAddressIndex.value]['address']
        : AppStrings.noAddressSelected.tr;

    final notes = controller.notesController.text.isEmpty
        ? AppStrings.noAdditionalNotes.tr
        : controller.notesController.text;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.bookingSummary.tr,
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 18.0,
              fontWeight:
              FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.0),
          if (artisan.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: (artisan['avatar'] != null && artisan['avatar'].toString().isNotEmpty)
                        ? NetworkImage(artisan['avatar'])
                        : (artisan['profile_picture'] != null && artisan['profile_picture'].toString().isNotEmpty)
                        ? NetworkImage(artisan['profile_picture'])
                        : const AssetImage('assets/images/placeholder_avatar.png') as ImageProvider,
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artisan['name'] ?? artisan['full_name'] ?? 'Artisan',
                          style: GoogleFonts.poppins(
                            color: AppColors.textColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          artisan['role'] ?? artisan['occupation'] ?? 'Professional',
                          style: GoogleFonts.poppins(
                            color: AppColors.greyText,
                            fontSize: 14.0,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: AppColors.ratingStar, size: 16.0),
                            SizedBox(width: 4.0),
                            Text(
                              '${artisan['rating'] ?? '0.0'}',
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
                ],
              ),
            ),
          if (artisan.isNotEmpty) SizedBox(height: 16.0),
          _buildSummaryCard(Icons.calendar_today_outlined, AppStrings.date.tr, '${date['day']}, ${date['month']} ${date['date']}'),
          SizedBox(height: 12.0),
          _buildSummaryCard(Icons.access_time, AppStrings.time.tr, timeStr),
          SizedBox(height: 12.0),
          _buildSummaryCard(Icons.location_on_outlined, AppStrings.address.tr, address),
          SizedBox(height: 12.0),
          _buildSummaryCard(Icons.note_alt_outlined, AppStrings.notes.tr, notes),
          SizedBox(height: 24.0),
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(10),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              children: [
                _buildPriceRow(AppStrings.serviceFee.tr, controller.serviceFeeString),
                SizedBox(height: 8.0),
                _buildPriceRow(AppStrings.platformFee.tr, controller.platformFeeString),
                Divider(height: 24.0, color: AppColors.border),
                _buildPriceRow(AppStrings.estimatedTotal.tr, controller.estimatedTotalString, isTotal: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(IconData icon, String title, String value) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24.0),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: AppColors.greyText,
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  value,
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
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: isTotal ? AppColors.textColor : AppColors.greyText,
            fontSize: isTotal ? 16.0 : 14.0,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: isTotal ? AppColors.primary : AppColors.textColor,
            fontSize: isTotal ? 16.0 : 14.0,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

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