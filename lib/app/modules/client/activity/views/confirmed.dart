import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/activity_controller.dart';
import 'wideget/booking_list_view.dart';

class Confirmed extends GetView<ActivityController> {
  const Confirmed({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BookingListView(
      bookings: controller.confirmedBookings.toList(),
      emptyMessage: AppStrings.noConfirmedBookings.tr,
    ));
  }
}
