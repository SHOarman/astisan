import 'package:get/get.dart';
import '../../../../core/constants/static/app_strings.dart';
import 'package:artisan/app/core/constants/static/app_images.dart';

class ActivityController extends GetxController {
  final filters = [
    AppStrings.all.tr,
    AppStrings.completed.tr,
    AppStrings.cancelled.tr,
    AppStrings.upcoming.tr,
  ].obs;

  final selectedFilter = AppStrings.all.tr.obs;

  final orders = <Map<String, dynamic>>[
    {
      'title': 'Pipe Repair',
      'artisanName': 'James Wilson',
      'date': 'March 28, 2026',
      'price': '\$85',
      'status': AppStrings.completed.tr,
      'image': AppImages.homePipeLeak,
      'avatar': AppImages.homeMarcusJohnson,
    },
    {
      'title': 'Full House Cleaning',
      'artisanName': 'Sarah Ahmed',
      'date': 'March 15, 2026',
      'price': '\$160',
      'status': AppStrings.completed.tr,
      'image': AppImages.homeDeepCleaning,
      'avatar': AppImages.homeSarahWilliams,
    },
    {
      'title': 'Electrical Installation',
      'artisanName': 'Mike Chen',
      'date': 'Feb 20, 2026',
      'price': '\$120',
      'status': AppStrings.cancelled.tr,
      'image': AppImages.homeElectricalWiring,
      'avatar': AppImages.homeDanielCarter,
    },
    {
      'title': 'Garden Maintenance',
      'artisanName': 'Linda Park',
      'date': 'Feb 5, 2026',
      'price': '\$75',
      'status': AppStrings.completed.tr,
      'image': AppImages.popPipeLeak, // Just using another available image as garden placeholder if not found
      'avatar': AppImages.placeholderAvatar,
    },
  ].obs;

  List<Map<String, dynamic>> get filteredOrders {
    if (selectedFilter.value == AppStrings.all.tr) return orders;
    return orders.where((order) => order['status'] == selectedFilter.value).toList();
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  int getFilterCount(String filter) {
    if (filter == AppStrings.all.tr) return 0;
    return orders.where((order) => order['status'] == filter).length;
  }
}
