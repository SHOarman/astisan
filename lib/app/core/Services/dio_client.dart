import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../global_controllers/role_controller.dart';
import 'api_services.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    if (_dio == null) {
      _dio = Dio(BaseOptions(
        baseUrl: ApiServices.baseurl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ));

      // Add Interceptor to inject Token and Language dynamically
      _dio!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // 1. Inject language
            String lang = 'en'; // default
            if (Get.isRegistered<RoleController>()) {
              final roleController = Get.find<RoleController>();
              lang = roleController.isClient 
                ? roleController.clientLanguage.value 
                : roleController.workerLanguage.value;
            }
            options.headers['Accept-Language'] = lang;

            // 2. Inject token if available
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('token');
            if (token != null && token.isNotEmpty && token != 'null') {
              final cleanToken = token.trim().replaceAll('"', '').replaceAll('Bearer ', '');
              options.headers['Authorization'] = 'Bearer $cleanToken';
            }

            return handler.next(options);
          },
          onResponse: (response, handler) {
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            print("Dio Error: \${e.message}");
            return handler.next(e);
          },
        ),
      );
    }
    return _dio!;
  }
}
