import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../core/Services/api_services.dart';
import '../../../core/global_controllers/role_controller.dart';
import '../../../core/routes/app_routes.dart';

class AuthWorkerController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final loginFormKey = GlobalKey<FormState>();

  // TextEditingControllers
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController rateController;

  final selectedCategoryId = ''.obs;
  final selectedCategoryName = ''.obs;
  final selectedServiceId = ''.obs;
  final selectedServiceName = ''.obs;

  final categories = <dynamic>[].obs;
  final services = <dynamic>[].obs;
  final isCategoriesLoading = false.obs;
  final isServicesLoading = false.obs;

  final priceMin = 0.0.obs;
  final priceMax = 0.0.obs;

  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final agreeToTerms = false.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    rateController = TextEditingController();
    fetchCategories();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // --- API Functions ---

  Future<void> fetchCategories() async {
    isCategoriesLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(ApiServices.services_categories),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        List<dynamic> results = [];
        if (data is Map && data.containsKey('results')) {
          results = data['results'];
        } else if (data is List) {
          results = data;
        }

        if (results.isNotEmpty) {
          categories.assignAll(results);
        } else {
          _loadFallbackCategories();
        }
      } else {
        _loadFallbackCategories();
      }
    } catch (e) {
      _loadFallbackCategories();
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  void _loadFallbackCategories() {
    categories.assignAll([
      {
        'id': 'fc01a070-0d15-4706-b36d-252cc3a366fe',
        'name': 'REPAIR & MAINTENANCE',
      },
      {
        'id': 'ba747375-cfd4-4669-bd12-c534bf40c83b',
        'name': 'CLEANING SERVICE',
      },
    ]);
  }

  Future<void> fetchServices(String catId) async {
    isServicesLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      final String url = "${ApiServices.category_services}$catId/services/";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        List<dynamic> results = [];
        if (data is Map && data.containsKey('results')) {
          results = data['results'];
        } else if (data is List) {
          results = data;
        }
        services.assignAll(results);
      } else {
        services.assignAll([
          {
            'id': 's1',
            'name': 'General Service',
            'price_range_min': '100',
            'price_range_max': '500',
          },
          {
            'id': 's2',
            'name': 'Deep Cleaning',
            'price_range_min': '200',
            'price_range_max': '800',
          },
        ]);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isServicesLoading.value = false;
    }
  }

  // --- Logic Functions ---

  void onCategoryChanged(String? id) {
    if (id != null) {
      selectedCategoryId.value = id;
      final cat = categories.firstWhere((element) => element['id'] == id);
      selectedCategoryName.value = cat['name'];
      selectedServiceId.value = '';
      selectedServiceName.value = '';
      services.clear();
      fetchServices(id);
    }
  }

  void onServiceChanged(String? id) {
    if (id != null) {
      selectedServiceId.value = id;
      final service = services.firstWhere((element) => element['id'] == id);
      selectedServiceName.value = service['name'];

      priceMin.value =
          double.tryParse(service['price_range_min']?.toString() ?? '0') ?? 0;
      priceMax.value =
          double.tryParse(service['price_range_max']?.toString() ?? '0') ?? 0;

      rateController.text = priceMin.value.toStringAsFixed(0);
    }
  }

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;
  void toggleTermsAgreement(bool? value) {
    if (value != null) agreeToTerms.value = value;
  }

  void toggleRememberMe(bool? value) {
    if (value != null) rememberMe.value = value;
  }

  // void signIn() async {
  //   if (loginFormKey.currentState?.validate() ?? false) {
  //     Get.focusScope?.unfocus();
  //     isLoading.value = true;
  //
  //     try {
  //       print("Attempting Artisan Login: ${emailController.text.trim()}");
  //       final response = await http
  //           .post(
  //             Uri.parse(ApiServices.artisan_login),
  //             headers: {
  //               'Content-Type': 'application/json',
  //               'Accept': 'application/json',
  //             },
  //             body: json.encode({
  //               "email": emailController.text.trim().toLowerCase(),
  //               "password": passwordController.text,
  //             }),
  //           )
  //           .timeout(const Duration(seconds: 15));
  //
  //       print("Login Status: ${response.statusCode}");
  //       print("Login Body: ${response.body}");
  //
  //       final data = json.decode(response.body);
  //       print("Decoded Login Data: $data");
  //
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         final SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //         // Robust token extraction
  //         String? accessToken;
  //         String? refreshToken;
  //
  //         if (data is Map) {
  //           accessToken =
  //               data['access'] ?? data['token'] ?? data['access_token'];
  //           refreshToken = data['refresh'] ?? data['refresh_token'];
  //
  //           // Check inside 'data' or 'results' if nested
  //           if (accessToken == null &&
  //               data['data'] != null &&
  //               data['data'] is Map) {
  //             accessToken = data['data']['access'] ?? data['data']['token'];
  //             refreshToken ??= data['data']['refresh'];
  //           }
  //         }
  //
  //         print("Extracted Token: $accessToken");
  //
  //         if (accessToken != null) {
  //           await prefs.setString('token', accessToken.toString());
  //           if (refreshToken != null) {
  //             await prefs.setString('refresh', refreshToken.toString());
  //           }
  //
  //           await prefs.setString('role', 'worker');
  //           Get.find<RoleController>().setRole('worker');
  //
  //           Get.snackbar('Success', 'Login Successful!');
  //           Get.offAllNamed(Routes.DASHBOARD);
  //         } else {
  //           data.forEach((key, value) {
  //             if (key.toString().toLowerCase().contains('token') ||
  //                 (value is String && value.length > 50)) {
  //               accessToken ??= value.toString();
  //             }
  //           });
  //
  //           if (accessToken != null) {
  //             // await prefs.setString('token', accessToken!);
  //             // Get.offAllNamed(Routes.worker_deshbord_user);
  //           } else {
  //             _showErrorSnackBar(
  //               'Login Debug',
  //               'Response: ${response.body.length > 100 ? response.body.substring(0, 100) : response.body}',
  //             );
  //           }
  //         }
  //       } else {
  //         String msg = 'Login failed';
  //         if (data is Map) {
  //           msg = data['message'] ?? data['detail'] ?? msg;
  //         }
  //         _showErrorSnackBar('Login Error', msg);
  //       }
  //     } catch (e) {
  //       print("Login Exception: $e");
  //       _showErrorSnackBar(
  //         'Connection Error',
  //         'Please check your internet connection',
  //       );
  //     } finally {
  //       isLoading.value = false;
  //     }
  //   }
  // }
  void signIn() async {
    if (loginFormKey.currentState?.validate() ?? false) {
      Get.focusScope?.unfocus();
      isLoading.value = true;

      try {
        final response = await http
            .post(
          Uri.parse(ApiServices.artisan_login),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({
            "email": emailController.text.trim().toLowerCase(),
            "password": passwordController.text,
          }),
        )
            .timeout(const Duration(seconds: 15));

        final data = json.decode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          String? accessToken;
          String? refreshToken;

          if (data is Map) {
            accessToken = data['access'] ??
                data['token'] ??
                data['access_token'] ??
                (data['data'] is Map ? (data['data']['access'] ?? data['data']['token'] ?? data['data']['access_token']) : null);

            refreshToken = data['refresh'] ??
                data['refresh_token'] ??
                (data['data'] is Map ? (data['data']['refresh'] ?? data['data']['refresh_token']) : null);

            if (accessToken == null && data is Map) {
              data.forEach((key, value) {
                if (key.toString().toLowerCase().contains('token') && value is String && value.length > 20) {
                  accessToken = value;
                }
              });
            }
          }

          if (accessToken != null) {
            String cleanAccessToken = _cleanToken(accessToken.toString());
            print("DEBUG: Final Clean Token: $cleanAccessToken (Length: ${cleanAccessToken.length})");
            await prefs.setString('token', cleanAccessToken);

            if (refreshToken != null) {
              await prefs.setString('refresh', _cleanToken(refreshToken.toString()));
            }

            await prefs.setString('role', 'worker');
            Get.find<RoleController>().setRole('worker');

            await fetchAndSaveProfile(accessToken.toString());

            Get.snackbar('Success', 'Login Successful!');
            Get.offAllNamed(Routes.DASHBOARD);
          } else {
            print("CRITICAL ERROR: Token not found in Login Response.");
            print("FULL RESPONSE BODY: ${response.body}");

            // One last attempt: search the entire decoded map for ANY long string
            String? fallbackToken;
            if (data is Map) {
              void findToken(Map map) {
                map.forEach((key, value) {
                  if (value is String && value.length > 30) {
                    fallbackToken = value;
                  } else if (value is Map) {
                    findToken(value);
                  }
                });
              }
              findToken(data);
            }

            if (fallbackToken != null) {
              print("DEBUG: Found fallback token: $fallbackToken");
              await prefs.setString('token', fallbackToken!);
              await prefs.setString('role', 'worker');
              Get.find<RoleController>().setRole('worker');
              await fetchAndSaveProfile(fallbackToken!);
              Get.offAllNamed(Routes.DASHBOARD);
            } else {
              _showErrorSnackBar('Login Error', 'The server did not send a valid session token. Response: ${response.body}');
            }
          }
        } else {
          String msg = 'Login failed';
          final data = json.decode(response.body);
          if (data is Map) {
            msg = data['message'] ?? data['detail'] ?? msg;
          }
          _showErrorSnackBar('Login Error', msg);
        }
      } catch (e) {
        _showErrorSnackBar('Connection Error', 'Please check your internet connection');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> fetchAndSaveProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiServices.artisan_profile),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("DEBUG: Login Response Body: ${response.body}");
        final data = json.decode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', data['full_name'] ?? '');
        await prefs.setString('user_profile_pic', data['profile_picture'] ?? '');
        print("DEBUG: Profile saved locally after login");
      }
    } catch (e) {
      print("DEBUG: Error saving profile after login: $e");
    }
  }





  void signUp() async {
    if (formKey.currentState!.validate()) {
      if (!agreeToTerms.value) {
        _showErrorSnackBar(
          'Terms & Privacy',
          'You must agree to the terms and privacy policy',
        );
        return;
      }

      if (selectedServiceId.value.isEmpty) {
        _showErrorSnackBar(
          'Service Selection',
          'Please select a category and a service',
        );
        return;
      }

      double enteredRate = double.tryParse(rateController.text) ?? 0;
      if (enteredRate < priceMin.value || enteredRate > priceMax.value) {
        _showErrorSnackBar(
          'Price Range Warning',
          'Allowed range: ${priceMin.value} to ${priceMax.value}.',
        );
        return;
      }

      Get.focusScope?.unfocus();
      isLoading.value = true;

      try {
        final response = await http
            .post(
          Uri.parse(ApiServices.artisan_sendotp),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "full_name": nameController.text.trim(),
            "email": emailController.text.trim().toLowerCase(),
            "phone": phoneController.text.trim(),
            "password": passwordController.text,
          }),
        )
            .timeout(const Duration(seconds: 15));

        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.snackbar('Success', 'OTP sent to your email');
          Get.toNamed(
            Routes.VERIFICATION,
            arguments: {
              'email': emailController.text.trim(),
              'data': {
                "full_name": nameController.text.trim(),
                "email": emailController.text.trim(),
                "phone": phoneController.text.trim(),
                "password": passwordController.text,
                "service_id": selectedServiceId.value,
                "service_rate": rateController.text,
                "role": "artisan",
              },
              'role': 'artisan',
            },
          );
        } else {
          _showErrorSnackBar('Error', 'Registration failed');
        }
      } catch (e) {
        _showErrorSnackBar('Connection Error', e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }

  void _showErrorSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  void navigateToSignUp() {
    Get.toNamed(Routes.sing_up);
  }

  void navigateToLogin() {
    Get.back();
  }

  void onSocialLogin(String provider) {
    Get.snackbar(
      'Social Login',
      'Clicked on $provider',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String _cleanToken(String token) {
    String clean = token.toString().trim();
    if (clean.startsWith('"') && clean.endsWith('"')) {
      clean = clean.substring(1, clean.length - 1);
    }
    if (clean.toLowerCase().startsWith("bearer ")) {
      clean = clean.substring(7).trim();
    }
    return clean;
  }
}
