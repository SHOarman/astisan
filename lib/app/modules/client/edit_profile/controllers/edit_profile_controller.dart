import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../worker/account/controllers/worker_account_controller.dart';
import '../../../worker/dashboard/controllers/worker_home_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final occupationController = TextEditingController();
  final bioController = TextEditingController();
  final experienceController = TextEditingController();
  final skillsController = TextEditingController();
  final areasController = TextEditingController();
  final rateController = TextEditingController();
  final serviceId = ''.obs;
  final registrationId = ''.obs;
  
  final isLoading = false.obs;
  final isWorker = false.obs;
  final profileImage = Rx<File?>(null);
  final profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final String? role = prefs.getString('role');
      isWorker.value = (role == 'worker' || role == 'artisan');

      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token not found');
        return;
      }

      final String cleanToken = token.trim().replaceAll('"', '');
      final String url = isWorker.value ? ApiServices.artisan_profile : ApiServices.client_profile;
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        fullNameController.text = data['full_name'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phone'] ?? '';
        profileImageUrl.value = ApiServices.formatImageUrl(data['profile_picture']?.toString());

        if (isWorker.value && data['artisan_profile'] != null) {
          final artisan = data['artisan_profile'];
          occupationController.text = artisan['occupation'] ?? '';
          bioController.text = artisan['bio'] ?? '';
          experienceController.text = artisan['years_of_experience']?.toString() ?? '0';
          rateController.text = artisan['hourly_rate']?.toString() ?? '0.00';
          
          if (artisan['skills'] != null) {
            if (artisan['skills'] is List) {
              skillsController.text = (artisan['skills'] as List).join(', ');
            } else {
              skillsController.text = artisan['skills'].toString();
            }
          }

          if (artisan['service_areas'] != null) {
            if (artisan['service_areas'] is List) {
              areasController.text = (artisan['service_areas'] as List).join(', ');
            } else {
              areasController.text = artisan['service_areas'].toString();
            }
          }

          if (Get.isRegistered<WorkerAccountController>()) {
            final workerCtrl = Get.find<WorkerAccountController>();
            serviceId.value = workerCtrl.serviceId.value;
            registrationId.value = workerCtrl.registrationId.value;
            if (workerCtrl.serviceRate.value != '0.00') {
              rateController.text = workerCtrl.serviceRate.value;
            }
          }
        }
      }

      // If we are a worker and still don't have serviceId or the actual rate, fetch it
      if (isWorker.value && serviceId.value.isEmpty) {
        final servicesResponse = await http.get(
          Uri.parse(ApiServices.artisan_my_services),
          headers: {
            'Authorization': 'Bearer $cleanToken',
            'Accept': 'application/json',
          },
        ).timeout(const Duration(seconds: 10));

        if (servicesResponse.statusCode == 200) {
          final servicesData = json.decode(servicesResponse.body);
          if (servicesData['results'] != null && (servicesData['results'] as List).isNotEmpty) {
            final firstService = servicesData['results'][0];
            registrationId.value = firstService['id']?.toString() ?? '';
            serviceId.value = firstService['service']?.toString() ?? '';
            rateController.text = firstService['price_override']?.toString() ?? 
                                 firstService['effective_price']?.toString() ?? rateController.text;
          }
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveChanges() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token not found');
        return;
      }

      final String cleanToken = token.trim().replaceAll('"', '');
      final String url = isWorker.value ? ApiServices.artisan_profile : ApiServices.client_profile;
      var request = http.MultipartRequest('PATCH', Uri.parse(url));
      
      request.headers.addAll({
        'Authorization': 'Bearer $cleanToken',
        'Accept': 'application/json',
      });

      String rawPhone = phoneController.text.trim();
      String cleanPhone = rawPhone.replaceAll(RegExp(r'[^\d+]'), '');

      request.fields['full_name'] = fullNameController.text.trim();
      request.fields['phone'] = cleanPhone;

      if (isWorker.value) {
        request.fields['occupation'] = occupationController.text.trim();
        request.fields['bio'] = bioController.text.trim();
        request.fields['years_of_experience'] = experienceController.text.trim();
        request.fields['hourly_rate'] = rateController.text.trim();
        
        if (serviceId.value.isNotEmpty) {
          try {
            final String rateUpdateUrl = registrationId.value.isNotEmpty 
                ? "${ApiServices.artisan_my_services}${registrationId.value}/"
                : ApiServices.artisan_my_services;
            final String method = registrationId.value.isNotEmpty ? 'PATCH' : 'POST';
            
            final rateResponse = await (method == 'PATCH' 
                ? http.patch(
                    Uri.parse(rateUpdateUrl),
                    headers: {
                      'Authorization': 'Bearer $cleanToken',
                      'Content-Type': 'application/json',
                      'Accept': 'application/json',
                    },
                    body: json.encode({'price_override': rateController.text.trim()}),
                  )
                : http.post(
                    Uri.parse(rateUpdateUrl),
                    headers: {
                      'Authorization': 'Bearer $cleanToken',
                      'Content-Type': 'application/json',
                      'Accept': 'application/json',
                    },
                    body: json.encode({
                      'service': serviceId.value,
                      'price_override': rateController.text.trim(),
                      'is_active': true,
                    }),
                  ));
            print("Service Rate Update [$method] Status: ${rateResponse.statusCode}");
          } catch (e) {
            print("Failed to update specific service rate: $e");
          }
        }
        
        List<String> skillsList = skillsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        for (var skill in skillsList) {
          request.files.add(http.MultipartFile.fromString('skills', skill));
        }
        
        List<String> areasList = areasController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        for (var area in areasList) {
          request.files.add(http.MultipartFile.fromString('service_areas', area));
        }
      }

      if (profileImage.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          profileImage.value!.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Profile updated successfully');
        
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().fetchProfile();
        }
        
        if (Get.isRegistered<WorkerAccountController>()) {
          final workerCtrl = Get.find<WorkerAccountController>();
          workerCtrl.serviceRate.value = rateController.text.trim();
          workerCtrl.userName.value = fullNameController.text.trim();
          
          // Only update profession if it's not the generic 'Artisan'
          String newOcc = occupationController.text.trim();
          if (newOcc.isNotEmpty && newOcc.toLowerCase() != 'artisan') {
            workerCtrl.profession.value = newOcc;
          }
          
          Future.delayed(const Duration(seconds: 1), () {
            if (Get.isRegistered<WorkerAccountController>()) {
              Get.find<WorkerAccountController>().fetchProfile();
            }
          });
        }

        if (Get.isRegistered<WorkerHomeController>()) {
          Get.find<WorkerHomeController>().fetchCurrentStatus();
        }
        
        Get.back();
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.snackbar('Error', 'Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      print("Error updating profile: $e");
      Get.snackbar('Error', 'Connection failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage.value = File(image.path);
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    occupationController.dispose();
    bioController.dispose();
    experienceController.dispose();
    skillsController.dispose();
    areasController.dispose();
    rateController.dispose();
    super.onClose();
  }
}
