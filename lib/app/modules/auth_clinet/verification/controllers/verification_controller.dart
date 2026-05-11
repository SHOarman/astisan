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
  final fullName = ''.obs;
  final password = ''.obs;
  final timerSeconds = 60.obs;
  final isLoading = false.obs;
  Timer? _timer;

  final role = 'client'.obs;
  final artisanData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      // Handle different argument structures
      if (Get.arguments is Map) {
        role.value = Get.arguments['role'] ?? 'client';
        
        if (role.value == 'artisan') {
          final data = Get.arguments['data'] ?? {};
          artisanData.value = data;
          fullName.value = data['full_name'] ?? '';
          email.value = data['email'] ?? '';
          phone.value = data['phone'] ?? '';
          password.value = data['password'] ?? '';
        } else {
          fullName.value = Get.arguments['full_name'] ?? '';
          email.value = Get.arguments['email'] ?? '';
          phone.value = Get.arguments['phone'] ?? '';
          password.value = Get.arguments['password'] ?? '';
          referralCode.value = Get.arguments['referral_code'] ?? '';
        }
      }
    }
    print("Verification started for Role: ${role.value}, Email: ${email.value}");
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

  Future<void> resendCode() async {
    if (timerSeconds.value == 0 && !isLoading.value) {
      isLoading.value = true;
      try {
        final Map<String, dynamic> requestBody = {
          "full_name": fullName.value,
          "email": email.value,
          "phone": phone.value,
          "password": password.value,
        };

        if (referralCode.value.isNotEmpty) {
          requestBody["referral_code"] = referralCode.value;
        }

        final String url = role.value == 'artisan' 
            ? ApiServices.artisan_sendotp 
            : ApiServices.client_sendotp;

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(requestBody),
        );

        print("Resend Response [${role.value}]: ${response.body}");

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
      FocusManager.instance.primaryFocus?.unfocus();
      Get.focusScope?.unfocus();
      await Future.delayed(const Duration(milliseconds: 100));
      
      isLoading.value = true;

      try {
        final Map<String, dynamic> requestBody = {
          "email": email.value,
          "otp": otpCode.value,
          if (referralCode.value.isNotEmpty) "referral_code": referralCode.value,
        };

        final String verifyUrl = role.value == 'artisan' 
            ? ApiServices.artisan_reg 
            : ApiServices.client_reg;

        print("Verifying [${role.value}] at $verifyUrl");
        final response = await http.post(
          Uri.parse(verifyUrl),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(requestBody),
        );

        print("Verify Response Status: ${response.statusCode}");
        print("Verify Response Body: ${response.body}");

        final data = json.decode(response.body);
        print("Decoded Verify Data: $data");

        if (response.statusCode == 200 || response.statusCode == 201) {
          // If Artisan, we need to set up their service AFTER account confirmation
          if (role.value == 'artisan') {
            String? accessToken;
            // Handle different token locations in response (including access_token at root)
            if (data['data'] != null && data['data'] is Map) {
              accessToken = data['data']['access'] ?? data['data']['token'] ?? data['data']['access_token'];
            }
            accessToken ??= data['access_token'] ?? data['access'] ?? data['token'] ?? (data['tokens'] != null ? data['tokens']['access'] : null);
            
            print("DEBUG: Extracted Token for Service Setup: $accessToken");
            
            if (accessToken != null && artisanData['service_id'] != null && artisanData['service_id'].toString().isNotEmpty) {
              await _setupArtisanService(accessToken.toString().trim().replaceAll('"', ''));
            } else {
              print("DEBUG: Skipping service setup. Token or ServiceId missing. Token: $accessToken, ServiceId: ${artisanData['service_id']}");
            }
          }

          Get.snackbar('Success', data['message'] ?? 'Verification successful!');
          await Future.delayed(const Duration(milliseconds: 1000));
          Get.offAllNamed(Routes.sing_in);
        } else {
          Get.snackbar('Error', data['message'] ?? 'Invalid OTP, please try again.');
        }
      } catch (e) {
        print("Verify Exception: $e");
        Get.snackbar('Error', 'Connection failed. Try again.');
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar('Invalid Code', 'Please enter a 6-digit verification code.');
    }
  }

  Future<void> _setupArtisanService(String token) async {
    try {
      String cleanToken = token;
      if (cleanToken.toLowerCase().startsWith("bearer ")) cleanToken = cleanToken.substring(7).trim();

      print("DEBUG: Hitting Service Setup API: ${ApiServices.artisan_my_services}");
      print("DEBUG: Payload: service=${artisanData['service_id']}, rate=${artisanData['service_rate']}");

      final response = await http.post(
        Uri.parse(ApiServices.artisan_my_services),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $cleanToken',
        },
        body: json.encode({
          "service": artisanData['service_id'],
          "price_override": artisanData['service_rate'],
          "is_active": true
        }),
      ).timeout(const Duration(seconds: 15));

      print("DEBUG: Service Setup Response (${response.statusCode}): ${response.body}");
    } catch (e) {
      print("DEBUG: Service Setup Exception: $e");
    }
  }
}