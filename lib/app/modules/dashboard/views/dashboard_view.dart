import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/static/app_colors.dart';
import '../../../core/components/custom_bottom_nav_bar.dart';
import '../../client/activity/views/activity_view.dart';
import '../../client/home/views/home_view.dart';
import '../../client/profile/views/profile_view.dart';
import '../../client/services/views/services_view.dart';
import '../../worker/dashboard/views/worker_dashboard_view.dart';
import '../../worker/incoming_requests/views/incoming_requests_view.dart';
import '../../worker/earnings/views/earnings_view.dart';
import '../../worker/account/views/worker_account_view.dart';
import '../../../core/constants/static/app_images.dart';
import '../../../core/global_controllers/role_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Explicitly initialize controller here to prevent crashes if route bindings are bypassed
    Get.put(DashboardController());
    final roleController = Get.find<RoleController>();

    final List<NavItemData> clientItems = [
      NavItemData(label: 'Home', icon: AppImages.navHome),
      NavItemData(label: 'Services', icon: AppImages.navServices),
      NavItemData(label: 'Activity', icon: AppImages.navActivity),
      NavItemData(label: 'Account', icon: AppImages.navProfile),
    ];

    final List<NavItemData> workerItems = [
      NavItemData(label: 'Dashboard', icon: Icons.grid_view_rounded),
      NavItemData(label: 'Notifications', icon: Icons.notifications_none_rounded),
      NavItemData(label: 'Earnings', icon: Icons.attach_money_rounded),
      NavItemData(label: 'Account', icon: Icons.person_outline_rounded),
    ];

    return Obx(() {
      final isWorker = roleController.isWorker;
      
      if (isWorker) {
        // Placeholder for Worker screens in IndexedStack
        return Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              WorkerDashboardView(),
              IncomingRequestsView(),
              EarningsView(),
              WorkerAccountView(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage,
            items: workerItems,
          ),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomeView(),
            ServicesView(),
            ActivityView(),
            ProfileView(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          items: clientItems,
        ),
      );
    });
  }
}

