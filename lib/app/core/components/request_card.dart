import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/static/app_colors.dart';
import '../constants/static/app_strings.dart';

class RequestCard extends StatelessWidget {
  final String clientName;
  final String serviceTitle;
  final String address;
  final String distance;
  final String time;
  final String price;
  final String tag; // URGENT, NORMAL
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onCall;
  final VoidCallback onChat;

  const RequestCard({
    super.key,
    required this.clientName,
    required this.serviceTitle,
    required this.address,
    required this.distance,
    required this.time,
    required this.price,
    required this.tag,
    required this.onAccept,
    required this.onDecline,
    required this.onCall,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    bool isUrgent = tag.toUpperCase() == 'URGENT';

    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          children: [
            // Green top border indicator
            Container(height: 4, color: AppColors.onlineGreen),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Tag & Timer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: isUrgent ? const Color(0xFFFFEBEE) : const Color(0xFFFFF9E6),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isUrgent ? Icons.whatshot : Icons.star,
                              color: isUrgent ? AppColors.urgentRed : AppColors.normalYellow,
                              size: 14.0,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              tag.toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w700,
                                color: isUrgent ? AppColors.urgentRed : const Color(0xFFB48A00),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 14.0, color: Colors.grey.shade400),
                          const SizedBox(width: 4.0),
                          Text(
                            "0:40s",
                            style: GoogleFonts.poppins(fontSize: 12.0, color: AppColors.greyText, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16.0),
                  
                  // Client info Row
                  Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F5FA),
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: const Icon(Icons.person_outline, color: Colors.grey, size: 28),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              clientName,
                              style: GoogleFonts.poppins(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 14.0, color: AppColors.normalYellow),
                                const SizedBox(width: 4.0),
                                Text(
                                  "4.8 Client Rating",
                                  style: GoogleFonts.poppins(fontSize: 12.0, color: AppColors.greyText, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F5FA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          price,
                          style: GoogleFonts.poppins(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16.0),
                  
                  // Job details 
                  const Divider(height: 1),
                  const SizedBox(height: 16.0),
                  _buildDetailRow(Icons.build_rounded, serviceTitle, Colors.grey.shade700),
                  const SizedBox(height: 10.0),
                  _buildDetailRow(Icons.location_on_rounded, address, Colors.grey.shade500),
                  const SizedBox(height: 10.0),
                  _buildDetailRow(Icons.access_time_filled_rounded, "$distance away • $time drive", Colors.grey.shade500),
                  
                  const SizedBox(height: 20.0),
                  
                  // Communication Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onCall,
                          icon: const Icon(Icons.call_rounded, size: 18.0),
                          label: Text(AppStrings.call.tr),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textColor,
                            side: BorderSide(color: Colors.grey.shade200),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onChat,
                          icon: const Icon(Icons.chat_bubble_rounded, size: 18.0),
                          label: Text(AppStrings.chat.tr),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textColor,
                            side: BorderSide(color: Colors.grey.shade200),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12.0),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onDecline,
                          icon: const Icon(Icons.close_rounded, size: 18),
                          label: Text(AppStrings.decline.tr),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFEBEE),
                            foregroundColor: AppColors.urgentRed,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onAccept,
                          icon: const Icon(Icons.check_rounded, size: 18),
                          label: Text(AppStrings.accept.tr),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.onlineGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 18.0, color: iconColor),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13.0,
              color: AppColors.textColor.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
