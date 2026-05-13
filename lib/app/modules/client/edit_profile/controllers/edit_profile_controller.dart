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

      final String cleanToken = token.toString().trim().replaceAll('"', '').replaceAll('Bearer ', '');
      final String endpoint = isWorker.value ? ApiServices.artisan_profile : ApiServices.client_profile;
      
      print("DEBUG: EditProfile fetching from $endpoint (isWorker: ${isWorker.value})");
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      print("DEBUG: EditProfile Fetch Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _populateFields(data);
        if (isWorker.value) await _fetchWorkerServices(cleanToken);
      } else if (response.statusCode == 403) {
        print("DEBUG: 403 Forbidden in EditProfile. Trying alternative role...");
        final String altUrl = isWorker.value ? ApiServices.client_profile : ApiServices.artisan_profile;
        final altResponse = await http.get(
          Uri.parse(altUrl),
          headers: {'Authorization': 'Bearer $cleanToken', 'Accept': 'application/json'},
        ).timeout(const Duration(seconds: 15));

        if (altResponse.statusCode == 200) {
          final String altRole = isWorker.value ? 'client' : 'worker';
          print("DEBUG: Auto-corrected role to $altRole");
          await prefs.setString('role', altRole);
          isWorker.value = (altRole == 'worker' || altRole == 'artisan');
          
          final data = json.decode(altResponse.body);
          _populateFields(data);
          if (isWorker.value) await _fetchWorkerServices(cleanToken);
          Get.snackbar('Role Synced', 'Your account role was updated to $altRole');
        } else {
          Get.snackbar('Access Denied', 'Your account does not have permissions for this section.', backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else if (response.statusCode == 401) {
        Get.snackbar('Session Expired', 'Please login again', backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Failed to load profile (${response.statusCode})', backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } catch (e) {
      print("Error fetching profile: $e");
      Get.snackbar('Error', 'Failed to fetch profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _populateFields(dynamic data) {
    fullNameController.text = data['full_name']?.toString() ?? '';
    emailController.text = data['email']?.toString() ?? '';
    phoneController.text = data['phone']?.toString() ?? '';
    profileImageUrl.value = ApiServices.formatImageUrl(data['profile_picture']?.toString());

    if (isWorker.value && data['artisan_profile'] != null) {
      final artisan = data['artisan_profile'];
      occupationController.text = artisan['occupation']?.toString() ?? '';
      bioController.text = artisan['bio']?.toString() ?? '';
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
        if (workerCtrl.serviceRate.value != '0.00' && workerCtrl.serviceRate.value.isNotEmpty) {
          rateController.text = workerCtrl.serviceRate.value;
        }
      }
    }
  }

  Future<void> _fetchWorkerServices(String cleanToken) async {
    try {
      final servicesResponse = await http.get(
        Uri.parse(ApiServices.artisan_my_services),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (servicesResponse.statusCode == 200) {
        final servicesData = json.decode(servicesResponse.body);
        final List results = (servicesData is List) ? servicesData : (servicesData['results'] ?? []);
        if (results.isNotEmpty) {
          final firstService = results[0];
          registrationId.value = firstService['id']?.toString() ?? '';
          serviceId.value = firstService['service']?.toString() ?? '';
          rateController.text = firstService['price_override']?.toString() ?? 
                               firstService['effective_price']?.toString() ?? rateController.text;
        }
      }
    } catch (e) {
      print("Error fetching worker services: $e");
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
      final String url = isWorker.value
          ? ApiServices.artisan_profile
          : ApiServices.client_profile;
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
        request.fields['years_of_experience'] = experienceController.text
            .trim();
        request.fields['hourly_rate'] = rateController.text.trim();

        if (serviceId.value.isNotEmpty) {
          try {
            final String rateUpdateUrl = registrationId.value.isNotEmpty
                ? "${ApiServices.artisan_my_services}${registrationId.value}/"
                : ApiServices.artisan_my_services;
            final String method = registrationId.value.isNotEmpty
                ? 'PATCH'
                : 'POST';

            final rateResponse = await (method == 'PATCH'
                ? http.patch(
                    Uri.parse(rateUpdateUrl),
                    headers: {
                      'Authorization': 'Bearer $cleanToken',
                      'Content-Type': 'application/json',
                      'Accept': 'application/json',
                    },
                    body: json.encode({
                      'price_override': rateController.text.trim(),
                    }),
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
            print(
              "Service Rate Update [$method] Status: ${rateResponse.statusCode}",
            );
          } catch (e) {
            print("Failed to update specific service rate: $e");
          }
        }

        List<String> skillsList = skillsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        for (var skill in skillsList) {
          request.files.add(http.MultipartFile.fromString('skills', skill));
        }

        List<String> areasList = areasController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        for (var area in areasList) {
          request.files.add(
            http.MultipartFile.fromString('service_areas', area),
          );
        }
      }

      if (profileImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_picture',
            profileImage.value!.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Profile updated successfully');

        if (Get.isRegistered<ProfileController>()) {
          final profileCtrl = Get.find<ProfileController>();
          profileCtrl.userName.value = fullNameController.text.trim();
          profileCtrl.userEmail.value = emailController.text.trim();
          if (profileImage.value != null) {
            profileCtrl.userProfileImage.value = profileImage.value!.path;
          }
          profileCtrl.fetchProfile();
        }

        if (Get.isRegistered<WorkerAccountController>()) {
          final workerCtrl = Get.find<WorkerAccountController>();

          // Manual immediate updates
          workerCtrl.userName.value = fullNameController.text.trim();
          workerCtrl.userEmail.value = emailController.text.trim();
          workerCtrl.userPhone.value = phoneController.text.trim();
          workerCtrl.serviceRate.value = rateController.text.trim();
          workerCtrl.bio.value = bioController.text.trim();
          workerCtrl.experienceYears.value = experienceController.text.trim();

          String newOcc = occupationController.text.trim();
          if (newOcc.isNotEmpty && newOcc.toLowerCase() != 'artisan') {
            workerCtrl.profession.value = newOcc;
          }

          // If a new local image was picked, show it immediately
          if (profileImage.value != null) {
            workerCtrl.profilePicture.value = profileImage.value!.path;
          }

          // Still fetch fresh data from server to sync everything else (like verification status)
          workerCtrl.fetchProfile();
        }

        if (Get.isRegistered<WorkerHomeController>()) {
          final homeCtrl = Get.find<WorkerHomeController>();
          homeCtrl.userName.value = fullNameController.text.trim();
          if (profileImage.value != null) {
            homeCtrl.profilePicture.value = profileImage.value!.path;
          }
          homeCtrl.fetchCurrentStatus();
        }

        Get.back();
      } else {
        Get.snackbar(
          'Error',
          'Failed to update profile: ${response.statusCode}',
        );
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
