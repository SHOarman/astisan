import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';

class SelectLocationController extends GetxController {
  // Observables for state
  final isLocationSelected = false.obs;
  final selectedCity = 'Dubai'.obs;
  final selectedAddress = 'Al Barsha First, Dubai, UAE'.obs;

  // Simulate map movement/interaction
  void onMapInteraction() {
    if (!isLocationSelected.value) {
      isLocationSelected.value = true;
      // In a real app, reverse geocoding would happen here
      selectedAddress.value = '23 Sheikh Zayed Rd, Dubai, UAE'; 
    }
  }

  void onMyLocationTapped() {
    // Reset or jump to user's actual location
    isLocationSelected.value = false;
    selectedAddress.value = 'Current Location';
  }

  void setAddress() {
    try {
      final homeController = Get.find<HomeController>();
      homeController.updateAddress(selectedCity.value, selectedAddress.value);
      Get.back();
    } catch (e) {
      Get.back();
    }
  }
}
