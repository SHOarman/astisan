import 'package:get/get.dart';
import '../../../../core/constants/static/app_images.dart';

class NotificationController extends GetxController {
  final todayNotifications = <Map<String, dynamic>>[
    {
      'title': 'Booking Confirmed!',
      'subtitle': 'James Wilson will arrive at 10:00 AM tomorrow',
      'time': '2 min ago',
      'icon': AppImages.notifBookingConfirmed,
      'isUnread': true,
    },
    {
      'title': 'Artisan on the way',
      'subtitle': 'Your artisan is 5 minutes away',
      'time': '15 min ago',
      'icon': AppImages.notifArtisOnWay,
      'isUnread': true,
      'type': 'tracking',
    },
    {
      'title': 'Payment Successful',
      'subtitle': 'Your payment of \$85 was processed successfully',
      'time': '1 hour ago',
      'icon': AppImages.notifPaymentSuccess,
      'isUnread': false,
    },
  ].obs;

  final earlierNotifications = <Map<String, dynamic>>[
    {
      'title': 'Rate your experience',
      'subtitle': 'How was your service with James Wilson?',
      'time': '2 hours ago',
      'icon': AppImages.notifRateExperience,
      'isUnread': false,
    },
    {
      'title': 'Special Offer 🥳',
      'subtitle': 'Get 20% off your next cleaning service today!',
      'time': '1 day ago',
      'icon': AppImages.notifSpecialOffer,
      'isUnread': false,
    },
    {
      'title': 'Service Completed',
      'subtitle': 'Full House Cleaning marked as done',
      'time': '2 days ago',
      'icon': AppImages.notifServiceCompleted,
      'isUnread': false,
    },
  ].obs;

  int get unreadTodayCount => todayNotifications.where((n) => n['isUnread']).length;

  void markAllAsRead() {
    for (var n in todayNotifications) {
      n['isUnread'] = false;
    }
    todayNotifications.refresh();
  }
}
