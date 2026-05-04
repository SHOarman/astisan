import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class WorkerTrackingController extends GetxController {
  // Timeline steps: 0: Job Accepted, 1: On the Way, 2: Working, 3: Completed
  final currentStep = 2.obs; 

  @override
  void onInit() {
    super.onInit();
    simulateCompletion();
  }

  void simulateCompletion() async {
    // Wait for 4 seconds then mark as completed
    await Future.delayed(const Duration(seconds: 4));
    currentStep.value = 3;
  }

  void markAsComplete() {
    if (currentStep.value == 3) {
      Get.toNamed(Routes.JOB_COMPLETION);
    }
  }

  void goToChat() {
    Get.toNamed(Routes.WORKER_CHAT);
  }
}
