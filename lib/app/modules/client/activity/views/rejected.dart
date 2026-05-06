import 'package:artisan/app/modules/client/activity/views/wideget/commonorderlist.dart';
import 'package:flutter/material.dart';

class Rejected extends StatelessWidget {
  const Rejected({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(

            children: [

              CustomBookingCard(
                title: "Full House Cleaning",
                providerName: "Sarah Ahmed",
                date: "March 15, 2026",
                amount: "\$160",
                imageUrl: "assets/images/Image (9).png",

                statusText: "Rejected",
                statusBgColor: Colors.white30,
                statusTextColor: Colors.red,
                onRateTap: null,
                onRebookTap: null,

                viewDetailsButtonText: "Refind",
                onViewDetailsTap: () {
                  print("Viewing rejected booking details...");
                },
              )


            ],
          ),
        ),
      ),

    );
  }
}
