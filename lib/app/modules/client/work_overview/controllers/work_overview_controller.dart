import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class WorkOverviewController extends GetxController {
  final completedTasks = [
    'Main pipe leak fixed',
    'Under-sink pipe replaced',
    'Pressure valve adjusted',
    'System pressure test',
  ];

  void goToPay() {
    Get.toNamed(Routes.PAYMENT);
  }

  void sign() {
    // Open signature dialog
  }
}

