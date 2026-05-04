import 'package:get/get.dart';

class SubCategoryController extends GetxController {
  final categoryData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      categoryData.value = Map<String, dynamic>.from(Get.arguments);
    }
  }

  String get title => categoryData['title'] ?? 'Services';
  List<dynamic> get subcategories => categoryData['subcategories'] ?? [];
}

