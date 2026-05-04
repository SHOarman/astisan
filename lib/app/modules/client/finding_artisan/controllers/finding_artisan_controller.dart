import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class FindingArtisanController extends GetxController {
  final isFound = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Check if we should skip the searching state (e.g., from Confirm Booking)
    if (Get.arguments != null && Get.arguments is Map && Get.arguments['skip_searching_state'] == true) {
      isFound.value = true;
    } else {
      // Simulate finding artisan process
      Future.delayed(const Duration(seconds: 4), () {
        isFound.value = true;
      });
    }
  }

  void trackArtisan() {
    Get.offNamed(Routes.TRACKING);
  }
}

