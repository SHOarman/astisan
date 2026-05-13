import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/components/request_card.dart';
import '../controllers/incoming_requests_controller.dart';

class IncomingRequestsView extends GetView<IncomingRequestsController> {
  const IncomingRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(IncomingRequestsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Incoming Requests",
              style: GoogleFonts.poppins(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            Text(
              "${controller.requests.length} active requests",
              style: GoogleFonts.poppins(
                fontSize: 13.0,
                color: AppColors.greyText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Center(
              child: Obx(() => Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.urgentRed,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "${controller.requests.length}",
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.requests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text(
                  "No incoming requests at the moment",
                  style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 16),
                ),
                const SizedBox(height: 10),
                TextButton(
                   onPressed: controller.fetchRequests,
                   child: const Text("Refresh"),
                )
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchRequests,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => controller.isVerified.value 
                    ? const SizedBox.shrink() 
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: _buildVerificationWarning(),
                      )
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.requests.length,
                    itemBuilder: (context, index) {
                      final req = controller.requests[index];
                      // API Field Mapping
                      final String bookingId = req['booking_id']?.toString() ?? '';
                      final String clientName = req['client_name'] ?? 'Client';
                      final String? clientPicture = ApiServices.formatImageUrl(req['client_picture']?.toString());
                      final String serviceTitle = req['service_name'] ?? 'Service';
                      final String address = req['full_address'] ?? 'Address not set';
                      final String price = "\$${req['base_price'] ?? '0'}";
                      return RequestCard(
                        clientName: clientName,
                        clientPictureUrl: clientPicture,
                        serviceTitle: serviceTitle,
                        address: address,
                        distance: "1.2 km", // Placeholder as not in API yet
                        time: "5 min",      // Placeholder
                        price: price,
                        tag: "NORMAL",      // Placeholder
                        onAccept: () => controller.acceptRequest(bookingId),
                        onDecline: () => controller.declineRequest(bookingId),
                        onCall: () {},
                        onChat: () => Get.toNamed(Routes.CHAT, arguments: {'bookingId': bookingId}),
                      );
                    },
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildVerificationWarning() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FA),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.primary.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_rounded, color: AppColors.urgentRed, size: 36),
          const SizedBox(height: 16.0),
          Text(
            "Your account isn't verified yet. To send work requests and get hired, please complete your verification.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              color: AppColors.textColor.withOpacity(0.9),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.WORKER_VERIFICATION),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
              ),
              child: Text(
                "Verify now",
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
