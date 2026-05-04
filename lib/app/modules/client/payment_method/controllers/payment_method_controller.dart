import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class PaymentMethodController extends GetxController {
  final savedCards = <Map<String, dynamic>>[
    {
      'type': 'Visa',
      'number': '•••••25544',
      'expiry': 'Expires 11/26',
      'image': 'assets/images/visa_logo.png',
    },
    {
      'type': 'Master',
      'number': '•••••25544',
      'expiry': 'Expires 11/26',
      'image': 'assets/images/master_logo.png',
    },
  ].obs;

  void addPaymentMethod() {
    Get.toNamed(Routes.ADD_CARD);
  }
}
