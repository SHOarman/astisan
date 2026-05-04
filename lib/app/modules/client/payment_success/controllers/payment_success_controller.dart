import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../core/routes/app_routes.dart';
import '../views/rating_view.dart';

class PaymentSuccessController extends GetxController {
  final RxInt rating = 0.obs;
  final RxBool isReviewSubmitted = false.obs;
  final RxBool isLoadingHome = false.obs;
  final TextEditingController reviewController = TextEditingController();

  Future<void> backToHome() async {
    isLoadingHome.value = true;
    
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1800));
    
    Get.snackbar(
      "Success",
      "Successfully completed! Redirecting...",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
    
    Get.offAllNamed(Routes.DASHBOARD);
    isLoadingHome.value = false;
  }

  Future<void> downloadOrPrintReceipt() async {
    Get.snackbar(
      "Receipt",
      "Preparing receipt...",
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
      Get.snackbar("Error", "Could not generate receipt: $e");
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

  void submitReview() {
    if (rating.value == 0) {
      Get.snackbar('Oops', 'Please provide a star rating.');
      return;
    }
    isReviewSubmitted.value = true;
  }
}

