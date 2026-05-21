import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/Services/api_services.dart';
import '../../../../core/global_controllers/location_controller.dart';

class BookingController extends GetxController {
  final currentStep = 1.obs;
  final capturedImagePath = ''.obs;
  final serviceData = <String, dynamic>{}.obs;
  final selectedArtisan = <String, dynamic>{}.obs;

  // Date & Time
  final dates = <Map<String, String>>[].obs;
  final selectedDateIndex = 0.obs;

  void _generateDates() {
    final now = DateTime.now();
    final List<Map<String, String>> generatedDates = [];
    final List<String> weekdays = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      generatedDates.add({
        'day': weekdays[date.weekday % 7],
        'date': date.day.toString(),
        'month': months[date.month - 1],
        'year': date.year.toString(),
        'fullDate':
            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      });
    }
    dates.assignAll(generatedDates);
  }

  final times = [
    '8:00 AM',
    '10:00 AM',
    '12:00 PM',
    '2:00 PM',
    '4:00 PM',
    '6:00 PM',
  ];
  final selectedTime = DateTime.now().obs;

  // Address
  final addresses = <Map<String, dynamic>>[].obs;
  final selectedAddressIndex = 0.obs;
  final isLoadingAddresses = false.obs;

  Future<void> fetchSavedAddresses() async {
    isLoadingAddresses.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.trim().replaceAll('"', '');

      final response = await http.get(
        Uri.parse(ApiServices.client_addresses),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        print("====== DEBUG FETCH SAVED ADDRESSES ======");
        print("Addresses from server: $decodedData");
        
        List<dynamic> dataList = [];

        if (decodedData is List) {
          dataList = decodedData;
        } else if (decodedData is Map) {
          dataList =
              decodedData['results'] ??
              decodedData['data'] ??
              decodedData['addresses'] ??
              [];
        }

        addresses.assignAll(
          dataList
              .map(
                (e) => {
                  'id': e['id'],
                  'title': (e['label'] == 'other' || e['label'] == null)
                      ? (e['custom_label'] ?? 'Address')
                      : e['label'].toString().capitalizeFirst,
                  'address': e['address_line'] ?? 'No address line',
                  'isDefault': e['is_default'] ?? false,
                  'raw': e,
                },
              )
              .toList(),
        );

        // Auto-select default address
        final defaultIdx = addresses.indexWhere(
          (element) => element['isDefault'] == true,
        );
        if (defaultIdx != -1) {
          selectedAddressIndex.value = defaultIdx;
        }
      }
    } catch (e) {
      print("Error fetching addresses: $e");
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  // Notes
  final notesController = TextEditingController();
  final notesLength = 0.obs;

  // Navigation source
  final source = ''.obs;
  final isSubmittingBooking = false.obs;

  final quickNotes = [
    '+ Urgent repair',
    '+ Bring materials',
    '+ Multiple items',
    '+ Call before arriving',
    '+ Weekend preferred',
  ];

  @override
  void onInit() {
    super.onInit();
    _generateDates();
    fetchSavedAddresses();
    if (Get.arguments != null && Get.arguments is Map) {
      source.value = Get.arguments['source'] ?? '';
      serviceData.value = Get.arguments['service'] ?? {};
      selectedArtisan.value = Get.arguments['artisan'] ?? {};
      capturedImagePath.value = Get.arguments['image'] ?? '';
    }

    notesController.addListener(() {
      notesLength.value = notesController.text.length;
    });
  }

  // Cost calculations
  double get artisanRate {
    if (selectedArtisan.isNotEmpty) {
      return double.tryParse(
            selectedArtisan['price']?.toString() ??
                selectedArtisan['hourly_rate']?.toString() ??
                '0',
          ) ??
          0;
    }
    return 0;
  }

  double get _minServiceFee => selectedArtisan.isNotEmpty
      ? artisanRate
      : double.tryParse(serviceData['price_range_min']?.toString() ?? '0') ?? 0;

  double get _maxServiceFee => selectedArtisan.isNotEmpty
      ? artisanRate
      : double.tryParse(serviceData['price_range_max']?.toString() ?? '0') ?? 0;

  double get platformFeeMin => _minServiceFee * 0.05;
  double get platformFeeMax => _maxServiceFee * 0.05;

  String get platformFeeString {
    if (platformFeeMin == platformFeeMax) {
      return '\$${platformFeeMin.toStringAsFixed(2)}';
    }
    return '\$${platformFeeMin.toStringAsFixed(2)} - \$${platformFeeMax.toStringAsFixed(2)}';
  }

  String get serviceFeeString {
    if (_minServiceFee == _maxServiceFee) {
      return '\$${_minServiceFee.toStringAsFixed(2)}';
    }
    return '\$${_minServiceFee.toStringAsFixed(2)} - \$${_maxServiceFee.toStringAsFixed(2)}';
  }

  String get estimatedTotalString {
    final min = _minServiceFee + platformFeeMin;
    final max = _maxServiceFee + platformFeeMax;
    if (min == max) {
      return '\$${min.toStringAsFixed(1)}';
    }
    return '\$${min.toStringAsFixed(1)} - \$${max.toStringAsFixed(1)}';
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  void nextStep() {
    Get.focusScope?.unfocus();
    if (currentStep.value < 3) {
      currentStep.value++;
    } else if (currentStep.value == 3) {
      currentStep.value = 4;
      Get.toNamed(Routes.CAMERA, arguments: {'service': serviceData.value});
    } else if (currentStep.value == 5) {
      submitBooking();
    }
  }

  Future<void> submitBooking() async {
    isSubmittingBooking.value = true;
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.white)),
      barrierDismissible: false,
    );
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.trim().replaceAll('"', '');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${ApiServices.baseurl}/api/bookings/client/"),
      );

      // Headers
      request.headers.addAll({
        if (token != null) 'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Fields
      final selectedAddress = addresses[selectedAddressIndex.value];
      final date = dates[selectedDateIndex.value];

      // Formatting date: YYYY-MM-DD
      String formattedDate = date['fullDate'] ?? "2026-05-12";

      // Formatting time: HH:MM:SS
      String formattedTime =
          "${selectedTime.value.hour.toString().padLeft(2, '0')}:${selectedTime.value.minute.toString().padLeft(2, '0')}:00";

      String serviceId =
          serviceData['id']?.toString() ??
          selectedArtisan['service_id']?.toString() ??
          '';

      // Check if occupation/role contains the UUID (as suggested by the user)
      if (serviceId.isEmpty && selectedArtisan.isNotEmpty) {
        String possibleUuid =
            selectedArtisan['role']?.toString() ??
            selectedArtisan['occupation']?.toString() ??
            '';
        if (possibleUuid.length > 30) {
          // UUID is 36 chars
          serviceId = possibleUuid;
        }
      }

      // If we still don't have a serviceId, fetch the artisan's public profile
      // to get their registered service UUID.
      if (serviceId.isEmpty && selectedArtisan.isNotEmpty) {
        try {
          final artisanId = selectedArtisan['id']?.toString() ?? '';
          if (artisanId.isNotEmpty) {
            final res = await http.get(
              Uri.parse(
                "${ApiServices.artisan_public_profile}$artisanId/public/",
              ),
              headers: {
                if (token != null) 'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            );
            if (res.statusCode == 200) {
              final data = json.decode(res.body);
              if (data['services'] != null &&
                  data['services'] is List &&
                  data['services'].isNotEmpty) {
                serviceId =
                    data['services'][0]['service']?.toString() ??
                    data['services'][0]['id']?.toString() ??
                    '';
              } else if (data['artisan_profile'] != null &&
                  data['artisan_profile']['service_id'] != null) {
                serviceId = data['artisan_profile']['service_id'].toString();
              }
            }
          }
        } catch (e) {
          print("Error fetching artisan service: $e");
        }
      }

      // If an artisan is selected, we MUST use their service ID
      if (selectedArtisan.isNotEmpty) {
        final artisanId =
            selectedArtisan['id']?.toString() ??
            selectedArtisan['artisan_id']?.toString() ??
            '';
        request.fields['artisan'] = artisanId;

        // Ensure we have a valid serviceId for THIS artisan
        if (serviceId.isEmpty) {
          // Attempt to fetch correct service ID from their profile if still missing
          try {
            final res = await http.get(
              Uri.parse(
                "${ApiServices.artisan_public_profile}$artisanId/public/",
              ),
              headers: {
                if (token != null) 'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            );
            if (res.statusCode == 200) {
              final data = json.decode(res.body);
              if (data['services'] != null &&
                  data['services'] is List &&
                  data['services'].isNotEmpty) {
                serviceId =
                    data['services'][0]['service']?.toString() ??
                    data['services'][0]['id']?.toString() ??
                    '';
              } else if (data['artisan_profile'] != null &&
                  data['artisan_profile']['service_id'] != null) {
                serviceId = data['artisan_profile']['service_id'].toString();
              }
            }
          } catch (e) {
            print("Error fetching artisan service: $e");
          }
        }
      } else {
        // Auto-match flow: No artisan selected, use the service ID from home page selection
        // Omit the 'artisan' field to let the system auto-assign
      }

      // If still empty, we must find a service ID that this artisan supports.
      // We will look for a service matching their occupation/role name.
      if (serviceId.isEmpty) {
        try {
          final res2 = await http.get(
            Uri.parse(ApiServices.popular_services),
            headers: {
              'Accept': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          );
          if (res2.statusCode == 200) {
            final data2 = json.decode(res2.body);
            List<dynamic> list2 = (data2 is Map)
                ? (data2['results'] ?? [])
                : (data2 is List ? data2 : []);

            if (list2.isNotEmpty) {
              String occupation =
                  (selectedArtisan['role'] ??
                          selectedArtisan['occupation'] ??
                          '')
                      .toString()
                      .toLowerCase();

              // Try to find a service that matches the occupation string
              // e.g. if occupation is "planning.homeclean", it might match a service named "Home Cleaning"
              var matchingService = list2.firstWhere(
                (s) =>
                    s['name']?.toString().toLowerCase().contains(
                          occupation.split('.').last,
                        ) ==
                        true ||
                    occupation.toLowerCase().contains(
                      s['name']?.toString().toLowerCase() ?? '___',
                    ),
                orElse: () => null,
              );

              if (matchingService != null) {
                serviceId = matchingService['id']?.toString() ?? '';
                print(
                  "DEBUG: Resolved service ID by matching occupation '$occupation' to service '${matchingService['name']}': $serviceId",
                );
              } else {
                // Last resort: if we have NO service ID, we take the first one just to prevent the red error,
                // though it might still fail at the server if the artisan doesn't offer it.
                serviceId = list2[0]['id']?.toString() ?? '';
                print("DEBUG: Final fallback service ID: $serviceId");
              }
            }
          }
        } catch (e) {
          print("Error in fallback service resolution: $e");
        }
      }

      if (serviceId.isEmpty) {
        Get.snackbar(
          "Error",
          "Could not identify the service to book. Please select a service first.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoadingAddresses.value = false;
        return;
      }

      request.fields['service'] = serviceId;

      request.fields['service_address'] = selectedAddress['id']?.toString() ?? '';
      request.fields['address'] = selectedAddress['id']?.toString() ?? ''; // Send as both to ensure compatibility

      final rawAddr = selectedAddress['raw'] ?? {};
      print("======= BOOKING DEBUG =======");
      print("DEBUG: Selected Address: $selectedAddress");
      print("DEBUG: Raw Address Data: $rawAddr");
      print("DEBUG: Service Data: ${serviceData.value}");
      print("DEBUG: Selected Artisan: ${selectedArtisan.value}");
      print("DEBUG: Artisan Rate: $artisanRate");

      // Send base_price from artisan rate or service price
      final double price = artisanRate > 0
          ? artisanRate
          : (double.tryParse(
                  serviceData['price_range_min']?.toString() ?? '0',
                ) ??
                0);

      // Always send pricing fields to prevent them from becoming null
      request.fields['base_price'] = price.toStringAsFixed(2);
      request.fields['total_amount'] = price.toStringAsFixed(
        2,
      ); // Initially, total_amount is base_price
      request.fields['platform_fee'] = (price * 0.05).toStringAsFixed(2);

      // 'artisan' field is already handled above based on selection
      request.fields['scheduled_date'] = formattedDate;
      request.fields['scheduled_time'] = formattedTime;
      request.fields['additional_notes'] = notesController.text;

      // Image
      if (capturedImagePath.value.isNotEmpty) {
        try {
          // Attach using both 'image' and 'file' keys with specific Content-Type to ensure 100% server compatibility
          request.files.add(
            await http.MultipartFile.fromPath(
              'image',
              capturedImagePath.value,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
          request.files.add(
            await http.MultipartFile.fromPath(
              'file',
              capturedImagePath.value,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
          print(
            "DEBUG: Successfully attached image ${capturedImagePath.value} to request",
          );
        } catch (e) {
          print("Error attaching image file to request: $e");
        }
      }

      print("DEBUG: Submitting booking request...");
      print("DEBUG: Fields: ${request.fields}");
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );
      var response = await http.Response.fromStream(streamedResponse);

      print("DEBUG: Booking Status: ${response.statusCode}");
      print("DEBUG: Booking Response: ${response.body}");

      if (response.statusCode == 201) {
        if (Get.isDialogOpen ?? false) Get.back();
        final decoded = json.decode(response.body);
        Get.snackbar(
          "Success",
          "Booking confirmed successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAE79),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        if (Get.isDialogOpen ?? false) Get.back();
        Get.snackbar(
          "Error",
          "Failed to create booking: ${response.body}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      print("Error submitting booking: $e");

      String errorMessage = "An unexpected error occurred.";
      if (e.toString().contains("TimeoutException")) {
        errorMessage =
            "The server is taking too long to respond. Please try again.";
      }

      Get.snackbar(
        "Error",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmittingBooking.value = false;
    }
  }

  void previousStep() {
    Get.focusScope?.unfocus();
    if (currentStep.value > 1) {
      if (currentStep.value == 5) {
        currentStep.value = 3;
      } else {
        currentStep.value--;
      }
    } else {
      Get.back();
    }
  }

  void addQuickNote(String note) {
    final cleanNote = note.replaceAll('+ ', '');
    final currentText = notesController.text;
    if (currentText.isEmpty) {
      notesController.text = cleanNote;
    } else {
      notesController.text = '$currentText, $cleanNote';
    }
  }
}
