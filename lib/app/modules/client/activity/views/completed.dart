import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activity_controller.dart';
import 'wideget/booking_list_view.dart';

class Completed extends GetView<ActivityController> {
  const Completed({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BookingListView(
      bookings: controller.completedBookings.toList(),
      emptyMessage: "No completed bookings",
    ));
  }
}
