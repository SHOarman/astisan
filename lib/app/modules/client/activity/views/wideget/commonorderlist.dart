import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBookingCard extends StatelessWidget {
  final String imageUrl;
  final String artisanAvatar;
  final String title;
  final String providerName;
  final String date;
  final String amount;
  final String statusText;

  final Color statusBgColor;
  final Color statusTextColor;
  final Color amountColor;

  final String viewDetailsButtonText;
  final VoidCallback? onViewDetailsTap;

  const CustomBookingCard({
    super.key,
    required this.imageUrl,
    this.artisanAvatar = "",
    required this.title,
    required this.providerName,
    required this.date,
    required this.amount,
    required this.statusText,
    this.statusBgColor = const Color(0xFFE8F5E9),
    this.statusTextColor = const Color(0xFF4CAF50),
    this.amountColor = const Color(0xFF4CAF50),
    this.viewDetailsButtonText = "View Details",
    this.onViewDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with Avatar Overlay
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _buildImage(imageUrl, 90, 90),
                  ),
                  if (artisanAvatar.isNotEmpty)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: _buildImage(artisanAvatar, 24, 24),
                        ),
                      ),
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
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: const Color(0xFF1A1D1E),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(radius: 3, backgroundColor: statusTextColor),
                              const SizedBox(width: 6),
                              Text(
                                statusText,
                                style: GoogleFonts.poppins(
                                  color: statusTextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "by $providerName",
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          date,
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          amount,
                          style: GoogleFonts.poppins(
                            color: amountColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onViewDetailsTap != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEBF2FA),
                  foregroundColor: const Color(0xFF2E5B8E),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: onViewDetailsTap,
                child: Text(
                  viewDetailsButtonText,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImage(String url, double w, double h) {
    if (url.isEmpty) {
      return Container(
        width: w,
        height: h,
        color: const Color(0xFFEBF2FA),
        child: Icon(Icons.person, color: const Color(0xFF2E5B8E), size: w * 0.4),
      );
    }
    return url.startsWith('http')
        ? Image.network(
            url,
            width: w,
            height: h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: w,
              height: h,
              color: const Color(0xFFEBF2FA),
              child: Icon(Icons.person, color: const Color(0xFF2E5B8E), size: w * 0.4),
            ),
          )
        : Image.asset(
            url,
            width: w,
            height: h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: w,
              height: h,
              color: const Color(0xFFEBF2FA),
              child: Icon(Icons.person, color: const Color(0xFF2E5B8E), size: w * 0.4),
            ),
          );
  }
}