import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_images.dart';
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
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: AppColors.timelineActive.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: AppColors.timelineActive.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 6.0,
                  height: 6.0,
                  decoration: const BoxDecoration(
                    color: AppColors.timelineActive,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6.0),
                Text(
                  "Live",
                  style: GoogleFonts.poppins(
                    color: AppColors.timelineActive,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildArtisanHeader(),
                  const SizedBox(height: 24),
                  _buildProgressCard(),
                  const SizedBox(height: 24),
                  _buildTimelineCard(),
                  const SizedBox(height: 24),
                  _buildServiceDetailsCard(),
                ],
              ),
            ),
          ),
          _buildBottomActionButton(),
        ],
      ),
    );
  }

  Widget _buildArtisanHeader() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14.0),
          child: Image.asset(
            AppImages.homeMarcusJohnson, // Placeholder for James Wilson
            width: 56.0,
            height: 56.0,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'James Wilson',
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
                    '4.9 \u00b7 Plumbing Expert',
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
    );
  }

  Widget _buildProgressCard() {
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
                const CircularProgressIndicator(
                  value: 0.7,
                  strokeWidth: 10.0,
                  backgroundColor: Color(0xFFF1F4F8),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.build_rounded, color: AppColors.primary, size: 28.0),
                      const SizedBox(height: 4.0),
                      Text(
                        '34 min',
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
            "Service In Progress",
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Started at 10:18 AM \u00b7 34 min elapsed',
            style: GoogleFonts.poppins(
              color: AppColors.greyText,
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
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
                subtitle: 'Your accepted the job',
                time: '09:45 AM',
                icon: Icons.check,
                state: controller.currentStep.value >= 0 ? TimelineState.completed : TimelineState.pending,
              ),
              StatusTimelineTile(
                title: 'On the Way',
                subtitle: 'Artisan is heading to your location',
                time: '10:00 AM',
                icon: Icons.check,
                state: controller.currentStep.value >= 1 ? TimelineState.completed : TimelineState.pending,
              ),
              StatusTimelineTile(
                title: 'Working',
                subtitle: 'Service in progress at your location',
                time: '10:18 AM',
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
                time: controller.currentStep.value == 3 ? '10:52 AM' : 'Pending',
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

  Widget _buildServiceDetailsCard() {
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
            "Service Details",
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20.0),
          _buildDetailRow('Service', 'Pipe Repair'),
          const Divider(height: 24, color: Color(0xFFF1F4F8)),
          _buildDetailRow('Location', '123 Main St, NY'),
          const Divider(height: 24, color: Color(0xFFF1F4F8)),
          _buildDetailRow('Estimated Cost', '\$65 \u2013 \$120'),
          const Divider(height: 24, color: Color(0xFFF1F4F8)),
          _buildDetailRow('Job Start', '10:18 AM'),
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
        Text(
          value,
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionButton() {
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
          final isCompleted = controller.currentStep.value == 3;
          return ElevatedButton(
            onPressed: isCompleted ? controller.markAsComplete : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isCompleted ? AppColors.primary : const Color(0xFFE5E7EB),
              minimumSize: const Size(double.infinity, 56.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 0,
            ),
            child: Text(
              "Mark as Complete",
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: isCompleted ? Colors.white : AppColors.greyText,
              ),
            ),
          );
        }),
      ),
    );
  }
}
