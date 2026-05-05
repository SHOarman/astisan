

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../modules/auth_worker/auth_controller_worker/auth_worker_controller.dart';

class DependencyInjection {

  static void bindings() {


    //=================================================auth_worker==================================================

    Get.lazyPut<AuthWorkerController>(() => AuthWorkerController());













  }
}