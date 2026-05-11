import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../core/Services/api_services.dart';
import '../../../core/global_controllers/role_controller.dart';
import '../../../core/routes/app_routes.dart';

class AuthWorkerController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final loginFormKey = GlobalKey<FormState>();

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

  Future<void> fetchCategories() async {
    isCategoriesLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      // Attempt 1: With Trailing Slash (Standard)
      String url1 = ApiServices.services_categories;
      if (!url1.endsWith('/')) url1 += '/';

      print("DEBUG: Category Fetch Attempt 1: $url1");
      final resp1 = await http
          .get(Uri.parse(url1), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));
      print("DEBUG: Attempt 1 Status: ${resp1.statusCode}");

      if (resp1.statusCode == 200) {
        final data = json.decode(resp1.body);
        List<dynamic> results = _extractResults(data);
        if (results.isNotEmpty) {
          categories.assignAll(results);
          print("DEBUG: Successfully loaded ${results.length} categories");
          return;
        }
      }

      // Attempt 2: Without Trailing Slash
      String url2 = url1.substring(0, url1.length - 1);
      print("DEBUG: Category Fetch Attempt 2: $url2");
      final resp2 = await http
          .get(Uri.parse(url2), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));
      print("DEBUG: Attempt 2 Status: ${resp2.statusCode}");

      if (resp2.statusCode == 200) {
        final data = json.decode(resp2.body);
        List<dynamic> results = _extractResults(data);
        if (results.isNotEmpty) {
          categories.assignAll(results);
          return;
        }
      }

      // Attempt 3: Artisan Catalogue Categories
      String artisanUrl = ApiServices.artisan_service_categories;
      print("DEBUG: Category Fetch Attempt 3 (Artisan): $artisanUrl");
      final resp3 = await http
          .get(Uri.parse(artisanUrl), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (resp3.statusCode == 200) {
        final data = json.decode(resp3.body);
        List<dynamic> results = _extractResults(data);
        if (results.isNotEmpty) {
          categories.assignAll(results);
          return;
        }
      }
    } catch (e) {
      print("DEBUG: Critical Category Error: $e");
    } finally {
      if (categories.isEmpty) {
        print("DEBUG: All API attempts failed, using fallback labels");
        _loadFallbackCategories();
      }
      isCategoriesLoading.value = false;
    }
  }

  List<dynamic> _extractResults(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;
    if (data is Map) {
      if (data.containsKey('results') && data['results'] is List)
        return data['results'];
      if (data.containsKey('data') && data['data'] is List) return data['data'];
    }
    return [];
  }

  Future<void> fetchServices(String catId) async {
    isServicesLoading.value = true;
    services.clear(); // Clear old data to show we are loading fresh
    try {
      // 1. Try Artisan Catalogue Primary (Filtered by Category)
      String artisanUrl = ApiServices.artisan_service_catalogue;
      if (artisanUrl.endsWith('/'))
        artisanUrl = artisanUrl.substring(0, artisanUrl.length - 1);
      artisanUrl = "$artisanUrl?category=$catId";

      print("DEBUG: Fetching services from Artisan API: $artisanUrl");
      final response = await http
          .get(Uri.parse(artisanUrl), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> results = _extractResults(data);
        if (results.isNotEmpty) {
          services.assignAll(results);
          print(
            "DEBUG: Loaded ${results.length} services from Artisan Catalogue",
          );
          return;
        }
      }

      // 2. Fallback to Client Public Categories Endpoint
      String clientUrl = ApiServices.category_services;
      if (!clientUrl.endsWith('/')) clientUrl += '/';
      clientUrl = "$clientUrl$catId/services/";

      print("DEBUG: Trying fallback Client API: $clientUrl");
      final clientResponse = await http
          .get(Uri.parse(clientUrl), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (clientResponse.statusCode == 200) {
        final data = json.decode(clientResponse.body);
        List<dynamic> results = _extractResults(data);
        if (results.isNotEmpty) {
          services.assignAll(results);
          print("DEBUG: Loaded ${results.length} services from Client API");
          return;
        }
      }
    } catch (e) {
      print("DEBUG: Service fetch error: $e");
    } finally {
      if (services.isEmpty) {
        print("DEBUG: No services found on server for category $catId");
        // We do NOT load dummy data here as requested
      }
      isServicesLoading.value = false;
    }
  }

  void _loadFallbackCategories() {
    // Keep a very minimal fallback only for critical failure
    categories.assignAll([
      {'id': 'repair', 'name': 'REPAIR & MAINTENANCE'},
      {'id': 'cleaning', 'name': 'CLEANING SERVICE'},
    ]);
  }

  void _loadFallbackServices() {
    // Empty as requested, no dummy data
    services.clear();
  }

  void onCategoryChanged(String? id) {
    if (id != null) {
      selectedCategoryId.value = id;
      final cat = categories.firstWhere(
        (element) => element['id'].toString() == id,
      );
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
      final service = services.firstWhere(
        (element) => element['id'].toString() == id,
      );
      selectedServiceName.value = service['name'];
      priceMin.value =
          double.tryParse(service['price_range_min']?.toString() ?? '0') ?? 0;
      priceMax.value =
          double.tryParse(service['price_range_max']?.toString() ?? '0') ?? 0;
      rateController.text = priceMin.value.toStringAsFixed(0);
    }
  }

  void navigateToSignUp() {
    Get.toNamed(Routes.sing_up);
  }

  void navigateToLogin() {
    Get.back();
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
          String? accessToken = _extractToken(data);
          if (accessToken != null) {
            String cleanToken = _cleanToken(accessToken);
            await prefs.setString('token', cleanToken);
            await prefs.setString('role', 'worker');
            Get.find<RoleController>().setRole('worker');
            await fetchAndSaveProfile(cleanToken);
            Get.snackbar('Success', 'Login Successful!');
            Get.offAllNamed(Routes.DASHBOARD);
          } else {
            _showErrorSnackBar('Login Error', 'Token not found.');
          }
        } else {
          _showErrorSnackBar('Login Error', data['message'] ?? 'Login failed');
        }
      } catch (e) {
        _showErrorSnackBar('Connection Error', 'Check your connection');
      } finally {
        isLoading.value = false;
      }
    }
  }

  String? _extractToken(dynamic data) {
    if (data is! Map) return null;
    return data['access'] ??
        data['token'] ??
        data['access_token'] ??
        (data['tokens'] is Map ? data['tokens']['access'] : null) ??
        (data['data'] is Map
            ? (data['data']['access'] ?? data['data']['token'])
            : null);
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
        final data = json.decode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', data['full_name'] ?? '');
        await prefs.setString(
          'user_profile_pic',
          data['profile_picture'] ?? '',
        );
      }
    } catch (e) {
      print("Error saving profile: $e");
    }
  }

  void signUp() async {
    if (formKey.currentState!.validate()) {
      if (!agreeToTerms.value) {
        _showErrorSnackBar('Terms', 'Agree to terms first');
        return;
      }
      if (selectedServiceId.value.isEmpty) {
        _showErrorSnackBar('Service', 'Select category & service');
        return;
      }

      double enteredRate = double.tryParse(rateController.text) ?? 0;
      if (enteredRate < priceMin.value ||
          (priceMax.value > 0 && enteredRate > priceMax.value)) {
        _showErrorSnackBar(
          'Price',
          'Allowed: ${priceMin.value} to ${priceMax.value}',
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
        _showErrorSnackBar('Error', e.toString());
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

  String _cleanToken(String token) {
    String clean = token.toString().trim().replaceAll('"', '');
    if (clean.toLowerCase().startsWith("bearer "))
      clean = clean.substring(7).trim();
    return clean;
  }
}
