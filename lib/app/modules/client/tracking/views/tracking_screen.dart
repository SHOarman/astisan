import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../controllers/tracking_controller.dart';

class TrackingScreen extends GetView<TrackingController> {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(TrackingController());

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 16),
            _buildProgressCard(),
            const SizedBox(height: 16),
            _buildTimelineCard(),
            const SizedBox(height: 16),
            _buildServiceDetailsCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  // --- APP BAR ---
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
        ),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        "Tracking",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5EE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA5D6BD)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAE79),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Live",
                    style: TextStyle(
                      color: Color(0xFF4CAE79),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- PROFILE SECTION ---
  Widget _buildProfileSection() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(controller.artisanImageUrl),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.artisanName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    "${controller.rating} · ${controller.profession}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.chat_bubble_outline,
              color: Color(0xFF34608D),
            ),
            onPressed: () => controller.goToChat(),
          ),
        ),
      ],
    );
  }

  // --- PROGRESS CARD ---
  Widget _buildProgressCard() {
    return _customCard(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: CircularProgressIndicator(
                  value: controller.progressPercent,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF34608D),
                  ),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  const Icon(Icons.build_outlined, color: Color(0xFF34608D)),
                  const SizedBox(height: 4),
                  Text(
                    "${controller.elapsedMinutes} min",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "Service In Progress",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(
            "Started at ${controller.jobStartTime} · ${controller.elapsedMinutes} min elapsed",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // --- TIMELINE CARD ---
  Widget _buildTimelineCard() {
    return _customCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Status Timeline",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          _buildTimelineStep(
            isLast: false,
            isCompleted: true,
            iconData: Icons.check,
            iconBgColor: const Color(0xFF57A783), // Green
            title: "Booking Confirmed",
            subtitle: "Your booking has been accepted",
            time: "09:45 AM",
          ),
          _buildTimelineStep(
            isLast: false,
            isCompleted: true,
            iconData: Icons.check,
            iconBgColor: const Color(0xFF57A783), // Green
            title: "On the Way",
            subtitle: "Artisan is heading to your location",
            time: "10:00 AM",
          ),
          _buildTimelineStep(
            isLast: false,
            isCompleted: false,
            isCurrent: true,
            iconData: Icons.build,
            iconBgColor: const Color(0xFF34608D), // Blue
            title: "Working",
            subtitle: "Service in progress at your location",
            time: "10:18 AM",
            extraWidget: Row(
              children: [
                const SizedBox(height: 24),
                _buildDot(),
                _buildDot(),
                _buildDot(),
                const SizedBox(width: 8),
                const Text(
                  "In progress...",
                  style: TextStyle(
                    color: Color(0xFF34608D),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _buildTimelineStep(
            isLast: true,
            isCompleted: false,
            iconData: Icons.celebration,
            iconBgColor: Colors.grey.shade100, // Greyed out
            iconColor: Colors.grey.shade500,
            title: "Completed",
            subtitle: "Service has been completed",
            time: "Pending",
            isFaded: true,
          ),
        ],
      ),
    );
  }

  // Helper for Timeline Steps
  Widget _buildTimelineStep({
    required bool isLast,
    required bool isCompleted,
    bool isCurrent = false,
    required IconData iconData,
    required Color iconBgColor,
    Color iconColor = Colors.white,
    required String title,
    required String subtitle,
    required String time,
    Widget? extraWidget,
    bool isFaded = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon and Line
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: iconColor, size: 18),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: isCurrent ? 50 : 40,
                color: isCompleted
                    ? const Color(0xFF57A783)
                    : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Text Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isFaded ? Colors.grey : Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: isFaded ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              ?extraWidget,
              const SizedBox(height: 16), // Bottom padding per step
            ],
          ),
        ),
      ],
    );
  }

  // Small blue dot for "In Progress"
  Widget _buildDot() {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Color(0xFF34608D),
        shape: BoxShape.circle,
      ),
    );
  }

  // --- SERVICE DETAILS CARD ---
  Widget _buildServiceDetailsCard() {
    return _customCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Service Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildDetailRow("Service", controller.serviceName),
          const Divider(height: 24, color: Color(0xFFEEEEEE)),
          _buildDetailRow("Location", controller.location),
          const Divider(height: 24, color: Color(0xFFEEEEEE)),
          _buildDetailRow("Estimated Cost", controller.estimatedCost),
          const Divider(height: 24, color: Color(0xFFEEEEEE)),
          _buildDetailRow("Job Start", controller.jobStartTime),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // --- BOTTOM BUTTON ---
  Widget _buildBottomButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => controller.viewCompletionWork(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(
                0xFF34608D,
              ), // Matches the Blue theme
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              "View Completion work",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- REUSABLE CARD CONTAINER ---
  Widget _customCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: child,
    );
  }
}
