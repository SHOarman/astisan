import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
        title: Column(
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
              "5 active requests",
              style: GoogleFonts.poppins(
                fontSize: 13.0,
                color: AppColors.greyText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.urgentRed,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "2",
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVerificationWarning(),
              const SizedBox(height: 24.0),
              Obx(() => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.requests.length,
                itemBuilder: (context, index) {
                  final req = controller.requests[index];
                  return RequestCard(
                    clientName: req['clientName']!,
                    serviceTitle: req['serviceTitle']!,
                    address: req['address']!,
                    distance: req['distance']!,
                    time: req['time']!,
                    price: req['price']!,
                    tag: req['tag']!,
                    onAccept: () => controller.acceptRequest(index),
                    onDecline: () => controller.declineRequest(index),
                    onCall: () {},
                    onChat:() =>     Get.toNamed(Routes.CHAT),
                  );
                },
              )),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
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
