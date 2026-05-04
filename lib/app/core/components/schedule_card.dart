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
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    bool isOngoing = status.toUpperCase() == 'ONGOING';

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
          // Left Icon
          Container(
            width: 54.0,
            height: 54.0,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5FA),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Icon(
              Icons.build_outlined, // Wrench icon used in mockups
              color: Colors.grey.shade600,
              size: 24.0,
            ),
          ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: isOngoing 
                            ? const Color(0xFFE8EAF6) 
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 9.0,
                          fontWeight: FontWeight.w700,
                          color: isOngoing 
                              ? AppColors.primary 
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
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
}
