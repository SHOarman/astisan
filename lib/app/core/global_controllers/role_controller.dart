import 'package:get/get.dart';

class RoleController extends GetxController {
  // Observable role, defaults to 'client'
  final RxString currentRole = 'client'.obs;

  void setRole(String role) {
    if (role == 'client' || role == 'worker') {
      currentRole.value = role;
    }
  }

  bool get isClient => currentRole.value == 'client';
  bool get isWorker => currentRole.value == 'worker';
}

