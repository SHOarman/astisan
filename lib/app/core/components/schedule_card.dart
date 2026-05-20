import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/static/app_colors.dart';

class ScheduleCard extends StatelessWidget {
  final String serviceTitle;
  final String clientName;
  final String time;
  final String distance;
  final String price;
  final String duration;
  final String status; // ONGOING, UPCOMING
  final String? clientImage;
  final String? iconPath;

  const ScheduleCard({
    super.key,
    required this.serviceTitle,
    required this.clientName,
    required this.time,
    required this.distance,
    required this.price,
    required this.duration,
    required this.status,
    this.clientImage,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    final s = status.toLowerCase();
    bool isOngoing = s == 'accept by you' || s == 'on the way' || s == 'arrived' || s == 'working';
    bool isCompleted = s == 'completed';
    bool isCancelled = s == 'cancelled' || s == 'rejected';

    Color badgeBgColor = isOngoing
        ? const Color(0xFFE8F5E9)
        : isCompleted
            ? const Color(0xFFE3F2FD)
            : isCancelled
                ? const Color(0xFFFFEBEE)
                : const Color(0xFFF0F4F8);

    Color badgeTextColor = isOngoing
        ? AppColors.onlineGreen
        : isCompleted
            ? const Color(0xFF1976D2)
            : isCancelled
                ? const Color(0xFFD32F2F)
                : const Color(0xFF546E7A);

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left — Client Avatar or Service Icon
          _buildAvatar(),
          const SizedBox(width: 16.0),
          
          // Center Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        serviceTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    _buildStatusBadge(badgeBgColor, badgeTextColor, isOngoing, isCompleted),
                  ],
                ),
                Text(
                  clientName,
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    color: AppColors.greyText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Icon(Icons.access_time_filled_rounded, size: 14.0, color: Colors.grey.shade400),
                    const SizedBox(width: 4.0),
                    Text(
                      time,
                      style: GoogleFonts.poppins(
                        fontSize: 12.0,
                        color: AppColors.greyText,
                      ),
                    ),
                    if (distance.isNotEmpty && distance != '--') ...[
                      const SizedBox(width: 12.0),
                      Icon(Icons.location_on_rounded, size: 14.0, color: Colors.grey.shade400),
                      const SizedBox(width: 4.0),
                      Text(
                        distance,
                        style: GoogleFonts.poppins(
                          fontSize: 12.0,
                          color: AppColors.greyText,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Right Price & Duration
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: GoogleFonts.poppins(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              Text(
                duration,
                style: GoogleFonts.poppins(
                  fontSize: 12.0,
                  color: AppColors.greyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final bool hasImage = clientImage != null && clientImage!.isNotEmpty && clientImage!.startsWith('http');
    
    return Container(
      width: 54.0,
      height: 54.0,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FA),
        borderRadius: BorderRadius.circular(14.0),
        image: hasImage
            ? DecorationImage(
                image: NetworkImage(clientImage!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: hasImage
          ? null
          : Icon(
              Icons.build_outlined,
              color: Colors.grey.shade600,
              size: 24.0,
            ),
    );
  }

  Widget _buildStatusBadge(Color bgColor, Color textColor, bool isOngoing, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isOngoing) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: textColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4.0),
          ],
          if (isCompleted) ...[
            Icon(Icons.check_circle, size: 12, color: textColor),
            const SizedBox(width: 4.0),
          ],
          Text(
            status,
            style: GoogleFonts.poppins(
              fontSize: 10.0,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
