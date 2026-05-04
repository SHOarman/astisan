import 'package:get/get.dart';

class PerformanceController extends GetxController {
  final totalJobs = 203.obs;
  final avgRating = 4.9.obs;
  final completionRate = 98.obs;
  final onTimeArrival = 95.obs;

  final recentJobStats = <Map<String, dynamic>>[
    {
      'service': 'Kitchen Sink Leak',
      'date': 'Oct 20, 2023',
      'completionTime': '45 mins',
      'rating': 5.0,
    },
    {
      'service': 'AC Filter Cleaning',
      'date': 'Oct 18, 2023',
      'completionTime': '30 mins',
      'rating': 5.0,
    },
    {
      'service': 'Light Fixture Install',
      'date': 'Oct 16, 2023',
      'completionTime': '1 hr 15 mins',
      'rating': 4.0,
    },
    {
      'service': 'Master Bath Tap Fix',
      'date': 'Oct 12, 2023',
      'completionTime': '25 mins',
      'rating': 5.0,
    },
    {
      'service': 'CCTV Camera Setup',
      'date': 'Oct 08, 2023',
      'completionTime': '2 hrs 30 mins',
      'rating': 5.0,
    },
  ].obs;
}
