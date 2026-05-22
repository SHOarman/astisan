import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class PaymentController extends GetxController {
  final cardholderNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final branchNameController = TextEditingController();

  final booking = Rxn<Map<String, dynamic>>();
  final serviceName = "".obs;
  final jobId = "".obs;
  final baseFee = "0.0".obs;
  final platformFee = "0.0".obs;
  final totalAmount = "0.0".obs;
  final costItems = <Map<String, String>>[].obs;

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
    
    serviceName.value = b['service_name'] ?? "Service";
    jobId.value = b['booking_id'] ?? b['id'] ?? "Unknown";
    
    double baseVal = double.tryParse(b['base_price']?.toString() ?? '0') ?? 0.0;
    baseVal = baseVal.abs();
    if (baseVal == 0.0) {
      baseVal = double.tryParse(b['total_amount']?.toString() ?? '0') ?? 0.0;
      baseVal = baseVal.abs();
    }

    double approvedCostsSum = 0.0;
    final itemsList = <Map<String, String>>[];
    itemsList.add({
      'title': 'Service base fee',
      'amount': '\$${baseVal.toStringAsFixed(2)}',
    });

    final costs = b['additional_costs'];
    if (costs is List) {
      for (var c in costs) {
        if (c is Map) {
          final String status = (c['status'] ?? '').toString().toLowerCase();
          if (status == 'approved') {
            final String reason = c['reason'] ?? 'Additional Cost';
            final double amountVal = double.tryParse(c['amount']?.toString() ?? '0') ?? 0.0;
            approvedCostsSum += amountVal;
            itemsList.add({
              'title': reason,
              'amount': '\$${amountVal.toStringAsFixed(2)}',
            });
          }
        }
      }
    }

    costItems.assignAll(itemsList);

    final double subtotal = baseVal + approvedCostsSum;
    double pFee = subtotal * 0.05;
    double tDue = subtotal + pFee;
    
    baseFee.value = "\$${baseVal.toStringAsFixed(2)}";
    platformFee.value = "\$${pFee.toStringAsFixed(2)}";
    totalAmount.value = "\$${tDue.toStringAsFixed(2)}";
  }

  void processPayment() {
    // Mock payment processing
    Get.toNamed(Routes.PAYMENT_SUCCESS, arguments: booking.value);
  }

  @override
  void onClose() {
    cardholderNameController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    branchNameController.dispose();
    super.onClose();
  }
}

