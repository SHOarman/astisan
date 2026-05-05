import 'dart:async';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class VerificationController extends GetxController {
  final email = ''.obs;
  final otpCode = ''.obs;
  final timerSeconds = 35.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['email'] != null) {
      email.value = Get.arguments['email'];
    } else {
      email.value = 'example@gmail.com';
    }
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    timerSeconds.value = 35;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void resendCode() {
    if (timerSeconds.value == 0) {
      startTimer();
      Get.snackbar('Code Resent', 'A new verification code has been sent to ${email.value}');
    }
  }

  void verify() {
    if (otpCode.value.length == 6) {
      Get.toNamed(Routes.RESET_PASSWORD);
    } else {
      Get.snackbar('Invalid Code', 'Please enter a 6-digit verification code.');
    }
  }
}

