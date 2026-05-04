import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class WorkerAccountSettingsController extends GetxController {
  void navigateToSavedAddresses() {
    Get.toNamed(Routes.WORKER_SAVED_ADDRESSES);
  }

  void navigateToPaymentMethods() {
    Get.toNamed(Routes.WORKER_PAYMENT_METHOD);
  }
}
