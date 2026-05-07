import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/Services/api_services.dart';
import '../../../../core/routes/app_routes.dart';

class VerificationController extends GetxController {
  final email = ''.obs;
  final phone = ''.obs;
  final referralCode = ''.obs;
  final otpCode = ''.obs;
  final timerSeconds = 300.obs;
  final isLoading = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      email.value = Get.arguments['email'] ?? '';
      phone.value = Get.arguments['phone'] ?? '';
      referralCode.value = Get.arguments['referral_code'] ?? '';
    }
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    timerSeconds.value = 300;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> resendCode() async {
    if (timerSeconds.value == 0 && !isLoading.value) {
      isLoading.value = true;
      try {
        final response = await http.post(
          Uri.parse(ApiServices.client_sendotp),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({"email": email.value}),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          startTimer();
          Get.snackbar('Success', 'A new code has been sent.');
        } else {
          final data = json.decode(response.body);
          Get.snackbar('Error', data['message'] ?? 'Failed to resend code');
        }
      } catch (e) {
        Get.snackbar('Error', 'Connection failed');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> verify() async {
    if (otpCode.value.length == 6) {
      Get.focusScope?.unfocus();
      isLoading.value = true;

      try {
        final Map<String, dynamic> requestBody = {
          "email": email.value,
          "otp": otpCode.value,
          "referral_code": referralCode.value,
        };

        final response = await http.post(
          Uri.parse(ApiServices.client_reg),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(requestBody),
        );

        final data = json.decode(response.body);

        print("Status: ${response.statusCode}");
        print("Data: $data");

        if (response.statusCode == 200 || response.statusCode == 201) {

          Get.snackbar('Success', data['message'] ?? 'Verification successful!');
          
          FocusManager.instance.primaryFocus?.unfocus();
          await Future.delayed(const Duration(milliseconds: 250));
          
          Get.offAllNamed(Routes.LOGIN);

        } else {
          Get.snackbar('Error', data['message'] ?? 'Invalid OTP, please try again.');
        }
      } catch (e) {
        Get.snackbar('Error', 'Connection failed. Try again.');
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar('Invalid Code', 'Please enter a 6-digit verification code.');
    }
  }
}