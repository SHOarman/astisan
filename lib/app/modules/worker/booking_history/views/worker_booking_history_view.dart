import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/Services/api_services.dart';
import '../controllers/worker_booking_history_controller.dart';

class WorkerBookingHistoryView extends GetView<WorkerBookingHistoryController> {
  const WorkerBookingHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Order History",
            style: GoogleFonts.poppins(
              color: AppColors.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.greyText,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors.primary,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            tabs: const [
              Tab(text: "Accepted"),
              Tab(text: "Completed"),
              Tab(text: "Cancelled"),
            ],
          ),
        ),
        body: Obx(() => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildBookingList(controller.acceptedBookings, "Accept by you", const Color(0xFFE8F5E9), const Color(0xFF4CAF50)),
                  _buildBookingList(controller.completedBookings, "Completed", const Color(0xFFE8F5E9), const Color(0xFF4CAF50)),
                  _buildBookingList(controller.cancelledBookings, "Cancelled", const Color(0xFFFFEBEE), const Color(0xFFE53935)),
                ],
              )),
      ),
    );
  }

  Widget _buildBookingList(List<dynamic> bookings, String statusLabel, Color statusBg, Color statusColor) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_late_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "No bookings found",
              style: GoogleFonts.poppins(color: AppColors.greyText, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking, statusLabel, statusBg, statusColor);
      },
    );
  }

  Widget _buildBookingCard(dynamic booking, String statusLabel, Color statusBg, Color statusColor) {
    final client = booking['client'] is Map ? booking['client'] : {};
    
    // Support both nested 'client' object and flat fields
    final clientName = booking['client_name'] ?? client['full_name'] ?? client['name'] ?? "Client";
    
    final rawImage = booking['client_profile_picture'] ?? booking['client_picture'] ?? client['profile_picture'] ?? "";
    final clientImage = ApiServices.formatImageUrl(rawImage.toString());
    
    final serviceName = booking['service_name'] ?? "Service";
    
    // Support both total_amount and price fields
    final price = booking['total_amount']?.toString() ?? booking['price']?.toString() ?? "0.0";
    
    final date = booking['scheduled_date'] ?? booking['created_at']?.split('T')[0] ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: clientImage.isNotEmpty
                    ? Image.network(clientImage, width: 60, height: 60, fit: BoxFit.cover)
                    : Container(width: 60, height: 60, color: Colors.grey[200], child: const Icon(Icons.person, color: Colors.grey)),
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
                          serviceName,
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textColor),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, color: statusColor, size: 8),
                              const SizedBox(width: 4),
                              Text(
                                statusLabel,
                                style: GoogleFonts.poppins(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "by $clientName",
                      style: GoogleFonts.poppins(fontSize: 13, color: AppColors.greyText),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          date,
                          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.greyText),
                        ),
                        Text(
                          "\$$price",
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF4CAF50)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.WORKER_JOB_DETAILS, arguments: {'bookingId': booking['id']}),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF1F4F8),
                foregroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                "View Details",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
