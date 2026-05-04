import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class TrackingController extends GetxController {
  final isArrived = false.obs;


  final String artisanName = "James Wilson";
  final double rating = 4.9;
  final String profession = "Plumbing Expert";
  final String artisanImageUrl = "https://i.pravatar.cc/150?img=11"; // Placeholder image

  final String serviceName = "Pipe Repair";
  final String location = "123 Main St, NY";
  final String estimatedCost = "\$65 – \$120";
  final String jobStartTime = "10:18 AM";

  final int elapsedMinutes = 34;
  final double progressPercent = 0.75;

  void toggleState() {
    isArrived.value = !isArrived.value;
  }

  void goToChat() {
    Get.toNamed(Routes.CHAT);
  } void goToWorkOverview() {
    Get.toNamed(Routes.WORK_OVERVIEW);
  }

  void viewCompletionWork() {
    Get.toNamed(Routes.WORK_OVERVIEW);
  }
}

