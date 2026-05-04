import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import './app/core/constants/static/app_strings.dart';
import './app/core/routes/app_pages.dart';
import './app/core/routes/app_routes.dart';
import './app/core/theme/app_theme.dart';
import './app/core/global_controllers/role_controller.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RoleController(), permanent: true);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      title: 'Fixgo Artisan Platform',
      theme: AppTheme.lightTheme,
      translations: AppStrings(), // Applying generated localized strings
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
      builder: (context, child) {
        child = DevicePreview.appBuilder(context, child);
        child = ResponsiveBreakpoints.builder(
          child: child,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        );
        return child;
      },
    );
  }
}

