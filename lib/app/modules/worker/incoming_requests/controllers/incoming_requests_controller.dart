import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';

class IncomingRequestsController extends GetxController {
  final requests = [
    {
      'clientName': 'Jennifer Martinez',
      'serviceTitle': 'Pipe Leak Repair',
      'address': '48 Elm Street, Downtown',
      'distance': '1.2 km',
      'time': '5 min',
      'price': '\$75',
      'tag': 'URGENT',
    },
    {
      'clientName': 'David Wilson',
      'serviceTitle': 'Bathroom Faucet Fix',
      'address': '219 Park Ave, Midtown',
      'distance': '3.9 km',
      'time': '15 min',
      'price': '\$55',
      'tag': 'NORMAL',
    },
    {
      'clientName': 'Sarah Thompson',
      'serviceTitle': 'Electric Circuit Fix',
      'address': '12 Oak Lane, North',
      'distance': '2.1 km',
      'time': '8 min',
      'price': '\$120',
      'tag': 'URGENT',
    },
    {
      'clientName': 'Michael Brown',
      'serviceTitle': 'Deep Cleaning',
      'address': '77 Sunset Blvd',
      'distance': '5.5 km',
      'time': '20 min',
      'price': '\$150',
      'tag': 'NORMAL',
    },
    {
      'clientName': 'Emily Davis',
      'serviceTitle': 'Door Lock Repair',
      'address': '34 High Ridge Rd',
      'distance': '4.2 km',
      'time': '12 min',
      'price': '\$65',
      'tag': 'NORMAL',
    },
  ].obs;

  void acceptRequest(int index) {
    Get.toNamed(Routes.WORKER_JOB_DETAILS);
  }

  void declineRequest(int index) {
    // Logic to decline
  }
}

