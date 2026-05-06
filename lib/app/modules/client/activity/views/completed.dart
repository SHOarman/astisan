import 'package:artisan/app/modules/client/activity/views/wideget/commonorderlist.dart';
import 'package:flutter/material.dart';

class Completed extends StatelessWidget {
  const Completed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              CustomBookingCard(
                title: "Full House Cleaning",
                providerName: "Sarah Ahmed",
                date: "March 15, 2026",
                amount: "\$160",
                imageUrl: "assets/images/Image (9).png",
                statusText: "Completed",
                statusBgColor: const Color(0xFFE8F5E9),
                statusTextColor: const Color(0xFF4CAF50),
                amountColor: const Color(0xFF4CAF50),

                rateButtonText: "Rate",
                onRateTap: () {
                  print("Rating");
                },

                rebookButtonText: "Rebook",
                onRebookTap: () {
                  print("Rebook ");
                },


              )





            ],
          ),
        ),
      ),

    );
  }
}
