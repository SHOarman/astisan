import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/routes/app_routes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/Services/api_services.dart';
import '../views/rating_view.dart';
import '../../activity/controllers/activity_controller.dart';
import '../../../dashboard/controllers/dashboard_controller.dart';

class PaymentSuccessController extends GetxController {
  final RxInt rating = 0.obs;
  final RxBool isReviewSubmitted = false.obs;
  final RxBool isLoadingHome = false.obs;
  final RxBool isSubmittingReview = false.obs;
  final TextEditingController reviewController = TextEditingController();

  final booking = Rxn<Map<String, dynamic>>();
  final serviceName = "Service".obs;
  final artisanName = "Artisan".obs;
  final amountPaid = "0.00".obs;
  final bookingId = "".obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      booking.value = Get.arguments;
      _parseBookingData();
    }
  }

  void _parseBookingData() {
    final b = booking.value;
    if (b == null) return;
    
    // The review API requires the UUID of the booking. Usually this is 'id'.
    // If 'id' is a UUID, use it. Otherwise fallback to 'booking_id'.
    final idVal = b['id']?.toString() ?? "";
    final bookingIdVal = b['booking_id']?.toString() ?? "";
    bookingId.value = idVal.length > 20 ? idVal : bookingIdVal;
    
    serviceName.value = b['service_name'] ?? "Service";
    
    final artisan = b['artisan'] is Map ? b['artisan'] : b;
    artisanName.value = b['artisan_name'] ?? artisan['name'] ?? artisan['full_name'] ?? "Artisan";
    
    double rawAmount = double.tryParse(b['total_amount']?.toString() ?? '0') ?? 0.0;
    rawAmount = rawAmount.abs();
    double pFee = rawAmount * 0.05;
    double tDue = rawAmount + pFee;
    amountPaid.value = "\$${tDue.toStringAsFixed(2)}";
  }

  Future<void> backToHome() async {
    isLoadingHome.value = true;

    // Move booking card to Completed tab locally
    _markBookingClientPaid();
    
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1800));
    
    Get.snackbar("Success".tr, "Successfully completed! Redirecting...".tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
    
    // Ensure dashboard starts at home
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().changePage(0);
    }
    
    Get.offAllNamed(Routes.DASHBOARD);
    isLoadingHome.value = false;
  }

  /// Locally marks this booking as 'client_paid' so the ActivityController
  /// moves it from the Confirmed tab to the Completed tab.
  void _markBookingClientPaid() {
    final id = bookingId.value;
    if (id.isEmpty) return;
    if (Get.isRegistered<ActivityController>()) {
      Get.find<ActivityController>().updateBookingStatusLocally(id, 'client_paid');
    }
  }

  Future<void> downloadOrPrintReceipt() async {
    Get.snackbar("Receipt".tr, "Preparing receipt...".tr,
      snackPosition: SnackPosition.BOTTOM,
    );

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(40),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Transaction Receipt', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 20),
                  pw.Divider(),
                  pw.SizedBox(height: 20),
                  _buildReceiptRow('Transaction ID', 'TXN-2026-FX4821-7283'),
                  _buildReceiptRow('Service', 'Pipe Repair'),
                  _buildReceiptRow('Artisan', 'James Wilson'),
                  _buildReceiptRow('Date', 'April 7, 2026'),
                  _buildReceiptRow('Time', '10:18 AM - 11:54 AM'),
                  _buildReceiptRow('Payment Method', 'Visa...4242'),
                  pw.SizedBox(height: 20),
                  pw.Divider(),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Amount Paid', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text('\$121.25', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
                    ],
                  ),
                  pw.SizedBox(height: 40),
                  pw.Center(child: pw.Text('Thank you for choosing Artisan!', style: const pw.TextStyle(color: PdfColors.grey))),
                ],
              ),
            );
          },
        ),
      );

      // Trigger the native print/share dialog
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'artisan_receipt_TXN-2026.pdf',
      );
    } catch (e) {
      Get.snackbar("Error".tr, "Could not generate receipt: $e".tr);
    }
  }

  pw.Widget _buildReceiptRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(color: PdfColors.grey)),
          pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  void rateNow() {
    Get.to(() => const RatingView(), fullscreenDialog: true);
  }

  Future<void> submitReview() async {
    if (rating.value == 0) {
      Get.snackbar('Oops'.tr, 'Please provide a star rating.'.tr);
      return;
    }
    
    isSubmittingReview.value = true;
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.trim().replaceAll('"', '');

      final url = Uri.parse('${ApiServices.baseurl}/api/reviews/client/submit/');
      final response = await http.post(
        url,
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'booking_id': bookingId.value,
          'rating': rating.value,
          'comment': reviewController.text,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        isReviewSubmitted.value = true;
        // Move booking card to Completed tab locally after review
        _markBookingClientPaid();
        Get.snackbar('Success'.tr, 'Review submitted successfully!'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        print("Review API Error: ${response.statusCode} - ${response.body}");
        Get.snackbar('Error'.tr, 'Failed to submit review: ${response.body}'.tr);
      }
    } catch (e) {
      print("Review API Exception: $e");
      Get.snackbar('Error'.tr, 'An error occurred while submitting the review: $e'.tr);
    } finally {
      isSubmittingReview.value = false;
    }
  }
}

