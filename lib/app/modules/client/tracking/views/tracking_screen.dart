import 'package:artisan/app/core/Services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/components/custom_dialog.dart';
import '../../../../core/routes/app_routes.dart';
import '../controllers/tracking_controller.dart';

class TrackingScreen extends GetView<TrackingController> {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller if not already initialized by bindings
    Get.put(TrackingController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Obx(() => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 16),
            _buildAdditionalCosts(),
            _buildProgressCard(),
            const SizedBox(height: 16),
            _buildTimelineCard(),
            const SizedBox(height: 16),
            _buildServiceDetailsCard(),
            const SizedBox(height: 24),
          ],
        ),
      )),
      bottomNavigationBar: Obx(() => _buildBottomButtons()),
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
          backgroundColor: Colors.grey.shade200,
          backgroundImage: controller.artisanImageUrl.value.isNotEmpty
              ? NetworkImage(ApiServices.formatImageUrl(controller.artisanImageUrl.value))
              : null,
          child: controller.artisanImageUrl.value.isEmpty 
              ? const Icon(Icons.person, color: Colors.grey) 
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.artisanName.value,
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
                    "${controller.rating.value} · ${controller.profession.value}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (controller.isStatusAtLeast('confirmed'))
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
                  value: controller.progressPercent.value,
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
                    "${controller.elapsedMinutes.value} min",
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
          Text(
            controller.status.value == 'completed' ? "Service Completed" : "Service In Progress",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(
            "Started at ${controller.jobStartTime.value} · ${controller.elapsedMinutes.value} min elapsed",
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
            isCompleted: controller.isStatusAtLeast('confirmed'),
            isCurrent: controller.status.value == 'confirmed',
            iconData: Icons.check,
            iconBgColor: controller.isStatusAtLeast('confirmed') ? const Color(0xFF57A783) : Colors.grey.shade200,
            title: "Booking Confirmed",
            subtitle: controller.isStatusAtLeast('confirmed') ? "Your booking has been accepted" : "Waiting for confirmation",
            time: controller.confirmationTime.value,
          ),
          _buildTimelineStep(
            isLast: false,
            isCompleted: controller.isStatusAtLeast('on_way'),
            isCurrent: controller.status.value == 'on_way',
            iconData: Icons.local_shipping_outlined,
            iconBgColor: controller.isStatusAtLeast('on_way') ? const Color(0xFF57A783) : Colors.grey.shade200,
            title: "On the Way",
            subtitle: "Artisan is heading to your location",
            time: controller.onWayTime.value,
            isFaded: !controller.isStatusAtLeast('on_way'),
          ),
          _buildTimelineStep(
            isLast: false,
            isCompleted: controller.isStatusAtLeast('working'),
            isCurrent: controller.status.value == 'working',
            iconData: Icons.build,
            iconBgColor: controller.isStatusAtLeast('working') ? const Color(0xFF34608D) : Colors.grey.shade200,
            title: "Working",
            subtitle: "Service in progress at your location",
            time: controller.workingTime.value,
            isFaded: !controller.isStatusAtLeast('working'),
            extraWidget: controller.status.value == 'working' ? Row(
              children: [
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
            ) : null,
          ),
          _buildTimelineStep(
            isLast: true,
            isCompleted: controller.isStatusAtLeast('completed'),
            iconData: Icons.celebration,
            iconBgColor: controller.isStatusAtLeast('completed') ? const Color(0xFF57A783) : Colors.grey.shade100,
            iconColor: controller.isStatusAtLeast('completed') ? Colors.white : Colors.grey.shade500,
            title: "Completed",
            subtitle: "Service has been completed",
            time: controller.completedTime.value,
            isFaded: !controller.isStatusAtLeast('completed'),
          ),
        ],
      ),
    );
  }

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
                      Icon(Icons.access_time, size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
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
              if (extraWidget != null) ...[
                const SizedBox(height: 8),
                extraWidget,
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

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
          _buildDetailRow("Service", controller.serviceName.value),
          const Divider(height: 24, color: Color(0xFFEEEEEE)),
          _buildDetailRow("Location", controller.location.value),
          const Divider(height: 24, color: Color(0xFFEEEEEE)),
          _buildDetailRow("Estimated Cost", controller.estimatedCost.value),
          const Divider(height: 24, color: Color(0xFFEEEEEE)),
          _buildDetailRow("Job Start", controller.jobStartTime.value),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // --- BOTTOM BUTTONS ---
  Widget _buildBottomButtons() {
    final bool canTrack = ['on_way', 'on_the_way', 'on-the-way'].contains(controller.status.value);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Track Artisan Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: canTrack ? () {
                  Get.toNamed(Routes.TRACKING);
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canTrack ? const Color(0xFF4A7EAF) : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Track Artisan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: canTrack ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: controller.status.value == 'completed'
                      ? [
                          BoxShadow(
                            color: const Color(0xFF4A7EAF).withOpacity(0.45),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: ElevatedButton.icon(
                  onPressed: controller.status.value == 'completed'
                      ? () => controller.viewCompletionWork()
                      : null,
                  icon: Icon(
                    controller.status.value == 'completed'
                        ? Icons.check_circle_outline
                        : Icons.hourglass_empty,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    controller.status.value == 'completed'
                        ? "View Completion Work →"
                        : "View Completion Work",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: controller.status.value == 'completed'
                          ? Colors.white
                          : Colors.white70,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.status.value == 'completed'
                        ? const Color(0xFF4A7EAF)
                        : const Color(0xFFBDC3D1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Builder(
              builder: (context) {
                final bool canCancel = controller.status.value == 'requested' || controller.status.value == 'pending' || controller.status.value.isEmpty;
                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: canCancel ? () {
                      showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          title: "Cancel Booking?",
                          subtitle: "Are you sure you want to cancel this booking?",
                          primaryButtonText: "Confirm",
                          secondaryButtonText: "Go Back",
                          onPrimaryPressed: () {
                            Navigator.pop(context); // Close dialog
                            Get.snackbar("Cancelled".tr, "Booking cancelled successfully".tr,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(16),
                            );
                            Get.offAllNamed(Routes.ORDER_HISTORY); // Go to home
                          },
                          onSecondaryPressed: () => Navigator.pop(context),
                        ),
                      );
                    } : null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: canCancel ? Colors.redAccent : Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Cancel Booking",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: canCancel ? Colors.redAccent : Colors.grey.shade400,
                      ),
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _customCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildAdditionalCosts() {
    return Obx(() {
      final b = controller.booking.value;
      if (b == null) return const SizedBox.shrink();

      final List costs = b['additional_costs'] as List? ?? [];
      if (costs.isEmpty) return const SizedBox.shrink();

      return Column(
        children: costs.map<Widget>((cost) {
          final String costId = cost['id']?.toString() ?? '';
          final String reason = cost['reason']?.toString() ?? 'Extra Charge';
          final String amount = cost['amount']?.toString() ?? '0.00';
          final String status = (cost['status'] ?? 'pending').toString().toLowerCase();

          Color statusColor;
          String statusText;
          bool isPending = status == 'pending';

          if (status == 'approved') {
            statusColor = Colors.green;
            statusText = "Approved";
          } else if (status == 'rejected' || status == 'declined') {
            statusColor = Colors.red;
            statusText = "Declined";
          } else {
            statusColor = Colors.orange;
            statusText = "Pending Approval";
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: isPending ? Colors.orange.withOpacity(0.5) : Colors.grey.shade200,
                width: isPending ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Additional Cost Request",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Text(
                  "Reason: $reason",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "Amount: \$$amount",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isPending) ...[
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => controller.respondToAdditionalCost(costId, "reject"),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                          ),
                          child: const Text(
                            "Decline",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => controller.respondToAdditionalCost(costId, "approve"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                          ),
                          child: const Text(
                            "Approve",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}