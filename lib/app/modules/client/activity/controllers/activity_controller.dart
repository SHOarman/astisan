import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';

class ActivityController extends GetxController {
  final isLoading = false.obs;
  final bookings = <Map<String, dynamic>>[].obs;
  
  // Lists for each status category
  final upcomingBookings = <Map<String, dynamic>>[].obs;
  final confirmedBookings = <Map<String, dynamic>>[].obs;
  final completedBookings = <Map<String, dynamic>>[].obs;
  final cancelledBookings = <Map<String, dynamic>>[].obs;

  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    fetchAllBookings();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) => _silentRefreshBookings());
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  Future<void> _silentRefreshBookings() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.trim().replaceAll('"', '');

      final response = await http.get(
        Uri.parse("${ApiServices.baseurl}/api/bookings/client/"),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        List<dynamic> results = [];
        if (decodedData is Map) {
          results = decodedData['results'] ?? [];
        } else if (decodedData is List) {
          results = decodedData;
        }

        final List<Map<String, dynamic>> resultsList = results.cast<Map<String, dynamic>>().toList();
        
        resultsList.sort((a, b) {
          int idA = int.tryParse(a['id']?.toString() ?? "0") ?? 0;
          int idB = int.tryParse(b['id']?.toString() ?? "0") ?? 0;
          return idB.compareTo(idA);
        });

        if (_hasChanges(resultsList)) {
          bookings.assignAll(resultsList);
          _categorizeBookings();
        }
      }
    } catch (e) {
      // Silently fail on background refresh
    }
  }

  bool _hasChanges(List<Map<String, dynamic>> newBookings) {
    if (newBookings.length != bookings.length) return true;
    for (int i = 0; i < newBookings.length; i++) {
      if (newBookings[i]['id'] != bookings[i]['id'] || newBookings[i]['status'] != bookings[i]['status']) {
        return true;
      }
    }
    return false;
  }

  Future<void> fetchAllBookings() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.trim().replaceAll('"', '');

      final response = await http.get(
        Uri.parse("${ApiServices.baseurl}/api/bookings/client/"),
        headers: { 'Accept-Language': ApiServices.currentLanguage, 
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        List<dynamic> results = [];
        if (decodedData is Map) {
          results = decodedData['results'] ?? [];
        } else if (decodedData is List) {
          results = decodedData;
        }

        final List<Map<String, dynamic>> resultsList = results.cast<Map<String, dynamic>>().toList();
        
        // Sort by ID descending to show newest first
        resultsList.sort((a, b) {
          int idA = int.tryParse(a['id']?.toString() ?? "0") ?? 0;
          int idB = int.tryParse(b['id']?.toString() ?? "0") ?? 0;
          return idB.compareTo(idA);
        });

        bookings.assignAll(resultsList);
        _categorizeBookings();
      }
    } catch (e) {
      print("Error fetching bookings: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _categorizeBookings() {
    upcomingBookings.clear();
    confirmedBookings.clear();
    completedBookings.clear();
    cancelledBookings.clear();

    for (var booking in bookings) {
      final String status = (booking['status'] ?? '').toString().toLowerCase();
      
      if (status == 'requested') {
        upcomingBookings.add(booking);
      } else if (['confirmed', 'on_way', 'arrived', 'working'].contains(status)) {
        confirmedBookings.add(booking);
      } else if (status == 'completed' || status == 'client_paid') {
        completedBookings.add(booking);
      } else if (status == 'cancelled' || status == 'rejected') {
        cancelledBookings.add(booking);
      }
    }
  }

  int getCount(String category) {
    switch (category.toLowerCase()) {
      case 'upcoming': return upcomingBookings.length;
      case 'confirmed': return confirmedBookings.length;
      case 'completed': return completedBookings.length;
      case 'cancelled': return cancelledBookings.length;
      default: return 0;
    }
  }

  void updateBookingStatusLocally(String bookingId, String newStatus) {
    int index = bookings.indexWhere((b) => b['id'].toString() == bookingId || b['booking_id'].toString() == bookingId);
    if (index != -1) {
      bookings[index]['status'] = newStatus;
      _categorizeBookings();
    }
  }
}
