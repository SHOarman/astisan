import 'package:artisan/app/modules/client/activity/views/wideget/commonorderlist.dart';
import 'package:flutter/material.dart';

class Cancelle extends StatelessWidget {
  const Cancelle({super.key});

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

                statusText: "Cancelled",
                statusBgColor: Colors.white30 ,
                statusTextColor: Colors.red,               // নীল টেক্সট

                onRateTap: null,
                onRebookTap: null,


              ),
              SizedBox(height: 10,),
              CustomBookingCard(
                title: "Full House Cleaning",
                providerName: "Sarah Ahmed",
                date: "March 15, 2026",
                amount: "\$160",
                imageUrl: "assets/images/Image (9).png",

                statusText: "Cancelled",
                statusBgColor: Colors.white30 ,
                statusTextColor: Colors.red,               // নীল টেক্সট

                onRateTap: null,
                onRebookTap: null,


              ),
              SizedBox(height: 10,),
              CustomBookingCard(
                title: "Full House Cleaning",
                providerName: "Sarah Ahmed",
                date: "March 15, 2026",
                amount: "\$160",
                imageUrl: "assets/images/Image (9).png",

                statusText: "Cancelled",
                statusBgColor: Colors.white30 ,
                statusTextColor: Colors.red,               // নীল টেক্সট

                onRateTap: null,
                onRebookTap: null,


              ),
              SizedBox(height: 10,),

            ],
          ),
        ),
      ),




    );
  }
}
