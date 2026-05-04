import 'package:get/get.dart';

class EarningsController extends GetxController {
  final selectedFilter = 'Week'.obs;

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  final transactions = [
    {
      'title': 'Pipe Leak Repair',
      'client': 'Jennifer M.',
      'time': 'Today • 11:45 AM',
      'amount': '+\$75',
      'status': 'PAID',
    },
    {
      'title': 'Faucet Fix',
      'client': 'Maria S.',
      'time': 'Today • 3:20 PM',
      'amount': '+\$55',
      'status': 'PAID',
    },
    {
      'title': 'Drain Cleaning',
      'client': 'Robert C.',
      'time': 'Yesterday • 9:00 AM',
      'amount': '+\$90',
      'status': 'PAID',
    },
    {
      'title': 'Toilet Repair',
      'client': 'Alice T.',
      'time': 'Apr 5 • 2:00 PM',
      'amount': '+\$60',
      'status': 'PAID',
    },
    {
      'title': 'Water Heater',
      'client': 'James L.',
      'time': 'Apr 4 • 10:30 AM',
      'amount': '+\$145',
      'status': 'PAID',
    },
  ].obs;

  final chartData = [
    {'day': 'Mon', 'amount': '85', 'value': 0.4},
    {'day': 'Tue', 'amount': '120', 'value': 0.6},
    {'day': 'Wed', 'amount': '65', 'value': 0.3},
    {'day': 'Thu', 'amount': '145', 'value': 0.75},
    {'day': 'Fri', 'amount': '95', 'value': 0.5},
    {'day': 'Sat', 'amount': '175', 'value': 0.9, 'hightlight': true},
    {'day': 'Sun', 'amount': '55', 'value': 0.25},
  ].obs;
}

