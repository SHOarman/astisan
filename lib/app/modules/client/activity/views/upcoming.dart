import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/activity_controller.dart';
import 'wideget/booking_list_view.dart';

class Upcoming extends GetView<ActivityController> {
  const Upcoming({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BookingListView(
      bookings: controller.upcomingBookings.toList(),
      emptyMessage: AppStrings.noUpcomingBookings.tr,
    ));
  }
}
