import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/Services/api_services.dart';
import '../../../../core/routes/app_routes.dart';

class ResetPasswordVerificationController extends GetxController {
  final email = ''.obs;
  final otpCode = ''.obs;
  final timerSeconds = 60.obs;
  final isLoading = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) email.value = Get.arguments['email'] ?? '';
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    timerSeconds.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> verify() async {
    if (otpCode.value.length < 6) {
      Get.snackbar('Error', 'Please enter a valid 6-digit OTP');
      return;
    }

    // Robust unfocusing to prevent "attached: is not true" assertion errors
    FocusManager.instance.primaryFocus?.unfocus();
    Get.focusScope?.unfocus();
    
    // Small delay to allow focus transition to settle
    await Future.delayed(const Duration(milliseconds: 100));
    
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(ApiServices.forgot_password_verify),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({"email": email.value, "otp": otpCode.value}),
      );
      
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'OTP Verified Successfully');
        
        // Wait for snackbar and focus state to settle before navigation
        await Future.delayed(const Duration(milliseconds: 600));
        
        Get.offNamed(Routes.RESET_PASSWORD, arguments: {
          'reset_token': data['reset_token'],
          'email': email.value
        });
      } else {
        Get.snackbar('Error', data['message'] ?? 'Invalid OTP');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to verify OTP. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendCode() async {
    if (timerSeconds.value > 0 || isLoading.value) return;

    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(ApiServices.forgot_password_init),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({"email": email.value}),
      );

      print("Forgot Password Resend Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        startTimer();
        Get.snackbar('Success', 'OTP Resent Successfully');
      } else {
        final data = json.decode(response.body);
        Get.snackbar('Error', data['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to resend OTP. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}