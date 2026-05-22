import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/global_controllers/location_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/Services/api_services.dart';

class ServiceDetailsController extends GetxController {
  final isFavorite = false.obs;
  final selectedTab = 0.obs; // 0 for Overview, 1 for Reviews

  final serviceData = RxMap<String, dynamic>();
  final artisanData = RxMap<String, dynamic>();

  final topArtisans = <Map<String, dynamic>>[].obs;
  final isLoadingTopArtisans = false.obs;
  final isArtisanSpecificFlow = false.obs;
  final artisanBio = ''.obs;
  final artisanExperience = ''.obs;
  final artisanSkills = <String>[].obs;
  final artisanServiceAreas = <String>[].obs;

  // UI-te render korar jonno list-ti eikhane thaka dorkar
  final whatsIncluded = [
    'Professional service delivery',
    'Safety inspection & testing',
    'Post-service cleanup',
    '30-day service warranty',
  ].obs;

  final reviews = [
    {
      'name': 'Sarah Williams',
      'date': '2 days ago',
      'rating': 5,
      'comment': 'Excellent service, the plumber arrived on time and fixed the leak perfectly. Highly recommended!',
      'image': 'assets/images/home/Sarah Williams.png',
    },
    {
      'name': 'David Carter',
      'date': '1 week ago',
      'rating': 4,
      'comment': 'Great job fixing the wiring issues. Very professional and efficient.',
      'image': 'assets/images/home/Daniel Carter.png',
    },
  ].obs;

  final isServiceFlow = false.obs; // true when coming from popular services
  final serviceDescription = ''.obs;
  final selectedArtisan = RxMap<String, dynamic>();

  @override
  void onInit() {
    super.onInit();
    _handleArguments();
  }

  void _handleArguments() {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map<String, dynamic>;

      // Coming from popular services with service data
      if (args['source'] == 'popular_services' && args['service'] != null) {
        final service = args['service'] as Map<String, dynamic>;
        serviceData.assignAll(service);
        isServiceFlow.value = true;
        isArtisanSpecificFlow.value = false;

        final serviceId = service['id']?.toString();
        if (serviceId != null && serviceId.isNotEmpty) {
          fetchNearbyArtisansForServiceId(serviceId);
        } else {
          fetchTopArtisansForService();
        }
        return;
      }

      if (args.containsKey('service') || args.containsKey('artisan')) {
        serviceData.assignAll(args['service'] ?? {});
        artisanData.assignAll(args['artisan'] ?? {});
        isArtisanSpecificFlow.value = args.containsKey('artisan') && args['artisan'] != null;
      } else {
        artisanData.assignAll(args);
        isArtisanSpecificFlow.value = true;
        if (serviceData.isEmpty) {
          serviceData.assignAll({
            'title': args['role'] ?? args['occupation'] ?? 'Service Details',
            'rating': args['rating'],
            'reviews': args['reviews'] ?? args['review_count'],
            'priceRange': args['pricePerHour'] != null ? '\$${args['pricePerHour']}' : null,
          });
        }
      }
      normalizeArtisanData();
      if (isArtisanSpecificFlow.value) {
        fetchArtisanProfile();
      } else {
        fetchTopArtisansForService();
      }
    }
  }

  Future<void> fetchArtisanProfile() async {
    final String? artisanId = artisanData['id']?.toString() ?? artisanData['artisan_id']?.toString();
    if (artisanId == null) return;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token')?.trim().replaceAll('"', '');

      final response = await http.get(
        Uri.parse("${ApiServices.artisan_public_profile}$artisanId/public/"),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        artisanData.addAll(data); 

        // The user showed that data is nested in 'artisan_profile'
        final profile = data['artisan_profile'] ?? data;
        
        artisanBio.value = profile['bio']?.toString() ?? '';
        
        final exp = profile['experience_years'] ?? profile['years_of_experience'] ?? profile['experience'];
        artisanExperience.value = exp != null ? "$exp Years" : "";

        if (profile['skills'] != null) {
          if (profile['skills'] is List) {
            artisanSkills.assignAll((profile['skills'] as List).map((e) => e.toString()).toList());
          } else if (profile['skills'] is String) {
            try {
              // Sometimes skills come as a JSON string like '["skill1", "skill2"]'
              final List decodedSkills = json.decode(profile['skills']);
              artisanSkills.assignAll(decodedSkills.map((e) => e.toString()).toList());
            } catch (e) {
              artisanSkills.assignAll([profile['skills'].toString()]);
            }
          }
        }

        if (profile['service_areas'] != null) {
          if (profile['service_areas'] is List) {
            artisanServiceAreas.assignAll((profile['service_areas'] as List).map((e) => e.toString()).toList());
          } else if (profile['service_areas'] is String) {
            try {
              final List decodedAreas = json.decode(profile['service_areas']);
              artisanServiceAreas.assignAll(decodedAreas.map((e) => e.toString()).toList());
            } catch (e) {
              artisanServiceAreas.assignAll([profile['service_areas'].toString()]);
            }
          }
        }

        // CRITICAL: Extract the correct service ID that this artisan actually provides
        if (data['services'] != null && data['services'] is List && data['services'].isNotEmpty) {
          artisanData['service_id'] = data['services'][0]['id']?.toString();
        } else if (profile['service_id'] != null) {
          artisanData['service_id'] = profile['service_id'].toString();
        } else if (data['service'] != null) {
          artisanData['service_id'] = data['service'].toString();
        }
      }
    } catch (e) {
      print("Error fetching artisan profile: $e");
    }
  }

  void normalizeArtisanData() {
    artisanData['full_name'] ??= artisanData['name'];
    artisanData['profile_picture'] ??= artisanData['avatar'];
    artisanData['review_count'] ??= artisanData['reviews'];
    artisanData['hourly_rate'] ??= artisanData['pricePerHour'];
    artisanData['distance'] ??= artisanData['distanceOrTime'];
    artisanData['occupation'] ??= artisanData['role'];

    // Pre-populate observables if data is already present in arguments
    if (artisanData['bio'] != null) artisanBio.value = artisanData['bio'].toString();
    if (artisanData['experience'] != null) artisanExperience.value = "${artisanData['experience']} Years";
    
    if (artisanData['skills'] != null) {
      if (artisanData['skills'] is List) {
        artisanSkills.assignAll((artisanData['skills'] as List).map((e) => e.toString()).toList());
      } else if (artisanData['skills'] is String) {
        try {
          final decoded = json.decode(artisanData['skills']);
          if (decoded is List) artisanSkills.assignAll(decoded.map((e) => e.toString()).toList());
        } catch (_) {}
      }
    }

    if (artisanData['service_areas'] != null) {
      if (artisanData['service_areas'] is List) {
        artisanServiceAreas.assignAll((artisanData['service_areas'] as List).map((e) => e.toString()).toList());
      } else if (artisanData['service_areas'] is String) {
        try {
          final decoded = json.decode(artisanData['service_areas']);
          if (decoded is List) artisanServiceAreas.assignAll(decoded.map((e) => e.toString()).toList());
        } catch (_) {}
      }
    }
  }

  Future<void> fetchNearbyArtisansForServiceId(String serviceId) async {
    isLoadingTopArtisans.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token')?.trim().replaceAll('"', '');

      final locationController = Get.find<LocationController>();
      final pos = locationController.currentPosition.value;

      Map<String, String> queryParams = {};
      if (pos != null) {
        queryParams['lat'] = pos.latitude.toString();
        queryParams['lng'] = pos.longitude.toString();
      }

      final uri = Uri.parse('${ApiServices.baseurl}/api/services/client/services/$serviceId/nearby-artisans/').replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> dataList = (decodedData is Map) ? (decodedData['results'] ?? []) : (decodedData ?? []);

        topArtisans.assignAll(dataList.map((e) {
          final double dist = double.tryParse(e['distance_km']?.toString() ?? '0.0') ?? 0.0;

          // Extract services info
          String? svcDescription;
          if (e['services'] != null && e['services'] is List) {
            for (var svc in e['services']) {
              if (svc['service_id']?.toString() == serviceId) {
                svcDescription = svc['description']?.toString();
                break;
              }
            }
          }

          return {
            'id': e['artisan_id'],
            'name': e['full_name'] ?? 'Artisan',
            'role': e['occupation'] ?? serviceData['title'] ?? 'Specialist',
            'avatar': ApiServices.formatImageUrl(e['profile_picture']?.toString()),
            'isVerified': e['is_verified'] ?? false,
            'rating': double.tryParse(e['avg_rating']?.toString() ?? '0') ?? 0.0,
            'reviews': e['review_count'] ?? 0,
            'jobsDone': e['total_jobs_done'] ?? 0,
            'price': e['effective_price']?.toString() ?? '0',
            'distanceOrTime': dist < 1.0 ? 'Nearby' : '${dist.toStringAsFixed(1)} km',
            'bio': e['bio'],
            'service_description': svcDescription,
            'experience': e['experience_years'] ?? e['years_of_experience'],
            'skills': e['skills'],
            'service_areas': e['service_areas'],
            'service_id': serviceId,
          };
        }).toList());

        // Auto-select the best artisan (first one = highest rated + nearest)
        if (topArtisans.isNotEmpty) {
          selectedArtisan.assignAll(topArtisans.first);
          artisanData.assignAll(topArtisans.first);
          normalizeArtisanData();

          // Set service description from the best artisan
          if (topArtisans.first['service_description'] != null) {
            serviceDescription.value = topArtisans.first['service_description'].toString();
          }
        }
      } else {
        // nearby-artisans API failed — not critical, user can still book without artisan
        print("DEBUG: nearby-artisans returned ${response.statusCode}, trying fallback");
        isLoadingTopArtisans.value = false;
        await fetchTopArtisansForService();
        return;
      }
    } catch (e) {
      print("Error fetching nearby artisans for service: $e");
      // Fallback on error too
      isLoadingTopArtisans.value = false;
      await fetchTopArtisansForService();
      return;
    } finally {
      isLoadingTopArtisans.value = false;
    }
  }

  Future<void> fetchTopArtisansForService() async {
    final String? categoryName = serviceData['title'] ?? artisanData['occupation'];
    if (categoryName == null) return;

    isLoadingTopArtisans.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token')?.trim().replaceAll('"', '');

      final locationController = Get.find<LocationController>();
      final pos = locationController.currentPosition.value;

      Map<String, String> queryParams = {
        'search': categoryName,
      };

      if (pos != null) {
        queryParams['lat'] = pos.latitude.toString();
        queryParams['lng'] = pos.longitude.toString();
      }

      final uri = Uri.parse(ApiServices.recommended_artisans).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> dataList = (decodedData is Map) ? (decodedData['results'] ?? []) : (decodedData ?? []);

        if (dataList.isNotEmpty) {
          dataList.sort((a, b) {
            final double distA = double.tryParse(a['distance_km']?.toString() ?? '999') ?? 999;
            final double distB = double.tryParse(b['distance_km']?.toString() ?? '999') ?? 999;
            int distComp = distA.compareTo(distB);
            if (distComp != 0) return distComp;

            final double ratA = double.tryParse(a['avg_rating']?.toString() ?? '0') ?? 0;
            final double ratB = double.tryParse(b['avg_rating']?.toString() ?? '0') ?? 0;
            return ratB.compareTo(ratA);
          });
        }

        final String? currentArtisanId = artisanData['id']?.toString() ?? artisanData['artisan_id']?.toString();

        topArtisans.assignAll(dataList.where((e) {
          return e['artisan_id']?.toString() != currentArtisanId;
        }).map((e) {
          final double dist = double.tryParse(e['distance_km']?.toString() ?? '0.0') ?? 0.0;
          return {
            'id': e['artisan_id'],
            'name': e['full_name'] ?? 'Artisan',
            'role': e['occupation'] ?? categoryName,
            'avatar': ApiServices.formatImageUrl(e['profile_picture']?.toString()),
            'isVerified': e['is_verified'] ?? true,
            'rating': double.tryParse(e['avg_rating']?.toString() ?? '0') ?? 0.0,
            'reviews': e['review_count'] ?? 0,
            'jobsDone': e['total_jobs_done'] ?? 0,
            'price': e['effective_price']?.toString() ?? '0',
            'distanceOrTime': dist < 1.0 ? 'Nearby' : '${dist.toStringAsFixed(1)} km',
            'bio': e['bio'] ?? (e['artisan_profile'] != null ? e['artisan_profile']['bio'] : null),
            'experience': e['experience_years'] ?? e['years_of_experience'] ?? (e['artisan_profile'] != null ? e['artisan_profile']['experience_years'] : null),
            'skills': e['skills'] ?? (e['artisan_profile'] != null ? e['artisan_profile']['skills'] : null),
            'service_areas': e['service_areas'] ?? (e['artisan_profile'] != null ? e['artisan_profile']['service_areas'] : null),
            'service_id': e['service']?.toString() ?? e['service_id']?.toString() ?? (e['artisan_profile'] != null ? e['artisan_profile']['service_id'] : null),
          };
        }).toList());

        // Auto-select best artisan in service flow
        if (isServiceFlow.value && topArtisans.isNotEmpty && selectedArtisan.isEmpty) {
          selectedArtisan.assignAll(topArtisans.first);
          artisanData.assignAll(topArtisans.first);
          normalizeArtisanData();
        }
      }
    } catch (e) {
      print("Error fetching artisans: $e");
    } finally {
      isLoadingTopArtisans.value = false;
    }
  }

  void toggleFavorite() => isFavorite.value = !isFavorite.value;
  void changeTab(int index) => selectedTab.value = index;
  void bookNow() {
    final artisan = selectedArtisan.isNotEmpty ? selectedArtisan : artisanData;
    Get.toNamed(Routes.BOOKING, arguments: {
      'service': Map<String, dynamic>.from(serviceData),
      'artisan': Map<String, dynamic>.from(artisan),
    });
  }
}