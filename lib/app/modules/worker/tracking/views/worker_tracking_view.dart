import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/components/status_timeline_tile.dart';
import '../controllers/worker_tracking_controller.dart';

class WorkerTrackingView extends GetView<WorkerTrackingController> {
  const WorkerTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Tracking",
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
          icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            final isLive = controller.status.value == 'working' || controller.status.value == 'arrived';
            return Container(
              margin: const EdgeInsets.only(right: 16.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: (isLive ? AppColors.timelineActive : Colors.orange).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: (isLive ? AppColors.timelineActive : Colors.orange).withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      color: isLive ? AppColors.timelineActive : Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    isLive ? "Live" : "Arrived",
                    style: GoogleFonts.poppins(
                      color: isLive ? AppColors.timelineActive : Colors.orange,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildClientHeader(),
                  const SizedBox(height: 24),
                  _buildAdditionalCosts(),
                  _buildProgressCard(),
                  const SizedBox(height: 24),
                  _buildServiceDetailsCard(),
                  const SizedBox(height: 24),
                  _buildTimelineCard(),
                ],
              ),
            ),
          ),
          _buildBottomActionButton(context),
        ],
      ),
    );
  }

  Widget _buildClientHeader() {
    return Obx(() => Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14.0),
          child: controller.artisanImageUrl.value.isNotEmpty
              ? Image.network(
                  controller.artisanImageUrl.value,
                  width: 56.0,
                  height: 56.0,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56.0,
                    height: 56.0,
                    color: const Color(0xFFF0F4F8),
                    child: Icon(Icons.person, color: Colors.grey.shade400, size: 28),
                  ),
                )
              : Container(
                  width: 56.0,
                  height: 56.0,
                  color: const Color(0xFFF0F4F8),
                  child: Icon(Icons.person, color: Colors.grey.shade400, size: 28),
                ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.artisanName.value,
                style: GoogleFonts.poppins(
                  color: AppColors.textColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.ratingStar, size: 18.0),
                  const SizedBox(width: 4.0),
                  Text(
                    '${controller.rating.value} \u00b7 ${controller.profession.value}',
                    style: GoogleFonts.poppins(
                      color: AppColors.greyText,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: controller.goToChat,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F8),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: const Icon(Icons.chat_bubble_outline, color: AppColors.primary, size: 24.0),
          ),
        ),
      ],
    ));
  }

  Widget _buildProgressCard() {
    return Obx(() {
      final elapsed = controller.elapsedMinutes.value;
      final progress = controller.progressPercent.value;
      final s = controller.status.value;
      
      String statusLabel;
      String timeLabel;
      if (s == 'working') {
        statusLabel = "Service In Progress";
        timeLabel = "Started at ${controller.workingTime.value} \u00b7 $elapsed min elapsed";
      } else if (s == 'arrived') {
        statusLabel = "Arrived at Location";
        timeLabel = "Waiting to start work";
      } else if (s == 'completed') {
        statusLabel = "Service Completed";
        timeLabel = "Completed at ${controller.completedTime.value}";
      } else {
        statusLabel = "En Route";
        timeLabel = "Heading to client location";
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: const Color(0xFFF1F4F8)),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 130.0,
              height: 130.0,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10.0,
                    backgroundColor: const Color(0xFFF1F4F8),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    strokeCap: StrokeCap.round,
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          s == 'completed' ? Icons.check_circle : Icons.build_rounded,
                          color: AppColors.primary,
                          size: 28.0,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          '$elapsed min',
                          style: GoogleFonts.poppins(
                            color: AppColors.textColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              statusLabel,
              style: GoogleFonts.poppins(
                color: AppColors.textColor,
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              timeLabel,
              style: GoogleFonts.poppins(
                color: AppColors.greyText,
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildServiceDetailsCard() {
    return Obx(() => Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: const Color(0xFFF1F4F8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service Details",
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20.0),
          _buildDetailRow('Service', controller.serviceName.value),
          const Divider(height: 24, color: Color(0xFFF1F4F8)),
          _buildDetailRow('Location', controller.location.value),
          const Divider(height: 24, color: Color(0xFFF1F4F8)),
          _buildDetailRow('Price', controller.estimatedCost.value),
          const Divider(height: 24, color: Color(0xFFF1F4F8)),
          _buildDetailRow('Job Start', controller.workingTime.value != 'Pending' 
              ? controller.workingTime.value 
              : controller.jobStartTime.value),
        ],
      ),
    ));
  }

  Widget _buildTimelineCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: const Color(0xFFF1F4F8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Status Timeline",
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24.0),
          Obx(() => Column(
            children: [
              StatusTimelineTile(
                title: 'Job Accepted',
                subtitle: 'You accepted the job',
                time: controller.acceptedTime.value,
                icon: Icons.check,
                state: controller.currentStep.value >= 0 ? TimelineState.completed : TimelineState.pending,
              ),
              StatusTimelineTile(
                title: 'On the Way',
                subtitle: 'Heading to client location',
                time: controller.onWayTime.value,
                icon: Icons.check,
                state: controller.currentStep.value >= 1 ? TimelineState.completed : TimelineState.pending,
              ),
              StatusTimelineTile(
                title: 'Arrived',
                subtitle: 'Arrived at service location',
                time: controller.currentStep.value >= 2
                    ? controller.workingTime.value
                    : 'Pending',
                icon: Icons.location_on,
                state: controller.currentStep.value >= 2
                    ? (controller.currentStep.value > 2 ? TimelineState.completed : TimelineState.current)
                    : TimelineState.pending,
              ),
              StatusTimelineTile(
                title: 'Working',
                subtitle: 'Service in progress',
                time: controller.currentStep.value >= 2 
                    ? '${controller.elapsedMinutes.value} min elapsed' 
                    : 'Pending',
                icon: Icons.build,
                state: controller.currentStep.value >= 2
                    ? (controller.currentStep.value > 2 ? TimelineState.completed : TimelineState.current)
                    : TimelineState.pending,
                trailingWidget: controller.currentStep.value == 2 ? Row(
                  children: [
                    ...List.generate(3, (index) => Container(
                      margin: const EdgeInsets.only(right: 4.0),
                      width: 6.0,
                      height: 6.0,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.3 + (index * 0.2)),
                        shape: BoxShape.circle,
                      ),
                    )),
                    const SizedBox(width: 8.0),
                    Text(
                      'In progress...',
                      style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ) : null,
              ),
              StatusTimelineTile(
                title: 'Completed',
                subtitle: 'Service has been completed',
                time: controller.completedTime.value,
                icon: Icons.celebration,
                state: controller.currentStep.value == 3 ? TimelineState.completed : TimelineState.pending,
                isLast: true,
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.greyText,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value.isNotEmpty ? value : '--',
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          final s = controller.status.value;
          final step = controller.currentStep.value;
          final isArrived = s == 'arrived';
          final isWorking = s == 'working';
          final isCompleted = s == 'completed' || step == 3;

          String buttonText;
          VoidCallback? onPressed;
          Color bgColor;

          if (isCompleted) {
            buttonText = "✓ Completed";
            onPressed = null;
            bgColor = const Color(0xFFE5E7EB);
          } else if (isWorking) {
            buttonText = "Mark as Complete";
            onPressed = controller.markAsComplete;
            bgColor = AppColors.primary;
          } else if (isArrived) {
            buttonText = "Start Working";
            onPressed = controller.startWorking;
            bgColor = Colors.orange;
          } else {
            buttonText = "Mark as Complete";
            onPressed = null;
            bgColor = const Color(0xFFE5E7EB);
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isArrived || isWorking) ...[
                ElevatedButton(
                  onPressed: () => _showAddCostDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    minimumSize: const Size(double.infinity, 56.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    elevation: 0,
                  ),
                  child: Text(
                    "Request Additional Cost",
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
              ],
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: bgColor,
                  minimumSize: const Size(double.infinity, 56.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  elevation: 0,
                ),
                child: Text(
                  buttonText,
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: onPressed != null ? Colors.white : AppColors.greyText,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showAddCostDialog(BuildContext context) {
    final reasonCtrl = TextEditingController();
    final amountCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          "Request Additional Cost",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: reasonCtrl,
              decoration: InputDecoration(
                hintText: "Reason (e.g. Extra materials)",
                hintStyle: GoogleFonts.poppins(color: AppColors.greyText),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: "Amount (e.g. 25.50)",
                hintStyle: GoogleFonts.poppins(color: AppColors.greyText),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                prefixText: "\$ ",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(color: AppColors.greyText, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final reason = reasonCtrl.text.trim();
              final amountStr = amountCtrl.text.trim();
              final amount = double.tryParse(amountStr);

              if (reason.isEmpty) {
                Get.snackbar("Error", "Please enter a reason");
                return;
              }
              if (amount == null || amount <= 0) {
                Get.snackbar("Error", "Please enter a valid amount");
                return;
              }

              Get.back();
              await controller.requestAdditionalCost(reason, amount);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            child: Text(
              "Submit",
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
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
          final String reason = cost['reason']?.toString() ?? 'Extra Charge';
          final String amount = cost['amount']?.toString() ?? '0.00';
          final String status = (cost['status'] ?? 'pending').toString().toLowerCase();

          Color statusColor;
          String statusText;

          if (status == 'approved') {
            statusColor = Colors.green;
            statusText = "Approved";
          } else if (status == 'rejected' || status == 'declined') {
            statusColor = Colors.red;
            statusText = "Declined";
          } else {
            statusColor = Colors.orange;
            statusText = "Pending Client Approval";
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: const Color(0xFFF1F4F8)),
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
                    Text(
                      "Requested Cost",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: AppColors.textColor,
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
                        style: GoogleFonts.poppins(
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
                  style: GoogleFonts.poppins(
                    color: AppColors.greyText,
                    fontSize: 13.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "Amount: \$$amount",
                  style: GoogleFonts.poppins(
                    color: AppColors.textColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}
