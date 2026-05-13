import 'package:artisan/app/core/Services/api_services.dart';
import 'package:artisan/app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'commonorderlist.dart';

class BookingListView extends StatelessWidget {
  final List<Map<String, dynamic>> bookings;
  final String emptyMessage;

  const BookingListView({
    super.key,
    required this.bookings,
    this.emptyMessage = "No bookings found",
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_late_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: bookings.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final String status = (booking['status'] ?? '').toString().toLowerCase();
        final bool isRequested = status == 'requested';

        // Show price range for requested, real amount for others
        final String displayAmount = isRequested 
            ? (booking['service_price_range'] ?? "\$40 - \$100") 
            : '\$${booking['total_amount'] ?? '0'}';

        return CustomBookingCard(
          title: booking['service_name'] ?? 'Service',
          providerName: booking['artisan_name'] ?? 'Artisan',
          date: booking['scheduled_date'] ?? 'N/A',
          amount: displayAmount,
          imageUrl: ApiServices.formatImageUrl(booking['artisan_picture']),
          artisanAvatar: ApiServices.formatImageUrl(booking['artisan_picture']),
          statusText: booking['status'] ?? 'Unknown',
          statusBgColor: _getStatusBgColor(status),
          statusTextColor: _getStatusTextColor(status),
          // Hide View Details button in Upcoming/Requested tab by setting tap to null
          onViewDetailsTap: isRequested ? null : () {
            Get.toNamed(Routes.TRACKINGSCREEN, arguments: booking);
          },
        );
      },
    );
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'requested': return const Color(0xFFEBF2FA);
      case 'confirmed': 
      case 'on_way':
      case 'arrived':
      case 'working':
      case 'completed': return const Color(0xFFE8F5E9);
      case 'cancelled':
      case 'rejected': return const Color(0xFFFFEBEE);
      default: return const Color(0xFFFFF3E0);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'requested': return const Color(0xFF2E5B8E);
      case 'confirmed':
      case 'on_way':
      case 'arrived':
      case 'working':
      case 'completed': return const Color(0xFF4CAF50);
      case 'cancelled':
      case 'rejected': return const Color(0xFFF44336);
      default: return const Color(0xFFFF9800);
    }
  }
}
