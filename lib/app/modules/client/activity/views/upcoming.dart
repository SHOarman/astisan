import 'package:artisan/app/modules/client/activity/views/wideget/commonorderlist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';

class  Upcoming extends StatelessWidget {
  const  Upcoming({super.key});

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

                statusText: "Upcoming",
                statusBgColor: Colors.blue.withOpacity(0.1),
                statusTextColor: Colors.blue,
                amountColor: Colors.green,

                // Buttons Logic
                viewDetailsButtonText: "View Details",
                onViewDetailsTap: () {
                  Get.toNamed(Routes.TRACKINGSCREEN);
                },

              ),

              SizedBox(height: 10,),

              CustomBookingCard(
                title: "Full House Cleaning",
                providerName: "Sarah Ahmed",
                date: "March 15, 2026",
                amount: "\$160",
                imageUrl: "assets/images/Image (9).png",

                // Status Style (Upcoming/Rejected এর জন্য একই কালার ব্যবহার করতে পারেন)
                statusText: "Upcoming",
                statusBgColor: Colors.blue.withOpacity(0.1),
                statusTextColor: Colors.blue,
                amountColor: Colors.green, // টাকার কালার আলাদা করতে পারেন

                // Buttons Logic
                viewDetailsButtonText: "See More",
                onViewDetailsTap: () {
                  print("Navigating to details...");
                },

                // Rate এবং Rebook বাটন দরকার নেই, তাই এদের tap ফাংশনগুলো পাঠানো হয়নি।
              )
            ],


          ),
        ),
      ),

    );
  }
}
