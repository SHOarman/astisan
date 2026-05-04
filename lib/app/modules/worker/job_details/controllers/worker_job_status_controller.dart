import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class WorkerJobStatusController extends GetxController {
  // Mock Data for Design Match
  final clientName = "James Wilson".obs;
  final clientRating = 4.9.obs;
  final clientCategory = "Plumbing Expert".obs;
  final clientImage = "assets/images/home/Sarah Williams.png".obs; // Using Sarah Williams placeholder

  final serviceName = "Pipe Repair".obs;
  final clientAddress = "123 Main St, NY".obs;
  final estimatedCost = "\$65 - \$120".obs;
  final jobStartTime = "10:18 AM".obs;
  final elapsedMinutes = 34.obs;

  final timeline = <Map<String, dynamic>>[
    {
      'title': 'Job Accepted',
      'sub': 'Your accepted the job',
      'time': '09:45 AM',
      'status': 'completed',
    },
    {
      'title': 'On the Way',
      'sub': 'Artisan is heading to your location',
      'time': '10:00 AM',
      'status': 'completed',
    },
    {
      'title': 'Working',
      'sub': 'Service in progress at your location',
      'time': '10:18 AM',
      'status': 'current',
    },
    {
      'title': 'Completed',
      'sub': 'Service has been completed',
      'time': 'Pending',
      'status': 'upcoming',
    },
  ].obs;

  void markAsComplete() {
    Get.toNamed(Routes.JOB_COMPLETION);
  }

  void openChat() {
    Get.toNamed(Routes.WORKER_CHAT);
  }
}
