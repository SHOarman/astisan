import 'package:get/get.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/routes/app_routes.dart';

class WorkerPaymentMethodController extends GetxController {
  final savedCards = <Map<String, dynamic>>[
    {
      'type': 'Visa',
      'number': '**** **** **** 4242',
      'expiry': 'Expires 12/28',
      'imagePath': AppImages.visaLogo,
    },
    {
      'type': 'MasterCard',
      'number': '**** **** **** 5555',
      'expiry': 'Expires 05/26',
      'imagePath': AppImages.masterLogo,
    },
  ].obs;

  void addNewPaymentMethod() {
    Get.toNamed(Routes.WORKER_ADD_CARD, arguments: {'isEditing': false});
  }

  void editCard(Map<String, dynamic> card) {
    Get.toNamed(Routes.WORKER_ADD_CARD, arguments: {'isEditing': true, 'card': card});
  }
}
