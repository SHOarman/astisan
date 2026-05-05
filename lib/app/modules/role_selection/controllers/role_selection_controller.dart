import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/global_controllers/role_controller.dart';

class RoleSelectionController extends GetxController {
  final selectedRole = ''.obs;

  void selectRole(String role) {
    selectedRole.value = role;

    final roleController = Get.find<RoleController>();

    if (role == 'help') {
      roleController.setRole('client');
      Get.offAllNamed(Routes.LOGIN);
    } else if (role == 'work') {
      roleController.setRole('worker');

       Get.offAllNamed(Routes.sing_in);
    }
  }
}