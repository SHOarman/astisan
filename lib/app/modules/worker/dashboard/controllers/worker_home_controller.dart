import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class WorkerHomeController extends GetxController {
  final isOnline = true.obs;

  void toggleStatus(bool value) {
    isOnline.value = value;
  }

  void goToJobDetails() {
    Get.toNamed(Routes.WORKER_JOB_DETAILS);
  }

  void goToChat() {
    Get.toNamed(Routes.WORKER_CHAT);
  }

  // Dummy data for list rendering
  final scheduleItems = [
    {
      'title': 'Pipe Leak Repair',
      'client': 'Alex Thompson',
      'time': '10:00 AM',
      'distance': '1.8 km',
      'price': '\$75',
      'duration': '2 hrs',
      'status': 'ONGOING',
    },
    {
      'title': 'Faucet Installation',
      'client': 'Maria Santos',
      'time': '2:00 PM',
      'distance': '3.2 km',
      'price': '\$55',
      'duration': '1 hr',
      'status': 'UPCOMING',
    },
    {
      'title': 'Bathroom Remodeling',
      'client': 'Robert Chen',
      'time': '9:00 AM',
      'distance': '5.1 km',
      'price': '\$200',
      'duration': '4 hrs',
      'status': 'UPCOMING',
    },
  ].obs;

  final weeklySummary = [
    {
      'icon': '💰',
      'value': '\$425',
      'label': 'Earnings',
    },
    {
      'icon': '✅',
      'value': '8',
      'label': 'Jobs Done',
    },
    {
      'icon': '⭐',
      'value': '4.9★',
      'label': 'Avg Rating',
    },
  ].obs;
}

