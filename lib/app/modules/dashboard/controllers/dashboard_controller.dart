import 'package:get/get.dart';
import '../../worker/account/controllers/worker_account_controller.dart';
import '../../worker/dashboard/controllers/worker_home_controller.dart';

class DashboardController extends GetxController {
  final currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
    
    if (index == 3) {
      if (Get.isRegistered<WorkerAccountController>()) {
        Get.find<WorkerAccountController>().fetchProfile();
      }
    }
    
    if (index == 0) {
      if (Get.isRegistered<WorkerHomeController>()) {
        Get.find<WorkerHomeController>().fetchCurrentStatus();
        Get.find<WorkerHomeController>().fetchTodaySchedule();
      }
    }
  }
}

