import 'package:get/get.dart';
import '../../worker/account/controllers/worker_account_controller.dart';
import '../../worker/dashboard/controllers/worker_home_controller.dart';

class DashboardController extends GetxController {
  final currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
    
    // Refresh Worker Account when opening the Account tab (index 3)
    if (index == 3) {
      if (Get.isRegistered<WorkerAccountController>()) {
        Get.find<WorkerAccountController>().fetchProfile();
      }
    }
    
    // Refresh Worker Dashboard when opening the Dashboard tab (index 0)
    if (index == 0) {
      if (Get.isRegistered<WorkerHomeController>()) {
        Get.find<WorkerHomeController>().fetchCurrentStatus();
        Get.find<WorkerHomeController>().fetchTodaySchedule();
      }
    }
  }
}

