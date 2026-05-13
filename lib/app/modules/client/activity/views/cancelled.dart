import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activity_controller.dart';
import 'wideget/booking_list_view.dart';

class Cancelled extends GetView<ActivityController> {
  const Cancelled({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BookingListView(
      bookings: controller.cancelledBookings.toList(),
      emptyMessage: "No cancelled bookings",
    ));
  }
}
