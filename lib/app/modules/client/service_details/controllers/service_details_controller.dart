import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class ServiceDetailsController extends GetxController {
  final isFavorite = false.obs;
  final selectedTab = 0.obs; // 0 for Overview, 1 for Reviews

  final whatsIncluded = [
    'Initial inspection & diagnosis',
    'All required parts & materials',
    'Professional installation',
    '90-day service guarantee',
  ];

  final reviews = [
    {
      'name': 'Sarah Williams',
      'date': '2 days ago',
      'rating': 5,
      'comment': 'Excellent service, the plumber arrived on time and fixed the leak perfectly. Highly recommended!',
      'image': 'assets/images/home/Sarah Williams.png',
    },
    {
      'name': 'David Carter',
      'date': '1 week ago',
      'rating': 4,
      'comment': 'Great job fixing the wiring issues. Very professional and efficient.',
      'image': 'assets/images/home/Daniel Carter.png',
    },
    {
      'name': 'Michael Jordan',
      'date': '2 weeks ago',
      'rating': 5,
      'comment': 'The team was very helpful and the quality of work was outstanding.',
      'image': 'assets/images/placeholder_avatar.png',
    },
  ].obs;

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void bookNow() {
    Get.toNamed(Routes.BOOKING);
  }
}

