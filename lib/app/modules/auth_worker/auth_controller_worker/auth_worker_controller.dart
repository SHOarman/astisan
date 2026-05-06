import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/global_controllers/role_controller.dart';

class AuthWorkerController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final loginFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // --- New: Service Related Controllers ---
  final rateController = TextEditingController(text: "\$40");
  final selectedCategory = ''.obs;
  final selectedService = ''.obs;

  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final agreeToTerms = false.obs;
  final rememberMe = false.obs;

  // --- New: Category Data Map ---
  final Map<String, List<String>> categoryData = {
    'Repair & Maintenance': ['Plumbing Fix', 'Electrical Fix', 'AC Repair', 'Lock Repair', 'Wall & Ceiling Fix', 'Roof Leak Repair'],
    'Cleaning Service': ['Home Deep Cleaning', 'Kitchen Cleaning', 'Bathroom Cleaning', 'Sofa & Carpet Cleaning', 'Window Cleaning', 'Post-Construction Clean'],
    'Installation Service': ['AC Installation', 'TV & Wall Mount', 'Door & Window Fitting', 'Furniture Assembly', 'Water Heater Setup', 'CCTV & Smart Home'],
    'Home Improvement': ['Painting & Decoration', 'Flooring & Tiling', 'Kitchen Renovation', 'Bathroom Remodeling', 'Wallpaper & Paneling', 'False Ceiling Work'],
    'Moving & Shifting': ['Home Relocation', 'Office Shifting', 'Single Item Moving', 'Packing Service', 'Storage Service', 'Junk Removal'],
    'Garden cleaning': ['Lawn Mowing', 'Tree & Bush Trimming', 'Garden Waste Removal', 'Planting & Landscaping', 'Irrigation Setup', 'Pest Control (Garden)'],
  };

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    rateController.dispose(); // New
    super.onClose();
  }

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.value = !obscureConfirmPassword.value;
  void toggleTermsAgreement(bool? value) { if (value != null) agreeToTerms.value = value; }
  void toggleRememberMe(bool? value) { if (value != null) rememberMe.value = value; }

  void signIn() {
    if (loginFormKey.currentState?.validate() ?? true) {
      Get.focusScope?.unfocus();
      Get.find<RoleController>().setRole('worker');
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }

  // --- Updated: SignUp Logic including Service Data ---
  void signUp() {
    if (formKey.currentState!.validate()) {
      if (!agreeToTerms.value) {
        _showErrorSnackBar('Terms & Privacy', 'You must agree to the terms and privacy policy');
        return;
      }

      if (selectedCategory.value.isEmpty || selectedService.value.isEmpty) {
        _showErrorSnackBar('Service Selection', 'Please select both a category and a service');
        return;
      }

      Get.focusScope?.unfocus();

      // Collect all data for API/Database
      final registrationData = {
        "personal_info": {
          "name": nameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
          "password": passwordController.text,
        },
        "service_info": {
          "category": selectedCategory.value,
          "service": selectedService.value,
          "rate": rateController.text,
        },
        "role": "worker"
      };

      print("Final Worker Data: $registrationData");

      Get.find<RoleController>().setRole('worker');
      Get.offAllNamed(Routes.DASHBOARD);
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
    Get.focusScope?.unfocus();
    Get.toNamed(Routes.sing_up);
  }

  void navigateToLogin() {
    Get.focusScope?.unfocus();
    Get.back();
  }

  void onSocialLogin(String provider) {
    Get.snackbar('Social Login', 'Clicked on $provider', snackPosition: SnackPosition.BOTTOM);
  }
}