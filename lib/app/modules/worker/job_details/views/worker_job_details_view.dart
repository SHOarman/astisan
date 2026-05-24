import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../controllers/worker_job_details_controller.dart';

class WorkerJobDetailsView extends GetView<WorkerJobDetailsController> {
  const WorkerJobDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: _buildAppBar(),
      body: Obx(() => controller.isLoading.value 
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: (controller.bookingStatus.value.toLowerCase() == 'completed' ||
                          controller.bookingStatus.value.toLowerCase() == 'cancelled')
                      ? 24.0
                      : 120.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildClientInfo(),
                    const SizedBox(height: 16.0),
                    _buildServiceInfoCard(),
                    const SizedBox(height: 16.0),
                    _buildScheduleLocationCard(),
                    const SizedBox(height: 16.0),
                    _buildClientNotesCard(),
                    const SizedBox(height: 16.0),
                    _buildChecklistCard(),
                    const SizedBox(height: 16.0),
                    _buildAttachmentCard(),
                    const SizedBox(height: 24.0),
                  ],
                ),
              ),
              _buildBottomAction(),
            ],
          )),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        AppStrings.jobDetailsTitle.tr,
        style: GoogleFonts.poppins(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28.0),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }

  Widget _buildClientInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Obx(() => CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[200],
                backgroundImage: controller.clientImage.value.isNotEmpty
                    ? NetworkImage(controller.clientImage.value)
                    : null,
                child: controller.clientImage.value.isEmpty
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              )),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                      controller.clientName.value,
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    )),
                    Obx(() => Text(
                      controller.clientAddress.value,
                      style: GoogleFonts.poppins(
                        fontSize: 12.0,
                        color: AppColors.greyText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ],
                ),
              ),
              IconButton(
                onPressed: controller.chatClient,
                icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F4F8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
          Obx(() {
            if (controller.clientBio.value.isEmpty || controller.clientBio.value == "No bio available") {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(height: 1),
                ),
                Text(
                  "About Client".tr,
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  controller.clientBio.value,
                  style: GoogleFonts.poppins(
                    fontSize: 13.0,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildServiceInfoCard() {
    return _buildSectionCard(
      title: AppStrings.serviceInfo.tr,
      child: Column(
        children: [
          Obx(() => _buildDetailRow("Service".tr, controller.serviceName.value, isBold: true)),
          const SizedBox(height: 12.0),
          Obx(() => _buildDetailRow("Payment".tr, "\$${controller.paymentAmount.value.toStringAsFixed(2)}", valueColor: const Color(0xFF4CAF50), isBold: true)),
          const SizedBox(height: 12.0),
          Obx(() {
            final id = controller.displayBookingId.value;
            final displayId = id.isNotEmpty ? (id.startsWith('#') ? id : '#$id') : 'N/A';
            return _buildDetailRow("Booking ID".tr, displayId, isBold: true, isID: true);
          }),
        ],
      ),
    );
  }

  Widget _buildScheduleLocationCard() {
    return _buildSectionCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIconContainer(Icons.access_time, const Color(0xFFE3F2FD), AppColors.primary),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.scheduledTime.tr,
                      style: GoogleFonts.poppins(fontSize: 14.0, color: AppColors.greyText),
                    ),
                    Obx(() => Text(
                      controller.scheduledTime.value,
                      style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.bold, color: AppColors.textColor),
                    )),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIconContainer(Icons.location_on_outlined, const Color(0xFFE8F5E9), const Color(0xFF4CAF50)),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.locationLabel.tr,
                      style: GoogleFonts.poppins(fontSize: 14.0, color: AppColors.greyText),
                    ),
                    Obx(() => Text(
                      controller.clientAddress.value,
                      style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.bold, color: AppColors.textColor),
                    )),
                    Obx(() => Text(
                      controller.distance.value,
                      style: GoogleFonts.poppins(fontSize: 12.0, color: AppColors.greyText),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientNotesCard() {
    return _buildSectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconContainer(Icons.description_outlined, const Color(0xFFFFF3E0), const Color(0xFFFF9800)),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.clientNotes.tr,
                  style: GoogleFonts.poppins(fontSize: 14.0, color: AppColors.greyText),
                ),
                const SizedBox(height: 4.0),
                Obx(() => Text(
                  controller.clientNotes.value,
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    color: AppColors.textColor,
                    height: 1.5,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistCard() {
    return Obx(() => controller.checklist.isEmpty 
      ? const SizedBox.shrink()
      : _buildSectionCard(
          title: AppStrings.jobChecklistTitle.tr,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.checklist.length,
            separatorBuilder: (context, index) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final item = controller.checklist[index];
              return Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item['checked'] ? const Color(0xFF4CAF50) : Colors.grey[200],
                    ),
                    child: item['checked'] 
                      ? const Icon(Icons.check, size: 16, color: Colors.white) 
                      : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 15.0,
                        color: item['checked'] ? AppColors.greyText : AppColors.textColor,
                        decoration: item['checked'] ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }

  Widget _buildAttachmentCard() {
    return Obx(() => controller.attachmentImage.value.isEmpty 
      ? const SizedBox.shrink()
      : Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: const Color(0xFFE5E7EB)), // Premium light grey border
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(Icons.image_outlined, color: AppColors.textColor, size: 22.0),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  controller.attachmentName.value.tr,
                  style: GoogleFonts.poppins(
                    fontSize: 15.0,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_red_eye_outlined, color: AppColors.textColor, size: 22.0),
                onPressed: controller.viewAttachment,
              ),
              IconButton(
                icon: const Icon(Icons.file_download_outlined, color: AppColors.textColor, size: 22.0),
                onPressed: controller.downloadAttachment,
              ),
            ],
          ),
        ));
  }

  Widget _buildSectionCard({String? title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 16.0),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor, bool isBold = false, bool isID = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            label.tr,
            style: GoogleFonts.poppins(fontSize: 14.0, color: AppColors.greyText),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: isID ? TextOverflow.ellipsis : TextOverflow.visible,
            maxLines: isID ? 1 : 3,
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: valueColor ?? AppColors.textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconContainer(IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Icon(icon, color: iconColor, size: 22.0),
    );
  }

  Widget _buildBottomAction() {
    final status = controller.bookingStatus.value.toLowerCase();
    if (status == 'completed' || status == 'cancelled') {
      return const SizedBox.shrink();
    }
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: controller.startNavigation,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 56.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 0,
            ),
            child: Text(
              AppStrings.startNavigation.tr,
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
