import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';

class WorkerBookingHistoryController extends GetxController {
  final isLoading = false.obs;
  
  final acceptedBookings = <dynamic>[].obs;
  final completedBookings = <dynamic>[].obs;
  final cancelledBookings = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookingHistory();
  }

  Future<void> fetchBookingHistory() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return;

      final String cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
      
      final response = await http.get(
        Uri.parse(ApiServices.artisan_bookings),
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        final List<dynamic> data = (decodedData is List) ? decodedData : (decodedData['results'] ?? decodedData['data'] ?? []);
        
        // Filter bookings by status
        // Statuses usually: requested, confirmed, accepted, on_way, arrived, working, completed, cancelled
        
        acceptedBookings.assignAll(data.where((b) => 
          ['confirmed', 'accepted', 'on_way', 'arrived', 'working'].contains(b['status'])
        ).toList());
        
        completedBookings.assignAll(data.where((b) => 
          b['status'] == 'completed'
        ).toList());
        
        cancelledBookings.assignAll(data.where((b) => 
          b['status'] == 'cancelled'
        ).toList());

        print("DEBUG: Loaded ${data.length} bookings total");
        print("DEBUG: Accepted: ${acceptedBookings.length}, Completed: ${completedBookings.length}, Cancelled: ${cancelledBookings.length}");
      }
    } catch (e) {
      print("Error fetching booking history: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateBookingStatusLocally(String targetId, String newStatus) {
    bool updated = false;
    
    for (var list in [acceptedBookings, completedBookings, cancelledBookings]) {
      int idx = list.indexWhere((b) => b['id'].toString() == targetId || b['booking_id'].toString() == targetId);
      if (idx != -1) {
        list[idx] = { ...list[idx], 'status': newStatus };
        updated = true;
      }
    }
    
    if (updated) {
      final allBookings = [
        ...acceptedBookings,
        ...completedBookings,
        ...cancelledBookings
      ];
      
      acceptedBookings.assignAll(allBookings.where((b) => 
        ['confirmed', 'accepted', 'on_way', 'on_the_way', 'arrived', 'working'].contains(b['status'])
      ).toList());
      
      completedBookings.assignAll(allBookings.where((b) => 
        b['status'] == 'completed'
      ).toList());
      
      cancelledBookings.assignAll(allBookings.where((b) => 
        b['status'] == 'cancelled'
      ).toList());
    }
  }
}
