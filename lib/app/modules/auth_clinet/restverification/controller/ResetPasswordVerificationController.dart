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
  final timerSeconds = 600.obs;
  final isLoading = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) email.value = Get.arguments['email'] ?? '';
    startTimer();
  }

  @override
  void onClose() { _timer?.cancel(); super.onClose(); }

  void startTimer() {
    timerSeconds.value = 600;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) timerSeconds.value--; else timer.cancel();
    });
  }

  Future<void> verify() async {
    if (otpCode.value.length == 6) {
      Get.focusScope?.unfocus();
      isLoading.value = true;
      try {
        final response = await http.post(
          Uri.parse(ApiServices.forgot_password_verify),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({"email": email.value, "otp": otpCode.value}),
        );
        final data = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          FocusManager.instance.primaryFocus?.unfocus();
          Get.focusScope?.unfocus();
          
          await Future.delayed(const Duration(milliseconds: 400));
          
          Get.offNamed(Routes.RESET_PASSWORD, arguments: {'reset_token': data['reset_token']});
        } else {
          Get.snackbar('Error', data['message'] ?? 'Invalid OTP');
        }
      } catch (e) { Get.snackbar('Error', 'Failed to verify'); } finally { isLoading.value = false; }
    }
  }

  Future<void> resendCode() async {
    if (timerSeconds.value == 0 && !isLoading.value) {
      isLoading.value = true;
      try {
        await http.post(Uri.parse(ApiServices.forgot_password_init), headers: {'Content-Type': 'application/json'}, body: json.encode({"email": email.value}));
        startTimer();
        Get.snackbar('Success', 'OTP Resent');
      } finally { isLoading.value = false; }
    }
  }
}