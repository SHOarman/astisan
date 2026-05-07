import 'package:flutter/material.dart';

class CustomBookingCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String providerName;
  final String date;
  final String amount;
  final String statusText;

  final Color statusBgColor;
  final Color statusTextColor;
  final Color amountColor;

  final String rateButtonText;
  final String rebookButtonText;
  final String viewDetailsButtonText;

  final VoidCallback? onRateTap;
  final VoidCallback? onRebookTap;
  final VoidCallback? onViewDetailsTap;

  const CustomBookingCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.providerName,
    required this.date,
    required this.amount,
    required this.statusText,
    this.statusBgColor = const Color(0xFFE8F5E9),
    this.statusTextColor = const Color(0xFF4CAF50),
    this.amountColor = const Color(0xFF4CAF50),
    this.rateButtonText = "Rate",
    this.rebookButtonText = "Rebook",
    this.viewDetailsButtonText = "View Details",
    this.onRateTap,
    this.onRebookTap,
    this.onViewDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 12),
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
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(radius: 3, backgroundColor: statusTextColor),
                              const SizedBox(width: 5),
                              Text(
                                statusText,
                                style: TextStyle(color: statusTextColor, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text("by $providerName", style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(date, style: TextStyle(color: Colors.grey.shade400)),
                        Text(
                          amount,
                          style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (onRateTap != null || onRebookTap != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                if (onRateTap != null)
                  Expanded(
                    child: _buildOutlineButton(
                      label: rateButtonText,
                      icon: Icons.star,
                      iconColor: Colors.orange,
                      onTap: onRateTap,
                    ),
                  ),
                if (onRateTap != null && onRebookTap != null) const SizedBox(width: 12),
                if (onRebookTap != null)
                  Expanded(
                    child: _buildOutlineButton(
                      label: rebookButtonText,
                      icon: Icons.refresh,
                      iconColor: Colors.blue.shade700,
                      onTap: onRebookTap,
                    ),
                  ),
              ],
            ),
          ],

          if (onViewDetailsTap != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE3F2FD),
                  foregroundColor: const Color(0xFF1565C0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: onViewDetailsTap,
                child: Text(viewDetailsButtonText, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOutlineButton({required String label, required IconData icon, required Color iconColor, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Color(0xFF5C6BC0), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}