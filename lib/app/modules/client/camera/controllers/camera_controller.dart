import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../booking/controllers/booking_controller.dart';
import '../../../../core/routes/app_routes.dart';

class CameraController extends GetxController {
  final isCaptured = false.obs;
  final ImagePicker _picker = ImagePicker();
  final imagePath = ''.obs;
  
  @override
  void onReady() {
    super.onReady();
    capturePhoto();
  }
  
  Future<void> capturePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 50,
        maxWidth: 1080,
        maxHeight: 1080,
      );
      
      if (photo != null) {
        imagePath.value = photo.path;
        isCaptured.value = true;
        
        final bookingController = Get.find<BookingController>();
        bookingController.capturedImagePath.value = photo.path;
      }
    } catch (e) {
      print("Error picking image: $e");
      Get.snackbar('Error'.tr, 'Could not open camera.'.tr);
    }
  }

  void retakePhoto() {
    isCaptured.value = false;
    imagePath.value = '';
  }

  void proceedToNext() {
    try {
      if (Get.isRegistered<BookingController>()) {
        final bc = Get.find<BookingController>();
        if (bc.selectedArtisan.isNotEmpty) {
          bc.currentStep.value = 5;
          Get.back();
          return;
        }
      }
      
      Get.toNamed(Routes.FINDING_ARTISAN, arguments: {
        'service': Get.arguments != null ? Get.arguments['service'] : {},
        'image': imagePath.value,
      });
    } catch (e) {
      Get.snackbar('Error'.tr, 'Something went wrong.'.tr);
    }
  }
}
